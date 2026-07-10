pragma Singleton
import QtQuick 

QtObject {
  readonly property string wallpaper: "/home/ElliotH/.config/quickshell/assets/wallpapers/PokemonGold.jpg"
readonly property color bgPrimary:          "#1f2e46"
readonly property color bgSecondary:        "#2a3e58"

readonly property color cavaWave:          Qt.rgba(0.60, 0.82, 1.0, 0.35)
readonly property color cavaFill:          Qt.rgba(0.60, 0.82, 1.0, 0.60)

readonly property color accentSecondary:       "#ffd447"
readonly property color textSecondary:        "#c8d7e8"
readonly property color textMuted:      "#38506d"

readonly property color textPrimary:    "#ffffff"
readonly property color textDim:  "#b6c8da"

readonly property color accentDanger:               "#8ecbff"
readonly property color accentDangerGlow:               "#66b7ff"

readonly property color accentPrimary:              "#f6f8fb"

readonly property color statusInfo:            "#f6f8fb"
readonly property color statusGood:        "#ffd447"
readonly property color statusWarning:             "#ffb347"
readonly property color statusBad:        "#ff5f56"
}
