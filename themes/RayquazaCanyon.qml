pragma Singleton
import QtQuick 

QtObject {
    readonly property string themeName: "RayquazaCanyon"
    readonly property string wallpaper: "/home/ElliotH/.config/quickshell/assets/wallpapers/RayquazaCanyon.png"

readonly property color bgPrimary:          "#26394d"
readonly property color bgSecondary:        "#2a3b4c"

readonly property color cavaWave:          Qt.rgba(0.0, 1.0, 0.75, 0.35)
readonly property color cavaFill:          Qt.rgba(0.0, 1.0, 0.75, 0.60)

readonly property color accentSecondary:       "#00ffa6"
readonly property color textSecondary:        "#a6c2d6"
readonly property color textMuted:      "#3c566e"
readonly property color textPrimary:    "#eafff7"
readonly property color textDim:  "#a6c2d6"

readonly property color accentDanger:               "#6effd6"
readonly property color accentDangerGlow:               "#00ffc3"

readonly property color accentPrimary:              "#f4ffff"

readonly property color statusInfo:            "#f4ffff"
readonly property color statusGood:        "#00ffa6"
readonly property color statusWarning:             "#ffbe0b"
readonly property color statusBad:        "#ff3c38"
    readonly property int popupPadding: 12
    readonly property int popupRadius: 8
    readonly property int popupSpacing: 8
}
