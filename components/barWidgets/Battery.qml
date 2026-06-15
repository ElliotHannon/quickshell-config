// components/barWidgets/Battery.qml
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick.Layouts
import QtQuick

Item {
  id: root

  implicitWidth: iconText.implicitWidth
  implicitHeight: iconText.implicitHeight

  property color textColor: "#ffffbb"
  property color chargingColor: "#55ff22"
  property color lowBatteryColor: "#ffdd33"
  property color criticalBatteryColor: "#dd3344"
  property int fontSize: 10
  property int iconSize: 15
  readonly property var displayDevice: UPower ? UPower.displayDevice : null
  readonly property string battery10Icon: "󰂃"
  readonly property string battery20Icon: "󰁻"
  readonly property string battery30Icon: "󰁼"
  readonly property string battery40Icon: "󰁼"
  readonly property string battery50Icon: "󰁾"
  readonly property string battery60Icon: "󰁿"
  readonly property string battery70Icon: "󰂀"
  readonly property string battery80Icon: "󰂁"
  readonly property string battery90Icon: "󰂂"
  readonly property string battery100Icon: "󰁹"

  readonly property string battery10IconCharging: "󰂄"
  readonly property string battery20IconCharging: "󰂄"
  readonly property string battery30IconCharging: "󰂄"
  readonly property string battery40IconCharging: "󰂄"
  readonly property string battery50IconCharging: "󰂄"
  readonly property string battery60IconCharging: "󰂄"
  readonly property string battery70IconCharging: "󰂄"
  readonly property string battery80IconCharging: "󰂄"
  readonly property string battery90IconCharging: "󰂄"
  readonly property string battery100IconCharging: "󱈑"
  readonly property real percentage: displayDevice.percentage

  readonly property var chargeState: displayDevice ? displayDevice.state : 0
  readonly property bool isCharging: chargeState == UPowerDeviceState.Charging
  readonly property bool isDocked: chargeState != UPowerDeviceState.Charging && UPower.displayDevice.changeRate <= 0.01
  readonly property bool isLow: percentage < 0.20

  function findBatteryIcon() {
    if (percentage >= 0.9) {return (isCharging|isDocked) ? battery100IconCharging : battery100Icon;}
    if (percentage >= 0.80) {return isCharging ? battery90IconCharging : battery90Icon;}
    if (percentage >= 0.70) {return isCharging ? battery80IconCharging : battery80Icon;}
    if (percentage >= 0.60) {return isCharging ? battery70IconCharging : battery70Icon;}
    if (percentage >= 0.50) {return isCharging ? battery60IconCharging : battery60Icon;}
    if (percentage >= 0.40) {return isCharging ? battery50IconCharging : battery50Icon;}
    if (percentage >= 0.30) {return isCharging ? battery40IconCharging : battery40Icon;}
    if (percentage >= 0.20) {return isCharging ? battery30IconCharging : battery30Icon;}
    if (percentage >= 0.10) {return isCharging ? battery20IconCharging : battery20Icon;}
    if (percentage >= 0.00) {return isCharging ? battery10IconCharging : battery10Icon;}
    return "󰂑";
  }

  function findColor() {
    if (isCharging | isDocked) {return chargingColor;}
    if (percentage <= 0.10) {return criticalBatteryColor;}
    if (percentage <= 0.20) {return lowBatteryColor;}
    return textColor;
  }

  Text {
    id: iconText
    anchors.centerIn: parent
    color: findColor()
    text: findBatteryIcon()
    font.pointSize: iconSize
    font.family: "Nerd-font"
    
    Behavior on color {
      ColorAnimation {
        duration: 250
        easing.type: Easing.InOutQuad
      }
    }
  }
}
