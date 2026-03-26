pragma Singleton
import QtQuick 
import Quickshell.Io
import "."

QtObject {
  // Theme definitions
  property var themes: [
    RayquazaCanyon,
    PinkRayquaza,
    RiverForestPokemon,
    ]

  property int currentIndex: 0
  readonly property var active: themes[currentIndex]

  // Cycle to next theme
  function cycleTheme() {
    currentIndex = (currentIndex + 1) % themes.length
  }
}
