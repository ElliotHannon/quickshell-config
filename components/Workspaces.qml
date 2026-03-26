import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent
    property int popupYpos: 0

    signal workspaceAdded(workspace: HyprlandWorkspace)
    property int workspaceCount: 0

    property color inactiveColor: "#ffffff"
    property color focusedColor: "#55cc36"
    property color activeColor: "#974982"

    property int workspaceHeight: 8
    property int workspaceWidth: 20
    property int focusedWidth: 40
    property int workspaceSpacing: 4


    Column {
        id: container
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        spacing: workspaceSpacing
        
        Repeater {
            model: 10
            
            Item {
                id: workspaceItem
                width: container.width
                height: workspaceHeight
                
                required property int index
                property int workspaceIndex: index + 1
                property HyprlandWorkspace workspace: null
                property bool exists: workspace !== null
                property bool active: workspace?.active ?? false

                Connections {
                    target: root
                    function onWorkspaceAdded(workspace: HyprlandWorkspace) {
                        if (workspace.id == workspaceItem.workspaceIndex) {
                            workspaceItem.workspace = workspace;
                        }
                    }
                }

                Rectangle {
                    anchors.centerIn: parent
                    
                    width: active ? focusedWidth : workspaceWidth
                    height: workspaceHeight
                    radius: height / 2
                    
                    color: {
                        if (!exists) return inactiveColor
                        if (active) return focusedColor
                        return activeColor
                    }
                    
                    Component.onCompleted: {
                        console.log("Indicator for workspace", workspaceIndex, 
                                  "width:", width, "height:", height,
                                  "color:", color);
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch(`workspace ${workspaceIndex}`)
                }
            }
        }
    }

    Connections {
        target: Hyprland.workspaces
        enabled: true
        function onObjectInsertedPost(workspace) {
            root.workspaceAdded(workspace);
        }
    }

    Component.onCompleted: {
        Hyprland.workspaces.values.forEach(workspace => {
            root.workspaceAdded(workspace);
        });
    }
}
