pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root
  
  property int sampleCount: 500
  property list<int> values: []
  
  onSampleCountChanged: {
    console.log("SampleCount changed to:", sampleCount)
    var newArray = []
    root.values = newArray
    cavaProc.running = false;
    cavaProc.running = true;
  }

  Process {
    id: cavaProc
    
    running: true

    // Simpler command construction - use an array of arguments
    command: [
      "sh",
      "-c",
      "printf '[general]\\nframerate=60\\nbars=" + root.sampleCount + "\\n[output]\\nmethod=raw\\nraw_target=/dev/stdout\\ndata_format=ascii\\nascii_max_range=100\\n[smoothing]\\nnoise_reduction=85\\nmonstercat=1\\ngravity=100' | cava -p /dev/stdin"
    ]

    stdout: SplitParser {
      onRead: data => {
        root.values = data.split(";");
      }
    
    }
  }
}
