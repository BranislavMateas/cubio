import 'package:cubio/components/main_screen/timer/provider/moves_provider.dart';
import 'package:cubio/components/main_screen/timer/provider/stopwatch_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tpsProvider = StateProvider<double>((ref) {
  return ref
      .read(stopwatchProvider.notifier)
      .totalSeconds /
      ref.watch(movesProvider);
});
