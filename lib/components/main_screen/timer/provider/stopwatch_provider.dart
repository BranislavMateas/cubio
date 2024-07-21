import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'dart:async';

final stopwatchProvider = StateNotifierProvider<StopwatchNotifier, String>(
  (ref) => StopwatchNotifier(ref),
);

class StopwatchNotifier extends StateNotifier<String> with UiLoggy {
  final Ref ref;

  StopwatchNotifier(this.ref) : super("00:00:000");

  final Stopwatch _stopwatch = Stopwatch();
  Timer? timer;

  bool isRunning = false;

  int _minutes = 0;
  int _seconds = 0;
  int _milliseconds = 0;

  void startStopwatch() {
    if (isRunning) return;

    isRunning = true;
    _stopwatch.start();
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      _minutes = _stopwatch.elapsed.inMinutes;
      _seconds = _stopwatch.elapsed.inSeconds % 60;
      _milliseconds = _stopwatch.elapsed.inMilliseconds % 1000;

      state = '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}:${_milliseconds.toString().padLeft(3, '0')}';
    });
  }

  void stopStopwatch() {
    if (!isRunning) return;

    timer?.cancel();
    _stopwatch.stop();
    isRunning = false;
  }

  void resetStopwatch() {
    timer = null;
    _stopwatch.reset();

    _minutes = 0;
    _seconds = 0;
    _milliseconds = 0;

    state = '${0.toString().padLeft(2, '0')}:${0.toString().padLeft(2, '0')}:${0.toString().padLeft(3, '0')}';
  }

  double get totalSeconds {
    return _stopwatch.elapsed.inMilliseconds / 1000;
  }
}
