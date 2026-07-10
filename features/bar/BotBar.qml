
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
    bottom: true
    left: true
    right:true
  } 
  implicitHeight: 5
  margins { 
    top: 0 
    left: 0 
    right: 0 
    bottom: 0 
  }
  /*
   // ===== WIDGET BACKGROUND ====
   property color widgetBackground: Qt.rgba(0.13, 0.1, 0.2, 0.75)
   property int widgetRadius: 8
   property int widgetPadding: 5
   property int widgetMaxWidth: 32
   */
  // ===== DEBUG ====
  property bool showCenterLine: false

  // ===== POPUP MANAGEMENT =====
  property var activePopups: ({})
  property int padding: theme ? theme.popupPadding : 8
  property int radius: theme ? theme.popupRadius : 8
  property int spacing: theme ? theme.popupSpacing : 4
  property color popupColor: theme ? theme.bgSecondary : "#2a3b4c"

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
    color: theme.bgPrimary 
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

    // Semi-transparent overlay 
    Rectangle { 
      anchors.fill: parent 
      color: theme.bgPrimary
      opacity: 0.2 
      radius: parent.radius 
    }
  }
}
