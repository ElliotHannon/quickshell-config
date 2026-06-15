// components/barWidgets/Clock.qml
import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root
    
    // Fixed explicit size
    implicitWidth: 30
    implicitHeight: 30

    property color clockColor:  "#ffffff"
    property color hoverInCol:  "#334466"
    property color hoverOutCol: "#529810"
    property int fontSize: 14
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: timeDisplay.color = hoverInCol
        onExited: timeDisplay.color = hoverOutCol
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    
    Text {
        id: timeDisplay
        anchors.centerIn: parent
        color: clockColor
        font.pointSize: fontSize
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter  // Center text vertically in its bounds
        lineHeight: 0.55
        lineHeightMode: Text.ProportionalHeight
        
        // Force the text to be centered by using a fixed height
        height: parent.height
        width: parent.width

        Process {
            id: timeRefresh
            command: ["date", "+%H:%M"]
            running: true
            stdout: StdioCollector {
                property var time: this.text.split(":")
                onStreamFinished: timeDisplay.text = time[0] + "\n" + time[1]
            }
        }

        Timer {
            interval: 100
            repeat: true
            running: true
            onTriggered: timeRefresh.running = true
        }
    }
}
