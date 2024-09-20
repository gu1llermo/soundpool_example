import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:soundpool_example/volume.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PlaySound.initialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                double volume = await Volume.getCurrentVolume();
                PlaySound.beep1(volume: volume);
                // debugPrint('Volume: $volume');
                // beep1 es el elegido, es el sonido que más se parece a los lectores
                // de código de barras
              },
              child: const Text('beep1'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                double volume = await Volume.getCurrentVolume();
                PlaySound.beep2(volume: volume);
                // debugPrint('Volume: $volume');
              },
              child: const Text('beep2'),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaySound {
  static late Soundpool _pool;
  static late int _beep1Id;
  static late int _beep2Id;
  static double _volumeBeep1 = 1.0;
  static double _volumeBeep2 = 1.0;

  static void _initPool() {
    const soundpoolOptions = SoundpoolOptions(
      streamType: StreamType.music,
    );
    _pool = Soundpool.fromOptions(options: soundpoolOptions);
  }

  static Future<void> _loadSounds() async {
    _beep1Id = await _loadBeep1();
    _beep2Id = await _loadBeep2();
  }

  static Future<void> initialized() async {
    _initPool();
    _loadSounds();
  }

  static Future<int> _loadBeep1() async {
    var asset = await rootBundle.load("assets/sounds/beep-07a.mp3");
    return await _pool.load(asset);
  }

  static Future<int> _loadBeep2() async {
    var asset = await rootBundle.load("assets/sounds/beep-08b.mp3");
    return await _pool.load(asset);
  }

  static void beep1({double volume = 1.0}) {
    if (_volumeBeep1 != volume) {
      _volumeBeep1 = volume;
      _pool.setVolume(soundId: _beep1Id, volume: volume);
    }

    _pool.play(_beep1Id);
  }

  static void beep2({double volume = 1.0}) {
    if (_volumeBeep2 != volume) {
      _volumeBeep2 = volume;
      _pool.setVolume(soundId: _beep2Id, volume: volume);
    }
    _pool.play(_beep2Id);
  }
}
