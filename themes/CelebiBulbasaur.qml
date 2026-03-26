pragma Singleton
import QtQuick 

QtObject {
  readonly property string themeName: "CelebiBulbasaur"
  readonly property string wallpaper: "/home/ElliotH/.config/quickshell/assets/wallpapers/CelebiBulbasaur.jpg"
  // BAR
  readonly property color barBackground: "#013220"

  // WORKSPACES
  readonly property color workspaceActive: "#03c03c"
  readonly property color workspaceInactive: "#8db600"
  readonly property color workspaceActiveText: "#2f4f4f"
  readonly property color workspaceInactiveText: "#f9ffe3"

  // ARCH ICON
  readonly property color archIcon: "#76ff7a"
  readonly property color archGlow: "#0bda51"

  // CLOCK
  readonly property color clockText: "#ffffbb"

  // BATTERY
  readonly property color batteryText: "#ffffbb"
  readonly property color batteryCharging: "#55ff22"
  readonly property color batteryLow: "#ffdd33"
  readonly property color batteryCritical: "#dd3344"
}
