pragma Singleton
import QtQuick 

QtObject {
    readonly property string themeName: "RayquazaCanyon"
    readonly property string wallpaper: "/home/ElliotH/.config/quickshell/assets/wallpapers/RayquazaCanyon.png"
/*
    // BAR
    readonly property color barBackground:          "#243447"

    // CAVA (clean emerald glow)
    readonly property color cavaWaveColor:          Qt.rgba(0.35, 0.95, 0.75, 0.28)
    readonly property color cavaFillColor:          Qt.rgba(0.35, 0.95, 0.75, 0.45)

    // WORKSPACES
    readonly property color workspaceFocused:       "#3df5c0"
    readonly property color workspaceActive:        "#9fb6c9"

    readonly property color workspaceInactive:      "#2b3f52"
    // ARCH ICON
    readonly property color archIcon:               "#6effd6"
    readonly property color archGlow:               "#00ffc3"

    // CLOCK
    readonly property color clockText:              "#f2fbff"

    // BATTERY
    readonly property color batteryText:            "#f2fbff"
    readonly property color batteryCharging:        "#3df5c0"
    readonly property color batteryLow:             "#ffcc66"
    readonly property color batteryCritical:        "#ff5c5c"
  
  }*/

  readonly property color barBackground:          "#26394d"

    // CAVA (stronger glow, almost electric)
    readonly property color cavaWaveColor:          Qt.rgba(0.0, 1.0, 0.75, 0.35)
    readonly property color cavaFillColor:          Qt.rgba(0.0, 1.0, 0.75, 0.60)

    readonly property color workspaceFocused:       "#00ffa6"
    readonly property color workspaceActive:        "#a6c2d6"
    readonly property color workspaceInactive:      "#3c566e"
    readonly property color workspaceActiveText:    "#eafff7"
    readonly property color workspaceInactiveText:  "#a6c2d6"

    readonly property color archIcon:               "#6effd6"
    readonly property color archGlow:               "#00ffc3"

    readonly property color clockText:              "#f4ffff"

    readonly property color batteryText:            "#f4ffff"
    readonly property color batteryCharging:        "#00ffa6"
    readonly property color batteryLow:             "#ffbe0b"
    readonly property color batteryCritical:        "#ff3c38"
}
