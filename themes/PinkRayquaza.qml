pragma Singleton
import QtQuick 

QtObject {
    readonly property string themeName: "PinkRayquazaV2"
    readonly property string wallpaper: "/home/ElliotH/.config/quickshell/assets/wallpapers/PinkRayquaza.png"

    readonly property color barBackground:          "#4a4768"
    readonly property color widgetBackground:       "#2a2748"
    readonly property color cavaWaveColor:          Qt.rgba(1.0, 0.7, 0.85, 0.3)
    readonly property color cavaFillColor:          Qt.rgba(1.0, 0.7, 0.85, 0.55)

    readonly property color workspaceFocused:       "#ff6fa3"
    readonly property color workspaceActive:        "#9aa6c1"
    readonly property color workspaceInactive:      "#343a52"
    readonly property color workspaceActiveText:    "#1f2233"
    readonly property color workspaceInactiveText:  "#f0f3ff"

    readonly property color archIcon:               "#ffb3c6"
    readonly property color archGlow:               "#ff6fa3"

    readonly property color clockText:              "#ffe5ec"

    readonly property color batteryText:            "#ffe5ec"
    readonly property color batteryCharging:        "#80ef99"
    readonly property color batteryLow:             "#ffd166"
    readonly property color batteryCritical:        "#ef233c"
}
