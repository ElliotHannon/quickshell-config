import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    id: caffeineButton
    property bool active: false
    property var idleManager: null
    
    // Icon states
    property string iconActive: "☕"  // or use a proper icon
    property string iconInactive: "⏸"
    
    text: active ? iconActive : iconInactive
    font.pixelSize: 16
    
    ToolTip.text: active ? "Caffeine mode: ON (click to disable)" : "Caffeine mode: OFF (click to enable)"
    ToolTip.visible: hovered
    ToolTip.delay: 500
    
    onClicked: {
        if (idleManager) {
            idleManager.toggleCaffeine();
        }
    }
    
    // Update button state from idle manager
    Connections {
        target: idleManager
        function onCaffeineModeChanged() {
            caffeineButton.active = idleManager.caffeineMode;
        }
    }
    
    Component.onCompleted: {
        if (idleManager) {
            active = idleManager.caffeineMode;
        }
    }
}
