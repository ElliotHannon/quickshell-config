pragma Singleton
import QtQuick 

QtObject {
  readonly property string wallpaper: "/home/ElliotH/.config/quickshell/assets/wallpapers/ArceusTrio.jpg"
  readonly property string themeName: "ArceusTrio"

  // Backgrounds
  readonly property color bgPrimary:            "#2a2e31"
  readonly property color bgSecondary:          "#2c313a"

  // Cava / Visualizer
  readonly property color cavaWave:             Qt.rgba(0.934, 0.847, 0.45, 0.35)
  readonly property color cavaFill:             Qt.rgba(0.934, 0.847, 0.45, 0.65)

  // Text
  readonly property color textPrimary:          "#ffffff"
  readonly property color textSecondary:        "#d6dde5"
  readonly property color textMuted:            "#404854"
  readonly property color textDim:              "#b7c2ce"

  // Accent
  readonly property color accentPrimary:        "#6ba7cc"
  readonly property color accentSecondary:      "#e18bd6"
  readonly property color accentDanger:         "#a22135"
  readonly property color accentDangerGlow:     "#fc4973"

  // Status colors
  readonly property color statusGood:           "#2ae0b8"
  readonly property color statusWarning:        "#e1c43e"
  readonly property color statusBad:            "#fe383a"
  readonly property color statusInfo:           "#c3eaf9"
}
