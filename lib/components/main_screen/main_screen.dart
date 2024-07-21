import 'dart:math';
import 'package:cubio/components/main_screen/solver/provider/solve_sequence_provider.dart';
import 'package:cubio/components/main_screen/ui/primary_button.dart';
import 'package:cubio/page/constants.dart';
import 'package:cubio/provider/bluetooth_providers.dart';
import 'package:cubio/provider/cube_data_provider.dart';
import 'package:cubio/provider/unity_cube_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:loggy/loggy.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  static List<Color> menuColors = [];

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with UiLoggy {
  List<Color> generateUniqueColors() {
    List<Color> result = [];

    while (result.length != 3) {
      Color chosen = cubeColorsList[Random().nextInt(cubeColorsList.length)];
      if (!result.contains(chosen)) {
        result.add(chosen);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    MainScreen.menuColors = generateUniqueColors();

    var isConnected = ref.watch(isConnectedProvider);
    if (isConnected != BluetoothConnectionState.connected) {
      Navigator.pushNamed(context, '/');
    }

    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          UnityWidget(
            runImmediately: true,
            onUnityCreated: (controller) async {
              var unityProvider = ref.read(unityCubeProvider.notifier);
              unityProvider.assignController(controller);
              await unityProvider
                  .doInitial(ref.read(cubeDataProvider.notifier).cubeColors);
            },
            onUnityMessage: (message) {
              loggy.debug(message);
              List<String> parsedSolution = message.split(" ");
              ref.read(solveSequenceProvider.notifier).state =
                  parsedSolution.where((element) => element != "").toList();
            },
          ),
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: IconButton(
                    iconSize: 28,
                    splashRadius: 28,
                    icon: const Icon(
                      Icons.bluetooth,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (!mounted) return;
                      Navigator.pushNamed(context, '/connected');
                    },
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/logo.png",
                        width: 243,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PrimaryButton(
                          color: MainScreen.menuColors[0],
                          text: "SOLVER",
                          route: "/solver",
                          checkForSolve: true,
                        ),
                        const SizedBox(height: 16),
                        PrimaryButton(
                          color: MainScreen.menuColors[1],
                          text: "TIMER",
                          route: "/timer",
                          checkForSolve: false,
                        ),
                        const SizedBox(height: 16),
                        PrimaryButton(
                          color: MainScreen.menuColors[2],
                          text: "STATS",
                          route: "/stats",
                          checkForSolve: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
