pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.Mpris


Singleton {
  id: root

  readonly property list<MprisPlayer> values: Mpris.players.values
  readonly property MprisPlayer activePlayer: values.find(player => player.identity === "Spotify") ?? values[0] ?? null
}
