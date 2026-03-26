pragma Singleton
import QtQuick 

QtObject {
  readonly property string themeName: "DeepForestRiverGlow"
  readonly property string wallpaper: "/home/ElliotH/.config/quickshell/assets/wallpapers/RiverForestPokemon.jpg"

  // BAR
  readonly property color barBackground:          "#102e27"

  // CAVA (stronger river energy)
  readonly property color cavaWaveColor:          Qt.rgba(0.15, 1.0, 0.75, 0.35)
  readonly property color cavaFillColor:          Qt.rgba(0.15, 1.0, 0.75, 0.65)

  // WORKSPACES
  readonly property color workspaceFocused:       "#66ff99"
  readonly property color workspaceActive:        "#2dbd73"
  readonly property color workspaceInactive:      "#2f5f57"   // more visible teal
  readonly property color workspaceActiveText:    "#081b15"
  readonly property color workspaceInactiveText:  "#d8fff3"

  // ARCH ICON
  readonly property color archIcon:               "#8cffb0"
  readonly property color archGlow:               "#39ff88"

  // CLOCK
  readonly property color clockText:              "#f0fff8"

  // BATTERY
  readonly property color batteryText:            "#f0fff8"
  readonly property color batteryCharging:        "#39ff88"
  readonly property color batteryLow:             "#ffcc66"
  readonly property color batteryCritical:        "#ff4d6d"
}
