import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Qt.labs.settings  // For file watching

Scope {
    id: root
    
    property int brightness: 50
    property bool shouldShowOsd: false
    
    // Timer that polls brightness files (like an animation frame)
    Timer {
        id: brightnessWatcher
        interval: 100  // Check every 100ms (fast enough for smooth OSD)
        running: true
        repeat: true
        onTriggered: {
            var newBrightness = getCurrentBrightness()
            if (newBrightness !== root.brightness) {
                // Brightness changed!
                root.brightness = newBrightness
                root.shouldShowOsd = true
                hideTimer.restart()
            }
        }
    }
    
    function getCurrentBrightness() {
        var output = Qt.btoa(Quickshell.exec("brightnessctl g") || "50")
        var maxOut = Qt.btoa(Quickshell.exec("brightnessctl m") || "100")
        return Math.round((parseInt(output) / parseInt(maxOut)) * 100)
    }
    
    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }
    
    Component.onCompleted: {
        root.brightness = getCurrentBrightness()
    }
    
    // Your OSD UI here...
    LazyLoader {
        active: root.shouldShowOsd
        PanelWindow {
            // ... UI same as before
        }
    }
}
