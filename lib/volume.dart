import 'package:real_volume/real_volume.dart';
import 'package:flutter/foundation.dart';

class Volume {
  static Future<double> getCurrentVolume() async {
    if (kIsWeb) {
      double notificationVolume =
          (await RealVolume.getCurrentVol(StreamType.MUSIC)) ?? 0.0;
      return notificationVolume;
    }
    return 1.0;
  }
}
