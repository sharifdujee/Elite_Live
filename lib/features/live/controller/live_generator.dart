

import 'dart:math';

class LiveGenerator {
  static final Random _random = Random();

  /// Generate a random 6 digit ID
  static String _randomId() {
    return (_random.nextInt(900000) + 100000).toString();
  }

  static Map<String, dynamic> generateLiveSession({bool isPaid = false}) {
    String hostId = _randomId();
    String roomId = "room_${_randomId()}";

    /// If paid, random cost 10–100
    /// If free, cost = 0
    int cost = isPaid ? (_random.nextInt(90) + 10) : 0;

    /// HOST LINK → starts the live
    String hostLink = "https://live.host.zegocloud.com/start/$roomId?host=$hostId";

    /// AUDIENCE LINK → watchers join the live
    String audienceLink = "https://live.zegocloud.com/watch/$roomId";

    return {
      "hostId": hostId,
      "roomId": roomId,
      "hostLink": hostLink,
      "audienceLink": audienceLink,
      "cost": cost,
    };
  }
}
