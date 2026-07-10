// components/popups/BatteryPopup.qml - WORKING VERSION
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
  id: root
  anchors.fill: parent

  property var moduleRef: parent
  property color textColor: "#ffffff"
  property color accentColor1: "#00ffa6"
  property color accentColor2: "#00a6ff"
  property color mutedColor: "#888888"
  property color borderColor: "#3a4c5e"

  readonly property var displayDevice: UPower ? UPower.displayDevice : null
  readonly property real percentage: displayDevice.percentage
  readonly property real changeRate: displayDevice ? displayDevice.changeRate : 0
  readonly property var chargeState: displayDevice ? displayDevice.state : 0
  readonly property bool isCharging: chargeState == UPowerDeviceState.Charging
  readonly property bool isDocked: chargeState != UPowerDeviceState.Charging && changeRate <= 0.01

  Component.onCompleted: {
    if (displayDevice) {
      console.log("Battery percentage:", displayDevice.percentage)
      console.log("Is charging:", isCharging)
    }
    checkCurrentProfile()
  }

  // Process for setting power profile
  Process {
    id: profileProcess
    running: false
    command: []
    
    stdout: StdioCollector {
      onStreamFinished: {
        console.log("Profile set stdout:", this.text)
      }
    }
    
    stderr: StdioCollector {
      onStreamFinished: {
        if (this.text) console.log("Profile set stderr:", this.text)
      }
    }
    
  }

  // Process for checking current profile
  Process {
    id: checkProcess
    running: false
    command: []
    
    stdout: StdioCollector {
      onStreamFinished: {
        var output = this.text.toLowerCase().trim()
        console.log("Current profile output:", output)
        
        if (output.includes("current active profile:")) {
          output = output.split("current active profile:")[1].trim()
        }
        
        if (output.includes("powersave") || output.includes("laptop-battery")) {
          powerProfileContainer.profileMode = "powersave"
        } else if (output.includes("balanced") || output.includes("desktop")) {
          powerProfileContainer.profileMode = "balanced"
        } else if (output.includes("performance") || output.includes("throughput")) {
          powerProfileContainer.profileMode = "performance"
        }
        
        console.log("Set UI profile to:", powerProfileContainer.profileMode)
      }
    }
    
    stderr: StdioCollector {
      onStreamFinished: {
        if (this.text) console.log("Check profile stderr:", this.text)
      }
    }
  }

  // Process for checking hypridle
  Process {
    id: hypridleProcess
    running: false
    command: []
    
  }

  function setPowerProfile(profile) {
    console.log("=== Setting profile to:", profile, "===")
    profileProcess.exec(["tuned-adm", "profile", profile])
  }

  function checkCurrentProfile() {
    console.log("Checking current tuned profile...")
    checkProcess.exec(["tuned-adm", "active"])
  }

  ColumnLayout {
    spacing: 12
    anchors {
      fill: parent
      margins: 12
    }

    // Top section - Battery info
    RowLayout {
      spacing: 12
      Layout.fillWidth: true

      Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 60

        ColumnLayout {
          spacing: 4
          anchors.fill: parent

          Text {
            text: isDocked ? "Device is docked" : 
            isCharging ? "Charging at: " + Math.abs(changeRate).toFixed(2) + " W" : 
            "Discharging at: " + Math.abs(changeRate).toFixed(2) + " W"
            color: accentColor1
            font.pointSize: 11
            font.bold: true
          }

          Text {
            property string timeTo: {
              if (!displayDevice) return "N/A"
              var time = isCharging ? displayDevice.timeToFull : displayDevice.timeToEmpty
              if (time <= 0) return "Calculating..."
              var hours = Math.floor(time / 3600)
              var minutes = Math.floor((time % 3600) / 60)
              return hours + "h " + minutes + "m"
            }
            text: isDocked ? "No battery change" : 
            isCharging ? "Battery full in: " + timeTo : 
            "Battery empty in: " + timeTo
            color: textColor
            font.pointSize: 10
          }

          Text {
            text: Math.round(100*percentage) + "% remaining"
            color: textColor
            font.pointSize: 10
            visible: !isDocked
          }
        }
      }

      // Hypridle toggle
      Item {
        id: hypridle
        implicitWidth: 50
        implicitHeight: 50

        property bool hypridleState: false

        Component.onCompleted: {
          hypridleProcess.exec(["pgrep", "hypridle"])
        }

        function toggleHypridle() {
          if (hypridleState) {
            Quickshell.execDetached({ command: "killall hypridle" })
          } else {
            Quickshell.execDetached({ command: "hypridle &" })
          }
          hypridleState = !hypridleState
        }

        Rectangle {
          anchors.fill: parent
          radius: 8
          color: hypridle.hypridleState ? accentColor2 : mutedColor
          border.width: 2
          border.color: borderColor

          Text {
            anchors.centerIn: parent
            color: hypridle.hypridleState ? "#ffffff" : textColor
            font.pointSize: 24
            text: hypridle.hypridleState ? "󰾪" : ""
            font.family: "Nerd-font"
          }

          MouseArea {
            anchors.fill: parent
            onClicked: hypridle.toggleHypridle()
            cursorShape: Qt.PointingHandCursor
          }
        }
      }
    }

    // Power Profile Selector
    Rectangle {
      id: powerProfileContainer
      Layout.fillWidth: true
      Layout.preferredHeight: 70
      Layout.topMargin: 8
      color: "transparent"

      property string profileMode: "balanced"
      property int buttonSize: 40

      // Background track
      Rectangle {
        id: bg
        color: borderColor
        anchors.centerIn: parent
        width: 200
        height: 56
        radius: 28
      }

      // Moving selector
      Rectangle {
        id: selector
        width: powerProfileContainer.buttonSize
        height: powerProfileContainer.buttonSize
        radius: powerProfileContainer.buttonSize / 2
        color: accentColor1
        opacity: 0.9
        anchors.verticalCenter: parent.verticalCenter

        x: {
          var centerX = (parent.width - width) / 2 - 0.8
          if (powerProfileContainer.profileMode === "powersave") return centerX - powerProfileContainer.buttonSize * 1.95
          if (powerProfileContainer.profileMode === "balanced") return centerX 
          if (powerProfileContainer.profileMode === "throughput-performance") return centerX  + powerProfileContainer.buttonSize * 1.95
          return centerX
        }

        Behavior on x {
          NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
        }
      }

      // Buttons row
      Row {
        anchors.centerIn: parent
        spacing: powerProfileContainer.buttonSize

        // Powersave
        Item {
          width: powerProfileContainer.buttonSize
          height: powerProfileContainer.buttonSize

          Text {
            anchors.centerIn: parent
            text: ""
            font.pointSize: 20
            color: powerProfileContainer.profileMode === "powersave" ? accentColor : mutedColor
            font.family: "Nerd-font"
          }

          MouseArea {
            anchors.fill: parent
            onClicked: {
              powerProfileContainer.profileMode = "powersave"
              setPowerProfile("powersave")
            }
            cursorShape: Qt.PointingHandCursor
          }
        }

        // Balanced
        Item {
          width: powerProfileContainer.buttonSize
          height: powerProfileContainer.buttonSize

          Text {
            anchors.centerIn: parent
            text: "󰗑"
            font.pointSize: 20
            color: powerProfileContainer.profileMode === "balanced" ? accentColor : mutedColor
            font.family: "Nerd-font"
          }

          MouseArea {
            anchors.fill: parent
            onClicked: {
              powerProfileContainer.profileMode = "balanced"
              setPowerProfile("balanced")
            }
            cursorShape: Qt.PointingHandCursor
          }
        }

        // Performance
        Item {
          width: powerProfileContainer.buttonSize
          height: powerProfileContainer.buttonSize

          Text {
            anchors.centerIn: parent
            text: "󱓟"
            font.pointSize: 20
            color: powerProfileContainer.profileMode === "throughput-performance" ? accentColor : mutedColor
            font.family: "Nerd-font"
          }

          MouseArea {
            anchors.fill: parent
            onClicked: {
              powerProfileContainer.profileMode = "throughput-performance"
              setPowerProfile("throughput-performance")
            }
            cursorShape: Qt.PointingHandCursor
          }
        }
      }
    }
  }
}
