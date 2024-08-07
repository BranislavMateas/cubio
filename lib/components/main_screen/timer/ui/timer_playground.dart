import 'package:cubio/components/main_screen/timer/ui/custom_dialog.dart';
import 'package:cubio/components/main_screen/solver/provider/solve_sequence_provider.dart';
import 'package:cubio/components/main_screen/timer/provider/moves_provider.dart';
import 'package:cubio/components/main_screen/timer/provider/stopwatch_provider.dart';
import 'package:cubio/components/main_screen/timer/provider/tps_provider.dart';
import 'package:cubio/page/constants.dart';
import 'package:cubio/provider/cube_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerPlayground extends ConsumerStatefulWidget {
  const TimerPlayground({super.key});

  @override
  ConsumerState<TimerPlayground> createState() => _TimerPlaygroundState();
}

class _TimerPlaygroundState extends ConsumerState<TimerPlayground> with UiLoggy {
  int lastMovesNum = 0;
  double lastTPSNum = 0;
  bool hasStarted = false;
  bool shouldPop = true;

  Future<void> setResults() async {
    final prefs = await SharedPreferences.getInstance();

    final savedMoves = prefs.getStringList("moveList") ?? [];
    savedMoves.add(ref.read(movesProvider).toString());
    await prefs.setStringList("moveList", savedMoves);

    final savedTps = prefs.getStringList("tpsList") ?? [];
    savedTps.add(ref.read(tpsProvider).toStringAsFixed(2));
    await prefs.setStringList("tpsList", savedTps);

    final savedTime = prefs.getStringList("timeList") ?? [];
    savedTime.add(ref.read(stopwatchProvider.notifier).totalSeconds.toStringAsFixed(2));
    await prefs.setStringList("timeList", savedTime);
  }

  @override
  Widget build(BuildContext context) {
    final moves = ref.watch(movesProvider);
    if (moves > 0 && !hasStarted) {
      ref.read(stopwatchProvider.notifier).startStopwatch();
      hasStarted = true;
    }

    final isSolved = ref.watch(cubeDataProvider.notifier).isSolved;
    if (isSolved && shouldPop) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(stopwatchProvider.notifier).stopStopwatch();

        showDialog(
          context: context,
          builder: (context) => const CustomDialogBox(
            title: "CONGRATS!",
            descriptions: "YOU HAVE NOW SOLVED THE CUBE! CHECK YOUR RESULTS, THEY WILL ALSO APPEAR IN A STATS WINDOW NOW!",
            text: "RESULTS",
          ),
        );

        setState(() {
          lastMovesNum = ref.read(movesProvider);
          lastTPSNum = ref.read(tpsProvider);
          shouldPop = false;
        });

        setResults();
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('TIMER'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: UnityWidget(
                  runImmediately: true,
                  onUnityCreated: (controller) {},
                  onUnityMessage: (message) {
                    loggy.debug(message);
                    final parsedSolution = message.split(" ");
                    ref.read(solveSequenceProvider.notifier).state = parsedSolution.where((element) => element.isNotEmpty).toList();
                  },
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Center(
                      child: Text(
                        ref.watch(stopwatchProvider),
                        style: titleTextStyle.copyWith(fontSize: 50),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "MOVES",
                            style: regularTextStyle.copyWith(color: appBarTitleColor),
                          ),
                          Text(
                            !shouldPop ? lastMovesNum.toString() : moves.toString(),
                            style: regularTextStyle,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "TPS",
                            style: regularTextStyle.copyWith(color: appBarTitleColor),
                          ),
                          Text(
                            !shouldPop
                                ? lastTPSNum.toStringAsFixed(2)
                                : ref.watch(tpsProvider).toStringAsFixed(2) == "NaN"
                                  ? "-.--"
                                  : ref.watch(tpsProvider).toStringAsFixed(2),
                            style: regularTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
