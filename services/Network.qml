pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var networks: []
    property var active: null
    property bool ethernetConnected: false
    property bool wifiConnected: false
    property bool wifiEnabled: true
    property bool scanning: false
    property bool startupFinished: false

    Component.onCompleted: {
        console.log("=== Network Service Starting ===")
        wifiStatusProcess.running = true
        ethernetStatusProcess.running = true
        getNetworks.running = true
    }

    function toggleWifi() {
        const cmd = root.wifiEnabled ? "off" : "on"
        console.log("Toggling WiFi to:", cmd)
        
        if (!root.wifiEnabled) {
            root.wifiEnabled = true  
            enableWifiProcess.command = ["nmcli", "radio", "wifi", "on"]
        } else {
            root.wifiEnabled = false
            root.networks = []  
            root.active = null
            root.wifiConnected = false
            enableWifiProcess.command = ["nmcli", "radio", "wifi", "off"]
        }
        enableWifiProcess.running = true
    }

    function rescanWifi() {
        if (!root.wifiEnabled) {
            console.log("WiFi is disabled, can't scan")
            return
        }
        console.log("Starting WiFi rescan...")
        root.scanning = true
        rescanProcess.running = true
    }

    function connectToNetwork(ssid) {
        console.log("Connecting to:", ssid)
        connectProcess.command = ["nmcli", "conn", "up", ssid]
        connectProcess.running = true
    }

    function disconnectFromNetwork() {
        if (root.active) {
            console.log("Disconnecting from:", root.active.ssid)
            disconnectProcess.command = ["nmcli", "connection", "down", root.active.ssid]
            disconnectProcess.running = true
        }
    }

    Process {
        id: monitorProcess
        running: true
        command: ["nmcli", "m"]
        stdout: SplitParser {
            onRead: {
                console.log("NM change detected")
                getNetworks.running = true
                ethernetStatusProcess.running = true
            }
        }
        stderr: SplitParser {
            onRead: console.log("Monitor error:", data)
        }
    }

    Process {
        id: wifiStatusProcess
        command: ["nmcli", "radio", "wifi"]
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            onStreamFinished: {
                const status = this.text.trim()
                console.log("WiFi radio status:", status)
                root.wifiEnabled = (status === "enabled")
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.trim()) console.log("WiFi status error:", this.text)
            }
        }
    }

    Process {
        id: enableWifiProcess
        stdout: SplitParser {
            onRead: {
                console.log("WiFi toggle command completed")
                wifiStatusProcess.running = true
                
                if (root.wifiEnabled) {
                    console.log("WiFi turned on, scheduling rescan...")
                    rescanAfterToggle.start()
                }
            }
        }
        stderr: SplitParser {
            onRead: {
                console.log("WiFi toggle error:", data)
                // Revert the optimistic update on error
                wifiStatusProcess.running = true
            }
        }
    }

    Timer {
        id: rescanAfterToggle
        interval: 100  
        onTriggered: {
            console.log("Running post-enable rescan...")
            root.scanning = true
            rescanProcess.running = true
        }
    }

    Process {
        id: ethernetStatusProcess
        command: ["nmcli", "dev", "status"]
        stdout: StdioCollector {
            onStreamFinished: {
                const text = this.text.trim()
                console.log("Device status received")
                let ethConnected = false
                let wifiConnected = false
                const lines = text.split("\n")
                for (let i = 1; i < lines.length; i++) {
                    const line = lines[i].trim()
                    if (line.includes("ethernet") && line.includes("connected")) {
                        ethConnected = true
                    }
                    if (line.includes("wifi") && line.includes("connected")) {
                        wifiConnected = true
                    }
                }
                root.ethernetConnected = ethConnected
                root.wifiConnected = wifiConnected
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.trim()) console.log("Device status error:", this.text)
            }
        }
    }

    Process {
        id: rescanProcess
        command: ["nmcli", "dev", "wifi", "list", "--rescan", "yes"]
        stdout: SplitParser {
            onRead: {
                console.log("Rescan complete")
                root.scanning = false
                getNetworks.running = true
            }
        }
        stderr: SplitParser {
            onRead: {
                console.log("Rescan error:", data)
                root.scanning = false
                getNetworks.running = true
            }
        }
    }

    // Connect
    Process {
        id: connectProcess
        stdout: SplitParser {
            onRead: {
                console.log("Connect result:", data)
                getNetworks.running = true
            }
        }
        stderr: SplitParser {
            onRead: console.log("Connect error:", data)
        }
    }

    // Disconnect
    Process {
        id: disconnectProcess
        stdout: SplitParser {
            onRead: {
                console.log("Disconnect result:", data)
                getNetworks.running = true
            }
        }
        stderr: SplitParser {
            onRead: console.log("Disconnect error:", data)
        }
    }

    // Get networks
    Process {
        id: getNetworks
        running: false
        command: ["nmcli", "-g", "ACTIVE,SIGNAL,FREQ,SSID,BSSID,SECURITY", "d", "w"]
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            onStreamFinished: {
                const rawText = this.text.trim()
                console.log("=== Network scan ===")
                
                if (!rawText || !root.wifiEnabled) {
                    console.log("No networks or WiFi disabled")
                    root.networks = []
                    root.active = null
                    root.wifiConnected = false
                    root.startupFinished = true
                    return
                }

                const PLACEHOLDER = "ESCCOLON"
                const MIN_SIGNAL_STRENGTH = 20
                
                const networks = rawText.split("\n")
                    .filter(line => line.trim().length > 0)
                    .map(line => {
                        const cleanLine = line.replace(/\\:/g, PLACEHOLDER)
                        const parts = cleanLine.split(":")
                        return {
                            active: parts[0] === "yes",
                            strength: parseInt(parts[1]) || 0,
                            frequency: parseInt(parts[2]) || 0,
                            ssid: parts[3] || "",
                            bssid: (parts[4] || "").replace(new RegExp(PLACEHOLDER, "g"), ":"),
                            security: parts[5] || ""
                        }
                    })
                    .filter(n => n.ssid.length > 0 && n.strength >= MIN_SIGNAL_STRENGTH)

                // Deduplicate and sort
                const networkMap = new Map()
                for (const net of networks) {
                    const existing = networkMap.get(net.ssid)
                    if (!existing || (net.active && !existing.active) || 
                        (!net.active && !existing.active && net.strength > existing.strength)) {
                        networkMap.set(net.ssid, net)
                    }
                }

                root.networks = Array.from(networkMap.values()).sort((a, b) => {
                    if (a.active && !b.active) return -1
                    if (!a.active && b.active) return 1
                    return b.strength - a.strength
                })
                
                root.active = root.networks.find(n => n.active) || null
                root.wifiConnected = root.active !== null
                root.startupFinished = true
                
                console.log("Networks:", root.networks.length, "Active:", root.active ? root.active.ssid : "none")
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.trim()) {
                    console.log("Network scan ERROR:", this.text)
                }
            }
        }
    }
}
