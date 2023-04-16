// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';

void main() {
  int getNibble(List<int> val, int i) {
    if (i % 2 == 1) {
      return val[(i ~/ 2).floor()] % 16;
    }
    return (val[(i ~/ 2).floor()] / 16).floor();
  }

  test('decode bytes to mixed data', () {
    List<int> pData = [
      100,
      24,
      83,
      39,
      18,
      49,
      34,
      19,
      83,
      33,
      151,
      202,
      180,
      134,
      99,
      144,
      81,
      99,
      227,
      0,
    ];

    int lastMoveFace = getNibble(pData, 32);
    int lastMoveDirection = getNibble(pData, 33);

    final faceNames = ["Front", "Bottom", "Right", "Top", "Left", "Back"];

    print("Last Move: ${faceNames[lastMoveFace - 1]}");
    print(lastMoveDirection == 1 ? " Face Clockwise" : " Face Anti-Clockwise");
  });
}

