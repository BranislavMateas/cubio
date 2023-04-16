import 'package:cubio/components/main_screen/timer/provider/moves_provider.dart';
import 'package:cubio/decoder/communication_decoder.dart';
import 'package:cubio/provider/unity_cube_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';

final cubeDataProvider = StateNotifierProvider<CubeNotifier, List<int>>(
  (ref) => CubeNotifier(ref),
);

class CubeNotifier extends StateNotifier<List<int>> with UiLoggy {
  final Ref ref;

  // This original state will only store the original value (rawData)
  CubeNotifier(this.ref) : super([]);

  List<int> processedData = [];
  List<int> cubeColors = [];

  final CommunicationDecoder _communicationDecoder = CommunicationDecoder();

  int _callNum = 0;

  String _lastMove = "-";

  void process(List<int> rawData) async {
    processedData = _communicationDecoder
        .bytesToCubeOutputData(Uint8List.fromList(rawData));
    cubeColors = _communicationDecoder.cubeOutputToPaperType(processedData);

    if (_callNum != 0) {
      ref.read(movesProvider.notifier).state++;
      _setLastMove();
      await ref.read(unityCubeProvider.notifier).doMove(_lastMove);
    }

    _callNum++;

    state = rawData;
  }

  void _setLastMove() {
    int lastMoveFace = _getNibble(processedData, 32);
    int lastMoveDirection = _getNibble(processedData, 33);

    final List<String> faceNames = [
      "Front",
      "Down",
      "Right",
      "Up",
      "Left",
      "Back",
    ];

    _lastMove =
        faceNames[lastMoveFace - 1][0] + (lastMoveDirection == 1 ? "" : "'");
  }

  int _getNibble(List<int> val, int i) {
    if (i % 2 == 1) {
      return val[(i ~/ 2).floor()] % 16;
    }
    return (val[(i ~/ 2).floor()] / 16).floor();
  }

  bool get isSolved {
    final List<int> solution = [
      0x12,
      0x34,
      0x56,
      0x78,
      0x33,
      0x33,
      0x33,
      0x33,
      0x12,
      0x34,
      0x56,
      0x78,
      0x9a,
      0xbc,
      0x00,
      0x00,
    ];

    if (listEquals(processedData.take(16).toList(), solution)) {
      return true;
    } else {
      return false;
    }
  }

  String get lastMove {
    return _lastMove;
  }
}
