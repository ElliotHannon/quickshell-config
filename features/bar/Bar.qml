import QtQuick
import QtQuick.Layouts 
import Quickshell 
import Quickshell.Hyprland 
import Qt5Compat.GraphicalEffects 
import "../../components" as Components 
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
      waveIntensity: 34 
      lineWidth: 2 
      smoothness: 0.95
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
      spacing: 0  // No spacing between sections
      
      // TOP SECTION - Arch icon + Workspaces
      Item {
        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: 8 // Adjust as needed
        
        Column {
          anchors.centerIn: parent
          spacing: 0
          
          // Arch icon
          Components.ArchIcon { 
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
            Components.Workspaces {
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
        Layout.preferredHeight: 100  // Adjust as needed
        
        Components.Clock { 
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
        Layout.preferredHeight: 50  // Adjust as needed
        Layout.bottomMargin: 2
        
        Components.Battery { 
          anchors.centerIn: parent 
          iconSize: 20 
          textColor: Themes.Manager.active.batteryText 
          chargingColor: Themes.Manager.active.batteryCharging 
          lowBatteryColor: Themes.Manager.active.batteryLow 
          criticalBatteryColor: Themes.Manager.active.batteryCritical 
        }
      }
    }
  }
}
