pragma Singleton
import QtQuick 

QtObject {
  readonly property string wallpaper: "/home/ElliotH/.config/quickshell/assets/wallpapers/ArceusTrio.jpg"
  readonly property string themeName: "ArceusTrio"

  readonly property color barBackground:          "#2a2e31"

  readonly property color cavaWaveColor:          Qt.rgba(0.934, 0.847, 0.45, 0.35)
  readonly property color cavaFillColor:          Qt.rgba(0.934, 0.847, 0.45, 0.65)

  readonly property color workspaceFocused:       "#e18bd6"
  readonly property color workspaceActive:        "#d6dde5"
  readonly property color workspaceInactive:      "#404854"

  readonly property color workspaceActiveText:    "#ffffff"
  readonly property color workspaceInactiveText:  "#b7c2ce"

  readonly property color archIcon:               "#a22135"
  readonly property color archGlow:               "#fc4973"

  readonly property color clockText:              "#6ba7cc"

  readonly property color batteryText:            "#c3eaf9"
  readonly property color batteryCharging:        "#2ae0b8"
  readonly property color batteryLow:             "#e1c43e" 
  readonly property color batteryCritical:        "#fe383a"

  readonly property color popupBackground:        "#2c313a"
}
