import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:loggy/loggy.dart';

final unityCubeProvider =
    StateNotifierProvider<UnityNotifier, UnityWidgetController?>((ref) {
  return UnityNotifier(ref);
});

class UnityNotifier extends StateNotifier<UnityWidgetController?> with UiLoggy {
  final StateNotifierProviderRef<UnityNotifier, UnityWidgetController?> ref;

  UnityNotifier(this.ref) : super(null);

  void assignController(UnityWidgetController controller) {
    state = controller;
  }

  Future<void> doMove(String move) async {
    await state!.postMessage("Cube", "MyMove", move);
  }

  Future<void> doInitial(List<int> cubeColors) async {
    List<String> result = [];

    for (int i = 1; i < cubeColors.length; i++) {
      int item = cubeColors[i];
      if (item == 1) {
        result.add("B");
      }
      if (item == 2) {
        result.add("D");
      }
      if (item == 3) {
        result.add("L");
      }
      if (item == 4) {
        result.add("U");
      }
      if (item == 5) {
        result.add("R");
      }
      if (item == 6) {
        result.add("F");
      }
    }

    String stateReceived = "";

    stateReceived += result[53];
    stateReceived += result[52];
    stateReceived += result[51];
    stateReceived += result[50];
    stateReceived += result[49];
    stateReceived += result[48];
    stateReceived += result[47];
    stateReceived += result[46];
    stateReceived += result[45];

    stateReceived += result[11];
    stateReceived += result[14];
    stateReceived += result[17];
    stateReceived += result[10];
    stateReceived += result[13];
    stateReceived += result[16];
    stateReceived += result[9];
    stateReceived += result[12];
    stateReceived += result[15];

    stateReceived += result[0];
    stateReceived += result[1];
    stateReceived += result[2];
    stateReceived += result[3];
    stateReceived += result[4];
    stateReceived += result[5];
    stateReceived += result[6];
    stateReceived += result[7];
    stateReceived += result[8];

    stateReceived += result[18];
    stateReceived += result[19];
    stateReceived += result[20];
    stateReceived += result[21];
    stateReceived += result[22];
    stateReceived += result[23];
    stateReceived += result[24];
    stateReceived += result[25];
    stateReceived += result[26];

    stateReceived += result[42];
    stateReceived += result[39];
    stateReceived += result[36];
    stateReceived += result[43];
    stateReceived += result[40];
    stateReceived += result[37];
    stateReceived += result[44];
    stateReceived += result[41];
    stateReceived += result[38];

    stateReceived += result[35];
    stateReceived += result[34];
    stateReceived += result[33];
    stateReceived += result[32];
    stateReceived += result[31];
    stateReceived += result[30];
    stateReceived += result[29];
    stateReceived += result[28];
    stateReceived += result[27];

    loggy.debug("Cube State: $stateReceived");

    await state!.postMessage("Cube", "SetupPosition", stateReceived);
  }
}
