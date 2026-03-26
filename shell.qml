//@ pragma UseQApplication
import QtQuick
import Quickshell
import "features/bar" as BarFeature
import "features/background"

ShellRoot {
  id: root
  Wallpaper {}  // No namespace needed since we imported the module directly
  BarFeature.Bar {
    id: bar
  }
}
