// components/barWidgets/Bluetooth.qml
import Quickshell
import QtQuick
import "../../services" as Services

Item {
    id: root
    
    property color textColor:       "#ffffbb"
    property color connectedColor:  "#55ff22"
    property color disabledColor:   "#888888"
    property int iconSize: 15

    implicitWidth: iconText.width
    implicitHeight: iconText.height
    
    Component.onCompleted: {
        console.log("Bluetooth widget loaded, status:", Services.Bluetooth.enabled)
    }
    
    Text {
        id: iconText
        anchors.centerIn: parent
        color: {
            if (!Services.Bluetooth.enabled) return disabledColor
            if (Services.Bluetooth.connected) return connectedColor
            return textColor
        }
        font.pointSize: root.iconSize
        font.family: "Nerd-font"
        text: {
            if (!Services.Bluetooth.enabled)
                return "󰂲 "
            if (Services.Bluetooth.connected)
                return "󰂱 "
            if (Services.Bluetooth.paired)
                return "󰂯 "
            return "󰂯 "
        }
        
        Behavior on color {
            ColorAnimation {
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }
    }
}
