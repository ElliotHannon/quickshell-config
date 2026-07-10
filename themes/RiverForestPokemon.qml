pragma Singleton
import QtQuick 

QtObject {
  readonly property string themeName: "RiverForestPokemon"
  readonly property string wallpaper: "/home/ElliotH/.config/quickshell/assets/wallpapers/RiverForestPokemon.jpg"

  readonly property color bgPrimary:          "#102e27"
  readonly property color bgSecondary:        "#1a453a"

  readonly property color cavaWave:           Qt.rgba(0.15, 1.0, 0.75, 0.35)
  readonly property color cavaFill:           Qt.rgba(0.15, 1.0, 0.75, 0.65)

  readonly property color accentPrimary:      "#f0fff8"
  readonly property color accentSecondary:    "#66ff99"

  readonly property color textPrimary:        "#081b15"
  readonly property color textSecondary:      "#2dbd73"
  readonly property color textMuted:          "#2f5f57"
  readonly property color textDim:            "#d8fff3"

  readonly property color accentDanger:       "#8cffb0"
  readonly property color accentDangerGlow:   "#39ff88"


  readonly property color statusInfo:         "#f0fff8"
  readonly property color statusGood:         "#39ff88"
  readonly property color statusWarning:      "#ffcc66"
  readonly property color statusBad:          "#ff4d6d"
}
