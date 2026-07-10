pragma Singleton
import QtQuick 

QtObject {
    readonly property string themeName: "PinkRayquazaV2"
    readonly property string wallpaper: "/home/ElliotH/.config/quickshell/assets/wallpapers/PinkRayquaza.png"

readonly property color bgPrimary:              "#4a4768"
readonly property color bgSecondary:            "#4c4a71"

readonly property color cavaWave:               Qt.rgba(1.0, 0.7, 0.85, 0.3)
readonly property color cavaFill:               Qt.rgba(1.0, 0.7, 0.85, 0.55)

readonly property color accentPrimary:          "#ffe5ec"
readonly property color accentSecondary:        "#ff6fa3"
readonly property color accentDanger:           "#ffb3c6"
readonly property color accentDangerGlow:       "#ff6fa3"

readonly property color textPrimary:            "#1f2233"
readonly property color textSecondary:          "#9aa6c1"
readonly property color textMuted:              "#343a52"
readonly property color textDim:                "#f0f3ff"

readonly property color statusInfo:             "#ffe5ec"
readonly property color statusGood:             "#80ef99"
readonly property color statusWarning:          "#ffd166"
readonly property color statusBad:              "#ef233c"
}
