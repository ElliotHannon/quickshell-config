// features/bar/Bar.qml
import QtQuick
import QtQuick.Layouts 
import Quickshell 
import Quickshell.Hyprland 
import Qt5Compat.GraphicalEffects 
import "../../components/barWidgets" as Widgets
import "../../components/popups" as Popups  // Add this import for popups
import "../../themes" as Themes 
import "../../visuals" as Visuals 

PanelWindow { 
  id: panel 

  required property ShellScreen screen
  readonly property var theme: Themes.Manager.active 
  color: "transparent" 
  anchors { 
    top: true 
    right: true 
    bottom: true 
  } 
  implicitWidth: 30 
  margins { 
    top: 0 
    left: 0 
    right: 0 
    bottom: 0 
  }

  // ===== POPUP MANAGEMENT =====
  property var activePopups: ({})
  property int padding: theme ? theme.popupPadding : 8
  property int radius: theme ? theme.popupRadius : 8
  property int spacing: theme ? theme.popupSpacing : 4
  property color popupColor: theme ? theme.popupBackground : "#2a3b4c"

  function collapseAllBut(exceptName) {
    for (var name in activePopups) {
      if (name !== exceptName && activePopups[name]) {
        activePopups[name].collapse()
      }
    }
  }

  function registerPopup(name, popupInstance) {
    activePopups[name] = popupInstance
  }
  // ===== END POPUP MANAGEMENT =====

  Rectangle { 
    id: bar 
    anchors.fill: parent 
    color: theme.barBackground 
    Behavior on color {
      ColorAnimation { 
        duration: 250 
        easing.type: Easing.InOutQuad 
      } 
    } 
    radius: 0 
    layer.enabled: true 
    layer.effect: OpacityMask {
      maskSource: Rectangle {
        width: bar.width 
        height: bar.height 
        radius: bar.radius 
      }
    }

    // Vertical Cava visualization 
    Visuals.CavaWaveform { 
      anchors.fill: parent 
      waveColor: theme.cavaWaveColor 
      highlightColor: theme.cavaFillColor 
      waveIntensity: 29 
      lineWidth: 1.5 
      smoothness: 0.99
      showFill: true
      waveOpacity: 0.6 
      sampleRate: 500
    }

    // Semi-transparent overlay 
    Rectangle { 
      anchors.fill: parent 
      color: theme.barBackground 
      opacity: 0.2 
      radius: parent.radius 
    }

    // Main layout - THREE SECTION COLUMN
    ColumnLayout { 
      anchors.fill: parent 
      spacing: 0

      // TOP SECTION - Arch icon + Workspaces
      Item {
        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: 8

        Column {
          anchors.centerIn: parent
          spacing: 0

          // Arch icon
          Widgets.ArchIcon { 
            anchors.horizontalCenter: parent.horizontalCenter
            animationDuration: 350 
            iconColor: theme.archIcon 
            glowColor: theme.archGlow 
            baseSize: 15
            hoverScale: 1.25 
            onClicked: Themes.Manager.cycleTheme() 
          }

          // Workspaces with background
          Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: workspacesWidget.width + 15
            height: workspacesWidget.height + 15

            // Workspaces widget
            Widgets.Workspaces {
              id: workspacesWidget
              anchors.centerIn: parent

              focusedColor: theme.workspaceFocused 
              activeColor: theme.workspaceActive 
              inactiveColor: theme.workspaceInactive 
              workspaceHeight: 6 
              workspaceWidth: 6 
              focusedWidth: 10 
              workspaceSpacing: 4
            }
          }
        }
      }

      // CENTER SECTION - Clock
      Item {
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: 100

        Widgets.Clock { 
          id: clockWidget
          anchors.centerIn: parent
          clockColor: theme.clockText 
          hoverInCol: theme.clockText 
          hoverOutCol: theme.clockText 
          fontSize: 15 
        }
      }

      // BOTTOM SECTION - Battery
      Item {
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignBottom
        Layout.preferredHeight: 50
        Layout.bottomMargin: 2

        Widgets.Battery { 
          id: batteryWidget
          anchors.centerIn: parent 
          iconSize: 20 
          textColor: theme.batteryText 
          chargingColor: theme.batteryCharging 
          lowBatteryColor: theme.batteryLow 
          criticalBatteryColor: theme.batteryCritical 

          // Add click handler to toggle popup
          MouseArea {
            anchors.fill: parent
            onClicked: batteryPopup.toggle()
            cursorShape: Qt.PointingHandCursor
          }
        }
      }
    }
  }

  // ===== BATTERY POPUP =====
  Popups.Popup {
    id: batteryPopup
    name: "battery"
    ref: panel
    popupWidth: 300
    popupHeight: 240
    yPos: 920

    Component.onCompleted: panel.registerPopup(name, batteryPopup)

    // Popup content
    Popups.BatteryPopup {
      textColor: theme.clockText
      accentColor1: theme.archIcon
      mutedColor: theme.workspaceInactive
      borderColor: theme.workspaceActive
    }
  }
}
