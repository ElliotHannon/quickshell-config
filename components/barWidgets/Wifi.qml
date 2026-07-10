// components/barWidgets/Wifi.qml
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
        console.log("Wifi widget loaded, network status:", Services.Network.wifiEnabled)
    }
    
    Text {
        id: iconText
        anchors.centerIn: parent
        color: {
            if (!Services.Network.wifiEnabled) return disabledColor
            if (Services.Network.wifiConnected) return connectedColor
            return textColor
        }
        font.pointSize: root.iconSize
        font.family: "Nerd-font"
        text: {
            if (Services.Network.scanning || !Services.Network.startupFinished)
                return "󱛇 "
            if (Services.Network.ethernetConnected)
                return " "
            if (!Services.Network.wifiEnabled)
                return "󰤮 "
            if (Services.Network.wifiConnected)
                return "󱚻 "
            return "󱚼 "
        }
        
        Behavior on color {
            ColorAnimation {
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }
    }
}
