import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

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
                onPressed: () {
                  PlaySound.beep1();
                  // beep1 es el elegido, es el sonido que más se parece a los lectores
                  // de código de barras
                },
                child: const Text('beep1')),
            ElevatedButton(
                onPressed: () {
                  PlaySound.beep2();
                },
                child: const Text('beep2')),
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

  static void _initPool() {
    const soundpoolOptions = SoundpoolOptions(
      streamType: StreamType.notification,
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

  static void beep1() {
    _pool.play(_beep1Id);
  }

  static void beep2() {
    _pool.play(_beep2Id);
  }
}
