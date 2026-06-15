pragma Singleton
import QtQuick 
import Quickshell.Io
import "."

QtObject {
  // Theme definitions
  property var themes: [
    ArceusTrio,
    PokemonGold,
    RayquazaCanyon,
    PinkRayquaza,
    RiverForestPokemon
    ]

  property int currentIndex: 0
  readonly property var active: themes[currentIndex]
  
  property int popupPadding: 12
  property int popupRadius: 8
  property int popupSpacing: 8

  function cycleTheme() {
    currentIndex = (currentIndex + 1) % themes.length
  }
}
