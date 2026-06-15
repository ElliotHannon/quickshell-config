import QtQuick 2.15
import "../services" as Services

Item {
  id: root

  // Visual properties
  property color waveColor: "#4a5568"        // Main wave color
  property color highlightColor: "#6b7a8f"   // Brighter wave highlight
  property real waveIntensity: 100             // How far waves extend from center
  property real lineWidth: 2                   // Width of the wave lines
  property real smoothness: 0.3                 // Animation smoothness (0-1)
  property bool showFill: true                  // Show filled area under waves
  property real waveOpacity: 0.8                 // Overall opacity (renamed from 'opacity')
  property real audioThreshold: 0.5             // Minimum amplitude to consider audio active

  // Technical properties
  property int sampleRate: 50                    // Number of Cava samples
  property bool isAudioActive: false              // Track if audio is playing

  // Smooth the Cava values for nicer animation
  property var smoothedValues: (function() {
    var arr = []
    for (var i = 0; i < 40; i++)
    arr.push(0)
    return arr
  })()

  Component.onCompleted: {
    Services.Cava.sampleCount = root.sampleRate

    var arr = []
    for (var i = 0; i < root.sampleRate; i++) {
      arr.push(0)
    }
    smoothedValues = arr
  }

  onSampleRateChanged: {
    Services.Cava.sampleCount = root.sampleRate
    var newArray = []
    for (var i = 0; i < root.sampleRate; i++) {
      newArray[i] = smoothedValues[i] || 0
    }
    smoothedValues = newArray
  }

  Timer {
    id: updateTimer
    interval: 16  // ~60fps i think
    running: smoothedValues.length > 0
    repeat: true

    onTriggered: {
      if (!smoothedValues || smoothedValues.length === 0){
        return
      }

      if (!Services.Cava || !Services.Cava.values){
        return
      }

      var cavaValues = Services.Cava.values

      if (!cavaValues || cavaValues.length === 0){
        return
      }

      // Check for active audio
      var hasActiveAudio = false
      for (var i = 0; i < Math.min(cavaValues.length, 20); i++) {
        var rawValue = parseFloat(cavaValues[i]) || 0
        if (rawValue > root.audioThreshold) {
          hasActiveAudio = true
          break
        }
      }
      
      root.isAudioActive = hasActiveAudio
      
      var newValues = smoothedValues.slice()

      if (hasActiveAudio) {
        for (var i = 0; i < Math.min(root.sampleRate, cavaValues.length); i++) {
          var rawValue = parseFloat(cavaValues[i]) || 0
          var targetAmplitude = (rawValue / 100) * root.waveIntensity

          newValues[i] += (targetAmplitude - newValues[i]) * root.smoothness
        }
      } else {
        // No audio, fade out the waves to zero
        for (var i = 0; i < newValues.length; i++) {
          newValues[i] += (0 - newValues[i]) * 0.3 
        }
      }

      smoothedValues = newValues
    }
  }


  // Canva drawing
  Canvas {
    id: canvas
    anchors.fill: parent
    opacity: root.waveOpacity

    function getAmplitudeAt(y) {
      var sampleIndex = (y / height) * root.sampleRate
      var i1 = Math.floor(sampleIndex)
      var i2 = Math.min(i1 + 1, root.sampleRate - 1)
      var fraction = sampleIndex - i1

      var val1 = smoothedValues[i1] || 0
      var val2 = smoothedValues[i2] || 0

      return val1 * (1 - fraction) + val2 * fraction
    }

    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)
      
      var hasVisibleWave = false
      for (var i = 0; i < Math.min(root.sampleRate, 20); i++) {
        if (smoothedValues[i] > 0.1) {
          hasVisibleWave = true
          break
        }
      }
      
      if (!hasVisibleWave && !root.showFill) {
        return
      }

      var centerX = width

      if (root.showFill && hasVisibleWave) {
        // Right side fill
        ctx.beginPath()
        ctx.fillStyle = root.waveColor
        ctx.globalAlpha = 0.25

        ctx.moveTo(centerX, 0)

        for (var y = 0; y < height; y++) {
          var amp = getAmplitudeAt(y)
          var x = centerX + amp
          ctx.lineTo(x, y)
        }

        ctx.lineTo(centerX, height)
        ctx.closePath()
        ctx.fill()

        // Left side fill
        ctx.beginPath()
        ctx.moveTo(centerX, 0)

        for (y = 0; y < height; y++) {
          amp = getAmplitudeAt(y)
          x = centerX - amp
          ctx.lineTo(x, y)
        }

        ctx.lineTo(centerX, height)
        ctx.closePath()
        ctx.fill()
      }

      if (hasVisibleWave) {
        ctx.beginPath()
        ctx.strokeStyle = root.highlightColor
        ctx.lineWidth = root.lineWidth
        ctx.globalAlpha = 0.8

        for (y = 0; y < height; y++) {
          amp = getAmplitudeAt(y)
          x = centerX + amp

          if (y === 0) {
            ctx.moveTo(x, y)
          } else {
            ctx.lineTo(x, y)
          }
        }
        ctx.stroke()

        ctx.beginPath()
        ctx.strokeStyle = root.waveColor
        ctx.lineWidth = root.lineWidth
        ctx.globalAlpha = 1

        for (y = 0; y < height; y++) {
          amp = getAmplitudeAt(y)
          x = centerX - amp

          if (y === 0) {
            ctx.moveTo(x, y)
          } else {
            ctx.lineTo(x, y)
          }
        }
        ctx.stroke()

        ctx.beginPath()
        ctx.strokeStyle = root.highlightColor
        ctx.lineWidth = 1
        ctx.globalAlpha = 0.2
        ctx.moveTo(centerX, 0)
        ctx.lineTo(centerX, height)
        ctx.stroke()
      }
    }

    Timer {
      interval: 16
      running: true
      repeat: true
      onTriggered: canvas.requestPaint()
    }
  }
}
