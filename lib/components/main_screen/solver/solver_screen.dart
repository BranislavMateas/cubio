import 'package:carousel_slider/carousel_slider.dart';
import 'package:cubio/components/main_screen/solver/provider/solve_sequence_provider.dart';
import 'package:cubio/page/constants.dart';
import 'package:cubio/provider/cube_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:loggy/loggy.dart';

class SolverScreen extends ConsumerStatefulWidget {
  const SolverScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SolverScreen> createState() => _SolverScreenState();
}

class _SolverScreenState extends ConsumerState<SolverScreen> with UiLoggy {
  @override
  Widget build(BuildContext context) {
    ref.watch(cubeDataProvider);
    var solution = ref.watch(solveSequenceProvider);
    var isSolved = ref.watch(cubeDataProvider.notifier).isSolved;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('SOLVER'),
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
                    List<String> parsedSolution = message.split(" ");
                    ref.read(solveSequenceProvider.notifier).state =
                        parsedSolution
                            .where((element) => element != "")
                            .toList();
                  },
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "SOLVE SEQUENCE",
                          style:
                              titleTextStyle.copyWith(color: appBarTitleColor),
                        ),
                        solution.isEmpty
                            ? Text(
                                !isSolved ? "---" : "CUBE SOLVED!",
                                style: titleTextStyle.copyWith(fontSize: 48),
                              )
                            : CarouselSlider(
                                options: CarouselOptions(
                                  enableInfiniteScroll: false,
                                  aspectRatio: 5 / 1,
                                  viewportFraction: 0.4,
                                ),
                                items: solution
                                    .asMap()
                                    .map((int i, String move) {
                                      return MapEntry(i, Builder(
                                        builder: (BuildContext context) {
                                          return Text(
                                            "${i + 1}. $move",
                                            style: titleTextStyle.copyWith(
                                                fontSize: 48),
                                          );
                                        },
                                      ));
                                    })
                                    .values
                                    .toList(),
                              ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "LAST MOVE",
                          style: regularTextStyle.copyWith(
                              color: appBarTitleColor),
                        ),
                        Text(
                          ref.read(cubeDataProvider.notifier).lastMove,
                          style: titleTextStyle.copyWith(fontSize: 36),
                        ),
                      ],
                    ),
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
