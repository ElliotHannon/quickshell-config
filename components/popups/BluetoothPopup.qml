// components/popups/BluetoothPopup.qml
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
        
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "Bluetooth"
                color: textColor
                font.pointSize: 14
                font.bold: true
            }
            
            Item { Layout.fillWidth: true }
            
            Rectangle {
                width: 50
                height: 24
                radius: 12
                color: Services.Bluetooth.enabled ? accentColor1 : mutedColor
                
                Rectangle {
                    width: 20
                    height: 20
                    radius: 10
                    color: "#ffffff"
                    anchors.verticalCenter: parent.verticalCenter
                    x: Services.Bluetooth.enabled ? parent.width - width - 2 : 2
                    
                    Behavior on x {
                        NumberAnimation { duration: 150 }
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: Services.Bluetooth.toggleBluetooth()
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
        
        Text {
            text: {
                if (!Services.Bluetooth.enabled) return "Bluetooth is disabled"
                if (Services.Bluetooth.connected) return "Connected to " + Services.Bluetooth.connectedDeviceName
                if (Services.Bluetooth.devices.length > 0) return Services.Bluetooth.devices.length + " device(s) available"
                return "No devices found"
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
                text: "Devices"
                color: textColor
                font.pointSize: 12
                font.bold: true
            }
            
            Item { Layout.fillWidth: true }
            
            Text {
                text: Services.Bluetooth.scanning ? "󰅄" : "󰑐"
                color: accentColor2
                font.pointSize: 16
                font.family: "Nerd-font"
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: Services.Bluetooth.scanDevices()
                    cursorShape: Qt.PointingHandCursor
                }
                
                RotationAnimation {
                    target: parent
                    property: "rotation"
                    from: 0
                    to: 360
                    duration: 1000
                    running: Services.Bluetooth.scanning
                    loops: Animation.Infinite
                }
            }
        }
        
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4
            
            model: Services.Bluetooth.devices
            
            delegate: Rectangle {
                width: ListView.view.width
                height: 40
                color: "transparent"
                radius: 8
                
                Rectangle {
                    anchors.fill: parent
                    color: modelData.connected ? accentColor1 : "transparent"
                    opacity: modelData.connected ? 0.1 : 0
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
                            if (modelData.connected) return "󰂱"
                            if (modelData.paired) return "󰂯"
                            return "󰂮"
                        }
                        color: modelData.connected ? accentColor1 : textColor
                        font.pointSize: 14
                        font.family: "Nerd-font"
                    }
                    
                    Text {
                        text: modelData.name
                        color: textColor
                        font.pointSize: 11
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                    
                    Text {
                        text: modelData.connected ? "✓" : ""
                        color: accentColor1
                        font.pointSize: 12
                        visible: modelData.connected
                    }
                    
                    Text {
                        text: modelData.paired ? "󰐿" : ""
                        color: accentColor2
                        font.pointSize: 10
                        font.family: "Nerd-font"
                        visible: modelData.paired && !modelData.connected
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (modelData.connected) {
                            Services.Bluetooth.disconnectDevice(modelData.address)
                        } else if (modelData.paired) {
                            Services.Bluetooth.connectDevice(modelData.address)
                        } else {
                            Services.Bluetooth.pairDevice(modelData.address)
                        }
                    }
                }
            }
        }
    }
}
