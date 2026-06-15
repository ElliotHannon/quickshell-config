//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "features/bar" 
import "features/background"
import "components/notifications"
import "components/volumeOSD" as VolOSD
import "components/brightnessOSD" as BrightOSD
ShellRoot {
  id: root
  NotificationServer {
    id: notificationServer

    actionsSupported: true    // Enable action buttons
    bodyMarkupSupported: true // Allow formatted text
    imageSupported: true      // Allow notification images
  }
  NotificationPopup {}
  Wallpaper {}  
  VolOSD.VolumeOSD {}
  Bar {
    id: bar
  }
}
