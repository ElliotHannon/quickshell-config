// features/bar/Bar.qml
import QtQuick
import QtQuick.Layouts 
import Quickshell 
import Quickshell.Hyprland 
import Qt5Compat.GraphicalEffects 
import "../../components/barWidgets" as Widgets
import "../../components/popups" as Popups
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
  implicitWidth: 38 
  margins { 
    top: 0 
    left: 0 
    right: 0 
    bottom: 0 
  }

  // ===== WIDGET BACKGROUND ====
  property color widgetBackground: Qt.rgba(0.13, 0.1, 0.2, 0.75)
  property int widgetRadius: 8
  property int widgetPadding: 5
  property int widgetMaxWidth: 32

  // ===== DEBUG ====
  property bool showCenterLine: true

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

    //Cava  
    Visuals.CavaWaveform { 
      anchors.fill: parent 
      waveColor: theme.cavaWaveColor 
      highlightColor: theme.cavaFillColor 
      waveIntensity: 35 
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

    // Absolute positioning for true centering
    Item {
      id: container
      anchors.fill: parent
      anchors.margins: 3

      // Debug center line
      Rectangle {
        visible: panel.showCenterLine
        anchors {
          horizontalCenter: parent.horizontalCenter
          top: parent.top
          bottom: parent.bottom
        }
        width: 1
        color: "#ff0000"
        z: 100
      }

      // Debug edge lines
      Rectangle {
        visible: panel.showCenterLine
        anchors {
          left: parent.left
          top: parent.top
          bottom: parent.bottom
        }
        width: 1
        color: "#00ff00"
        z: 100
      }
      Rectangle {
        visible: panel.showCenterLine
        anchors {
          right: parent.right
          top: parent.top
          bottom: parent.bottom
        }
        width: 1
        color: "#00ff00"
        z: 100
      }

      // === TOP GROUP (anchored to top) ===
      Column {
        id: topGroup
        anchors {
          top: parent.top
          topMargin: 6
          horizontalCenter: parent.horizontalCenter
        }
        spacing: 8
        
        // Debug: Column bounds
        Rectangle {
          visible: panel.showCenterLine
          anchors.fill: parent
          color: "transparent"
          border.color: "#ffff00"
          border.width: 1
          z: 99
        }
        
        // Arch Icon - circle background
        Rectangle {
          id: archBackground
          anchors.horizontalCenter: parent.horizontalCenter
          width: widgetMaxWidth * 0.9
          height: width  // Perfect square for circle
          color: widgetBackground
          radius: width / 2  // Perfect circle
          
          // Debug: crosshair in arch background
          Rectangle {
            visible: panel.showCenterLine
            anchors.centerIn: parent
            width: parent.width
            height: 1
            color: "#ff00ff"
            z: 101
          }
          Rectangle {
            visible: panel.showCenterLine
            anchors.centerIn: parent
            width: 1
            height: parent.height
            color: "#ff00ff"
            z: 101
          }
          
          Widgets.ArchIcon { 
            id: archIconWidget
            anchors.centerIn: parent
            animationDuration: 350 
            iconColor: theme.archIcon 
            glowColor: theme.archGlow 
            baseSize: 15
            hoverScale: 1.25 
            onClicked: Themes.Manager.cycleTheme() 
          }
        }
        
        // Workspaces
        Rectangle {
          id: workspacesBackground
          anchors.horizontalCenter: parent.horizontalCenter
          width: widgetMaxWidth * 0.65
          height: workspacesWidget.implicitHeight + widgetPadding * 2
          color: widgetBackground
          radius: widgetRadius
          
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

      // === CLOCK (true vertical center) ===
      Rectangle {
        anchors {
          verticalCenter: parent.verticalCenter
          horizontalCenter: parent.horizontalCenter
        }
        width: widgetMaxWidth
        height: clockWidget.implicitHeight + widgetPadding * 2
        color: widgetBackground
        radius: widgetRadius
        
        Widgets.Clock { 
          id: clockWidget
          anchors.centerIn: parent
          clockColor: theme.clockText 
          hoverInCol: theme.clockText 
          hoverOutCol: theme.clockText 
          fontSize: 15 
        }
      }

      // === BATTERY  ===
      Rectangle {
        anchors {
          bottom: parent.bottom
          horizontalCenter: parent.horizontalCenter
        }
        width: widgetMaxWidth*0.9
        height: batteryWidget.implicitHeight + widgetPadding 
        color: widgetBackground
        radius: widgetRadius
        
        Widgets.Battery { 
          id: batteryWidget
          anchors.centerIn: parent
          iconSize: 20 
          textColor: theme.batteryText 
          chargingColor: theme.batteryCharging 
          lowBatteryColor: theme.batteryLow 
          criticalBatteryColor: theme.batteryCritical 

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
