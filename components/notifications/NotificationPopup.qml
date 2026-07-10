import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Window {
    id: popupWindow
    
    x: parent.width - width - 10
    y: 10
    width: 300
    height: childrenRect.height
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    
    Connections {
        target: notificationServer
        function onNotificationAdded(notification) {
            // Add to popup list
            popupList.addNotification(notification)
        }
    }
    
    Column {
        spacing: 5
        Repeater {
            model: popupList.model
            Rectangle {
                width: 280
                height: 60
                color: "#2d2d2d"
                radius: 5
                
                Column {
                    Text {
                        text: model.summary
                        color: "white"
                        font.bold: true
                    }
                    Text {
                        text: model.body
                        color: "#cccccc"
                        wrapMode: Text.WordWrap
                        width: 260
                    }
                }
            }
        }
    }
    
    QtObject {
        id: popupList
        property var model: []
        
        function addNotification(notif) {
            model.push(notif)
            Qt.createQmlObject(`
                Timer {
                    interval: 5000
                    onTriggered: notification.addNotification.remove(notif)
                }
            `, popupWindow, "dismissTimer")
        }
    }
}
