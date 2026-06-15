
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import ".."
import "../services" as Services

Item {
  id: root
  anchors.fill: parent
  property color mediaColor: "#ffffff"
  property color mediaColorHover: "#ffffff"
  
  MouseArea {
    id: hitbox
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton 
    
    /*property bool popupIsShown: popup.shown
    onClicked: mouse => {
      if (mouse.button === Qt.LeftButton){
        popup.toggle();
        bar.focusGrab.active = popup.shown;
        root.barColor = popup.shown ? Globals.theme.foreground : Globals.theme.accent3;
        
      }
      if (mouse.button === Qt.RightButton){
        fullScreen.enterFullScreen();
        bar.focusGrab.active = fullScreen.shown;
      }
    }*/

    onEntered: {
      if (!popup.shown){
        root.barColor = Globals.theme.accent3;
      } else {
        root.barColor = Globals.theme.foreground;
      }
    }

    onExited: {
      root.barColor = chooseColor();
    }

    onPopupIsShownChanged: {
      if (hitbox.containsMouse){
        root.barColor = popupIsShown ? Globals.theme.foreground : Globals.theme.accent3;
      } else {
        root.barColor = popupIsShown ? Globals.theme.muted : Globals.theme.accent1;
      }

    }
  }

  function chooseColor() {
    return popup.shown ? Globals.theme.muted : Globals.theme.accent1; // Place Holder for If I change color on height
  }
  property color barColor: chooseColor()

  
  Shape {
      id: visualiser

      readonly property real centerX: width / 2
      readonly property real centerY: height / 2
      readonly property real innerX: 0 
      readonly property real innerY: 0

      anchors.fill: parent

      asynchronous: true
      preferredRendererType: Shape.CurveRenderer
      data: visualiserBars.instances
  }
  Variants {
      id: visualiserBars

      model: Array.from({
          length: Globals.visualiserBars
      }, (_, i) => i)

      ShapePath {
          id: visualiserBar

          required property int modelData
          readonly property int value: Math.max(1,Services.Cava.values[modelData])
          readonly property real spacing:5
          readonly property real barBuffer:7
          capStyle: ShapePath.RoundCap


          strokeWidth: 7
          strokeColor: root.barColor

          startX: root.width - barBuffer
          startY: modelData*(strokeWidth + spacing)
          PathLine {
            x: root.width -barBuffer - visualiserBar.value/2
            y: modelData*(strokeWidth + spacing)
          }
      }
  }

  Loader {
    id: popupLoader
    property var popup: popupLoader.item
    sourceComponent: Globals.popup === "FloatPopup" ? floatPopupComponent : regularPopupComponent

    Component {
      id: regularPopupComponent
      Popup {
        id: popup
        ref: bar
        name: "Media"
        popupHeight: 200
        popupWidth: 500
        yPos: popupYpos
        MediaPopup {}
      }
    }
    Component {
      id: floatPopupComponent
      FloatPopup {
        id: popup
        ref: bar
        name: "Media"
        popupHeight: 200
        popupWidth: 400
        yPos: popupYpos
        MediaPopup {}
      }
    }
  }
  Loader {
    id: fsLoader
    property var fs: fsLoader.item
    sourceComponent: fullScreen.comp
  }
}
