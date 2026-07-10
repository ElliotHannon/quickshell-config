// components/popups/WifiPopup.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../services" as Services

Item {
    id: root
    anchors.fill: parent
    
    property color textColor: "#ffffff"
    property color accentColor1: "#00ffa6"
    property color accentColor2: "#00a6ff"
    property color mutedColor: "#888888"
    property color borderColor: "#3a4c5e"
    
    ColumnLayout {
        anchors {
            fill: parent
            margins: 12
        }
        spacing: 12
        
        // Header with toggle
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "Wi-Fi"
                color: textColor
                font.pointSize: 14
                font.bold: true
            }
            
            Item { Layout.fillWidth: true }
            
            Rectangle {
                width: 50
                height: 24
                radius: 12
                color: Services.Network.wifiEnabled ? accentColor1 : mutedColor
                
                Rectangle {
                    width: 20
                    height: 20
                    radius: 10
                    color: "#ffffff"
                    anchors.verticalCenter: parent.verticalCenter
                    x: Services.Network.wifiEnabled ? parent.width - width - 2 : 2
                    
                    Behavior on x {
                        NumberAnimation { duration: 150 }
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: Services.Network.toggleWifi()
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
        
        Text {
            text: {
                if (!Services.Network.wifiEnabled) return "WiFi is disabled"
                if (Services.Network.ethernetConnected) return "Connected via Ethernet"
                if (Services.Network.active) return "Connected to " + Services.Network.active.ssid
                return "Not connected"
            }
            color: mutedColor
            font.pointSize: 10
            visible: text !== ""
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: borderColor
        }
        
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "Networks"
                color: textColor
                font.pointSize: 12
                font.bold: true
            }
            
            Item { Layout.fillWidth: true }
            
            Text {
                text: "󰑐" 
                color: accentColor2
                font.pointSize: 16
                font.family: "Nerd-font"
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: Services.Network.rescanWifi()
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
        
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4
            
            model: Services.Network.networks
            
            delegate: Rectangle {
                width: ListView.view.width
                height: 40
                color: "transparent"
                radius: 8
                
                Rectangle {
                    anchors.fill: parent
                    color: modelData.active ? accentColor1 : "transparent"
                    opacity: modelData.active ? 0.1 : 0
                    radius: 8
                }
                
                RowLayout {
                    anchors {
                        fill: parent
                        margins: 8
                    }
                    spacing: 8
                    
                    Text {
                        text: {
                            if (modelData.strength >= 80) return "▂▄▆█"
                            if (modelData.strength >= 60) return "▂▄▆_"
                            if (modelData.strength >= 40) return "▂▄__"
                            if (modelData.strength >= 20) return "▂___"
                            return "____"
                        }
                        color: modelData.active ? accentColor1 : textColor
                        font.pointSize: 12
                    }
                    
                    Text {
                        text: modelData.ssid
                        color: textColor
                        font.pointSize: 11
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                    
                    Text {
                        text: modelData.active ? "✓" : ""
                        color: accentColor1
                        font.pointSize: 12
                        visible: modelData.active
                    }

                    Text {
                        color: accentColor1
                        text: modelData.security ? "󰌾" : ""
                        font.pointSize: 10
                        visible: modelData.security.length > 0
                    }
                    
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (modelData.active) {
                            Services.Network.disconnectFromNetwork()
                        } else {
                            Services.Network.connectToNetwork(modelData.ssid)
                        }
                    }
                }
            }
        }
    }
}
