import QtQuick
import Qt5Compat.GraphicalEffects

Item {
  id: archIcon
  width: 60
  height: 60

  property color iconColor: "white"
  property color glowColor: "white"

  property real baseSize: 40
  property real hoverScale: 1.20
  property bool hovered: false
  property int animationDuration: 350
  signal clicked

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onEntered: archIcon.hovered = true
    onExited: archIcon.hovered = false
    onClicked: archIcon.clicked()
  }

  Text {
    anchors.centerIn: parent
    text: ""
    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: baseSize
    color: archIcon.iconColor

    scale: archIcon.hovered ? hoverScale : 1.0

    Behavior on scale {
      NumberAnimation {
        duration: archIcon.animationDuration
        easing.type: Easing.OutQuad
      }
    }
    Behavior on color {
      ColorAnimation {
        duration: 250
        easing.type: Easing.InOutQuad
      }
    }


    layer.enabled: true
    layer.effect: DropShadow {
      color: archIcon.glowColor
      radius: archIcon.hovered ? 25 : 22
      samples: 32
      Behavior on color {
        ColorAnimation {
          duration: 250
          easing.type: Easing.InOutQuad
        }
      }

    }
  }
}
