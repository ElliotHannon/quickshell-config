pragma Singleton
import QtQuick 

QtObject {
  readonly property string wallpaper: "/home/ElliotH/.config/quickshell/assets/wallpapers/PokemonGold.jpg"
  readonly property string themeName: "PokemonGold"

  readonly property color barBackground:          "#1f2e46"

  readonly property color cavaWaveColor:          Qt.rgba(0.60, 0.82, 1.0, 0.35)
  readonly property color cavaFillColor:          Qt.rgba(0.60, 0.82, 1.0, 0.60)

  readonly property color workspaceFocused:       "#ffd447"
  readonly property color workspaceActive:        "#c8d7e8"
  readonly property color workspaceInactive:      "#38506d"

  readonly property color workspaceActiveText:    "#ffffff"
  readonly property color workspaceInactiveText:  "#b6c8da"

  readonly property color archIcon:               "#8ecbff"
  readonly property color archGlow:               "#66b7ff"

  readonly property color clockText:              "#f6f8fb"

  readonly property color batteryText:            "#f6f8fb"
  readonly property color batteryCharging:        "#ffd447"
  readonly property color batteryLow:             "#ffb347"
  readonly property color batteryCritical:        "#ff5f56"

  readonly property color popupBackground:        "#2a3e58"
}
