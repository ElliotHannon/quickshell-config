pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var devices: []
    property var connectedDevice: null
    property bool connected: false
    property string connectedDeviceName: ""
    property bool enabled: false
    property bool scanning: false
    property bool startupFinished: false

    Component.onCompleted: {
        console.log("=== Bluetooth Service Starting ===")
        bluetoothStatusProcess.running = true
        getDevicesProcess.running = true
    }

    function toggleBluetooth() {
        const cmd = root.enabled ? "off" : "on"
        console.log("Toggling Bluetooth to:", cmd)
        
        if (!root.enabled) {
            root.enabled = true
            toggleProcess.command = ["bluetoothctl", "power", "on"]
        } else {
            root.enabled = false
            root.devices = []
            root.connectedDevice = null
            root.connected = false
            root.connectedDeviceName = ""
            toggleProcess.command = ["bluetoothctl", "power", "off"]
        }
        toggleProcess.running = true
    }

    function scanDevices() {
        if (!root.enabled) {
            console.log("Bluetooth is disabled, can't scan")
            return
        }
        console.log("Starting Bluetooth scan...")
        root.scanning = true
        scanProcess.running = true
        
        scanTimer.start()
    }

    function connectDevice(address) {
        console.log("Connecting to device:", address)
        connectProcess.command = ["bluetoothctl", "connect", address]
        connectProcess.running = true
    }

    function disconnectDevice(address) {
        console.log("Disconnecting from device:", address)
        disconnectProcess.command = ["bluetoothctl", "disconnect", address]
        disconnectProcess.running = true
    }

    function pairDevice(address) {
        console.log("Pairing with device:", address)
        pairProcess.command = ["bluetoothctl", "pair", address]
        pairProcess.running = true
    }

    function removeDevice(address) {
        console.log("Removing device:", address)
        removeProcess.command = ["bluetoothctl", "remove", address]
        removeProcess.running = true
    }

    function getConnectionStatus() {
        console.log("Getting connection status...")
        connectionStatusProcess.running = true
    }

    function updateDeviceInfo(address, property, value) {
        for (var i = 0; i < root.devices.length; i++) {
            if (root.devices[i].address === address) {
                root.devices[i][property] = value
                break
            }
        }
    }

    Timer {
        id: scanTimer
        interval: 10000
        onTriggered: {
            console.log("Stopping Bluetooth scan")
            scanProcess.command = ["bluetoothctl", "scan", "off"]
            scanProcess.running = true
            root.scanning = false
            getDevicesProcess.running = true
        }
    }

    Process {
        id: monitorProcess
        running: true
        command: ["bluetoothctl", "monitor"]
        stdout: SplitParser {
            onRead: {
                console.log("Bluetooth change detected")
                getDevicesProcess.running = true
                bluetoothStatusProcess.running = true
            }
        }
        stderr: SplitParser {
            onRead: console.log("Monitor error:", data)
        }
    }

    Process {
        id: bluetoothStatusProcess
        command: ["bluetoothctl", "show"]
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            onStreamFinished: {
                const output = this.text.trim()
                console.log("Bluetooth status received")
                
                const powerMatch = output.match(/Powered:\s*(yes|no)/i)
                if (powerMatch) {
                    root.enabled = powerMatch[1].toLowerCase() === "yes"
                }
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.trim()) console.log("Bluetooth status error:", this.text)
            }
        }
    }

    Process {
        id: toggleProcess
        stdout: SplitParser {
            onRead: {
                console.log("Bluetooth toggle command completed")
                bluetoothStatusProcess.running = true
                
                if (root.enabled) {
                    console.log("Bluetooth turned on, scheduling scan...")
                    scanAfterToggle.start()
                }
            }
        }
        stderr: SplitParser {
            onRead: {
                console.log("Bluetooth toggle error:", data)
                bluetoothStatusProcess.running = true
            }
        }
    }

    Timer {
        id: scanAfterToggle
        interval: 200
        onTriggered: {
            console.log("Running post-enable scan...")
            scanDevices()
        }
    }

    Process {
        id: scanProcess
        command: ["bluetoothctl", "scan", "on"]
        stdout: SplitParser {
            onRead: {
                console.log("Scan output:", data)
            }
        }
        stderr: SplitParser {
            onRead: {
                console.log("Scan error:", data)
                root.scanning = false
            }
        }
    }

    Process {
        id: connectProcess
        stdout: SplitParser {
            onRead: {
                console.log("Connect result:", data)
                if (data.includes("Connection successful")) {
                    getDevicesProcess.running = true
                }
            }
        }
        stderr: SplitParser {
            onRead: console.log("Connect error:", data)
        }
    }

    Process {
        id: disconnectProcess
        stdout: SplitParser {
            onRead: {
                console.log("Disconnect result:", data)
                getDevicesProcess.running = true
            }
        }
        stderr: SplitParser {
            onRead: console.log("Disconnect error:", data)
        }
    }

    Process {
        id: pairProcess
        stdout: SplitParser {
            onRead: {
                console.log("Pair result:", data)
                getDevicesProcess.running = true
            }
        }
        stderr: SplitParser {
            onRead: console.log("Pair error:", data)
        }
    }

    Process {
        id: removeProcess
        stdout: SplitParser {
            onRead: {
                console.log("Remove result:", data)
                getDevicesProcess.running = true
            }
        }
        stderr: SplitParser {
            onRead: console.log("Remove error:", data)
        }
    }

    Process {
        id: getDevicesProcess
        running: false
        command: ["bluetoothctl", "devices"]
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            onStreamFinished: {
                const output = this.text.trim()
                console.log("=== Bluetooth devices ===")
                
                if (!output || !root.enabled) {
                    console.log("No devices or Bluetooth disabled")
                    root.devices = []
                    root.connectedDevice = null
                    root.connected = false
                    root.connectedDeviceName = ""
                    root.startupFinished = true
                    return
                }

                const deviceLines = output.split("\n")
                    .filter(line => line.trim().startsWith("Device "))
                    .map(line => {
                        const parts = line.trim().substring(7).split(" ")
                        const address = parts[0]
                        const name = parts.slice(1).join(" ") || "Unknown Device"
                        return {
                            address: address,
                            name: name,
                            paired: false,
                            connected: false,
                            trusted: false
                        }
                    })

                root.devices = deviceLines
                root.startupFinished = true
                
                getConnectionStatus()
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.trim()) {
                    console.log("Device scan ERROR:", this.text)
                }
                root.startupFinished = true
            }
        }
    }

    Process {
        id: connectionStatusProcess
        running: false
        command: ["bluetoothctl", "info"]
        stdout: StdioCollector {
            onStreamFinished: {
                const output = this.text.trim()
                console.log("Connection status received")
                
                // Reset all devices to not connected first
                for (var i = 0; i < root.devices.length; i++) {
                    root.devices[i].connected = false
                }
                
                const connectedMatch = output.match(/Connected:\s*(yes|no)/i)
                if (connectedMatch && connectedMatch[1].toLowerCase() === "yes") {
                    const nameMatch = output.match(/Name:\s*(.+)/i)
                    const addrMatch = output.match(/Device\s+([\da-fA-F:]+)/i)
                    
                    if (nameMatch && addrMatch) {
                        root.connected = true
                        root.connectedDeviceName = nameMatch[1].trim()
                        const address = addrMatch[1].trim()
                        
                        for (var j = 0; j < root.devices.length; j++) {
                            if (root.devices[j].address === address) {
                                root.devices[j].connected = true
                                root.connectedDevice = root.devices[j]
                                break
                            }
                        }
                    }
                } else {
                    root.connected = false
                    root.connectedDevice = null
                    root.connectedDeviceName = ""
                }
                
                console.log("Connected:", root.connected, "Device:", root.connectedDeviceName)
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.trim()) console.log("Connection status error:", this.text)
            }
        }
    }
}
