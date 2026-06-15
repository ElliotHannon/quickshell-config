pragma Singleton
import QtQuick 

QtObject {
  readonly property string wallpaper: "/home/ElliotH/.config/quickshell/assets/wallpapers/ArceusTrio.jpg"
  readonly property string themeName: "ArceusTrio"

  readonly property color barBackground:          "#23272f"

  readonly property color cavaWaveColor:          Qt.rgba(0.38, 0.88, 1.0, 0.35)
  readonly property color cavaFillColor:          Qt.rgba(0.38, 0.88, 1.0, 0.65)

  readonly property color workspaceFocused:       "#63dfff"
  readonly property color workspaceActive:        "#d6dde5"
  readonly property color workspaceInactive:      "#404854"

  readonly property color workspaceActiveText:    "#ffffff"
  readonly property color workspaceInactiveText:  "#b7c2ce"

  readonly property color archIcon:               "#7be8ff"
  readonly property color archGlow:               "#38d8ff"

  readonly property color clockText:              "#f7f9fc"

  readonly property color batteryText:            "#f7f9fc"
  readonly property color batteryCharging:        "#63dfff"
  readonly property color batteryLow:             "#f2c14e"
  readonly property color batteryCritical:        "#ff5c5c"

  readonly property color popupBackground:        "#2c313a"
}
