import QtQuick
import Quickshell
import "../../themes" as Themes

PanelWindow {
  id: wallpaper

  anchors.top: true
  anchors.bottom: true
  anchors.left: true
  anchors.right: true

  exclusionMode: ExclusionMode.Ignore
  aboveWindows: false

  readonly property var theme: Themes.Manager.active

  // Track the current and next wallpaper sources
  property string currentWallpaper: theme.wallpaper
  property string nextWallpaper: theme.wallpaper
  property real transitionProgress: 0  // 0 = old wallpaper, 1 = new wallpaper
  property bool isFirstLoad: true

  Component.onCompleted: {
    currentWallpaper = theme.wallpaper
    nextWallpaper = theme.wallpaper
    isFirstLoad = false //not sure why but doesn't work on first theme switch without this lmao
  }

  onThemeChanged: {
    if (theme.wallpaper !== currentWallpaper) {
      nextWallpaper = theme.wallpaper
      transitionAnimation.start()
    }
  }

  Image {
    id: oldWallpaper
    anchors.fill: parent
    source: currentWallpaper
    fillMode: Image.PreserveAspectCrop
    smooth: true
    cache: false
    opacity: 1 - wallpaper.transitionProgress //prevent white background flash
  }

  Image { 
    id: newWallpaper
    anchors.fill: parent
    source: nextWallpaper
    fillMode: Image.PreserveAspectCrop
    smooth: true
    cache: false
    opacity: wallpaper.transitionProgress
  }

  NumberAnimation {
    id: transitionAnimation
    target: wallpaper
    property: "transitionProgress"
    from: 0
    to: 1
    duration: 500
    easing.type: Easing.InOutQuad

    onFinished: {
      // Once animation is done, update the current wallpaper
      console.log("caca")
      currentWallpaper = nextWallpaper
      transitionProgress = 0  // Reset for next transition
    }
  }
}
