import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent

    property color clockColor: "#ffffff"
    property color hoverInCol: "#334466"
    property color hoverOutCol: "#529810"
    property int fontSize: 14
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            timeDisplay.color = hoverInCol;
        }
        onExited: {
            timeDisplay.color = hoverOutCol;
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    ColumnLayout {
        id: layout
        spacing: -10

        anchors {
            fill: parent
        }
        Text {
          id: timeDisplay
          Layout.alignment: Qt.AlignCenter
          color: clockColor
          font.pointSize: fontSize
          font.bold: true

          lineHeight: 0.65

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

}
