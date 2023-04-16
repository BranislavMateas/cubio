import 'dart:typed_data';

class CommunicationDecoder {
  CommunicationDecoder();

  // Hlavné funkcie
  List<int> bytesToCubeOutputData(Uint8List mixData) {
    var array = Uint8List(20);
    var array2 = [
      80,
      175,
      152,
      32,
      170,
      119,
      19,
      137,
      218,
      230,
      63,
      95,
      46,
      130,
      106,
      175,
      163,
      243,
      20,
      7,
      167,
      21,
      168,
      232,
      143,
      175,
      42,
      125,
      126,
      57,
      254,
      87,
      217,
      91,
      85,
      215,
    ];

    if (mixData.lengthInBytes != 20) {
      return mixData;
    }

    if (mixData.elementAt(18) != 167) {
      return mixData;
    }

    var b = mixData.elementAt(19);
    b &= 15;

    var b2 = mixData.elementAt(19);
    b2 = b2 >> 4;

    for (var b3 = 0; b3 < 19; b3 += 1) {
      array[b3] = mixData.elementAt(b3);
      var array3 = array;
      var b4 = b3;
      array3[b4] = array3[b4] - array2[b + b3];
      var array4 = array;
      var b5 = b3;
      array4[b5] = array4[b5] - array2[b2 + b3];
    }

    return array;
  }

  List<int> cubeOutputToPaperType(List<int> cubeOutput) {
    Uint8List array = Uint8List(55);
    int num = 0;
    Uint8List array2 = Uint8List(8);
    Uint8List array3 = Uint8List(8);
    Uint8List array4 = Uint8List(12);
    Uint8List array5 = Uint8List(12);

    if (cubeOutput.length != 20) {
      for (int i = 0; i < 55; i++) {
        array[i] = 0;
      }
      return array;
    }

    array2[0] = cubeOutput[0] >> 4;
    array2[1] = cubeOutput[0] & 15;
    array2[2] = cubeOutput[1] >> 4;
    array2[3] = cubeOutput[1] & 15;
    array2[4] = cubeOutput[2] >> 4;
    array2[5] = cubeOutput[2] & 15;
    array2[6] = cubeOutput[3] >> 4;
    array2[7] = cubeOutput[3] & 15;
    array3[0] = cubeOutput[4] >> 4;
    array3[1] = cubeOutput[4] & 15;
    array3[2] = cubeOutput[5] >> 4;
    array3[3] = cubeOutput[5] & 15;
    array3[4] = cubeOutput[6] >> 4;
    array3[5] = cubeOutput[6] & 15;
    array3[6] = cubeOutput[7] >> 4;
    array3[7] = cubeOutput[7] & 15;
    array4[0] = cubeOutput[8] >> 4;
    array4[1] = cubeOutput[8] & 15;
    array4[2] = cubeOutput[9] >> 4;
    array4[3] = cubeOutput[9] & 15;
    array4[4] = cubeOutput[10] >> 4;
    array4[5] = cubeOutput[10] & 15;
    array4[6] = cubeOutput[11] >> 4;
    array4[7] = cubeOutput[11] & 15;
    array4[8] = cubeOutput[12] >> 4;
    array4[9] = cubeOutput[12] & 15;
    array4[10] = cubeOutput[13] >> 4;
    array4[11] = cubeOutput[13] & 15;

    for (int b = 0; b < 12; b += 1) {
      array5[b] = 0;
    }

    if ((cubeOutput[14] & 128) != 0) {
      array5[0] = 2;
    } else {
      array5[0] = 1;
    }
    if ((cubeOutput[14] & 64) != 0) {
      array5[1] = 2;
    } else {
      array5[1] = 1;
    }
    if ((cubeOutput[14] & 32) != 0) {
      array5[2] = 2;
    } else {
      array5[2] = 1;
    }
    if ((cubeOutput[14] & 16) != 0) {
      array5[3] = 2;
    } else {
      array5[3] = 1;
    }
    if ((cubeOutput[14] & 8) != 0) {
      array5[4] = 2;
    } else {
      array5[4] = 1;
    }
    if ((cubeOutput[14] & 4) != 0) {
      array5[5] = 2;
    } else {
      array5[5] = 1;
    }
    if ((cubeOutput[14] & 2) != 0) {
      array5[6] = 2;
    } else {
      array5[6] = 1;
    }
    if ((cubeOutput[14] & 1) != 0) {
      array5[7] = 2;
    } else {
      array5[7] = 1;
    }
    if ((cubeOutput[15] & 128) != 0) {
      array5[8] = 2;
    } else {
      array5[8] = 1;
    }
    if ((cubeOutput[15] & 64) != 0) {
      array5[9] = 2;
    } else {
      array5[9] = 1;
    }
    if ((cubeOutput[15] & 32) != 0) {
      array5[10] = 2;
    } else {
      array5[10] = 1;
    }
    if ((cubeOutput[15] & 16) != 0) {
      array5[11] = 2;
    } else {
      array5[11] = 1;
    }
    array[32] = 1;
    array[41] = 2;
    array[50] = 3;
    array[14] = 4;
    array[23] = 5;
    array[5] = 6;

    num |= _converseAngleSetXFirst(array, array2[0], array3[0], 34, 43, 54);
    num |= _converseAngleSetYFirst(array, array2[1], array3[1], 36, 52, 18);
    num |= _converseAngleSetXFirst(array, array2[2], array3[2], 30, 16, 27);
    num |= _converseAngleSetYFirst(array, array2[3], array3[3], 28, 25, 45);
    num |= _converseAngleSetYFirst(array, array2[4], array3[4], 1, 48, 37);
    num |= _converseAngleSetXFirst(array, array2[5], array3[5], 3, 12, 46);
    num |= _converseAngleSetYFirst(array, array2[6], array3[6], 9, 21, 10);
    num |= _converseAngleSetXFirst(array, array2[7], array3[7], 7, 39, 19);
    num |= _converseLineSet(array, array4[0], array5[0], 31, 44);
    num |= _converseLineSet(array, array4[1], array5[1], 35, 53);
    num |= _converseLineSet(array, array4[2], array5[2], 33, 17);
    num |= _converseLineSet(array, array4[3], array5[3], 29, 26);
    num |= _converseLineSet(array, array4[4], array5[4], 40, 51);
    num |= _converseLineSet(array, array4[5], array5[5], 15, 49);
    num |= _converseLineSet(array, array4[6], array5[6], 13, 24);
    num |= _converseLineSet(array, array4[7], array5[7], 42, 22);
    num |= _converseLineSet(array, array4[8], array5[8], 4, 38);
    num |= _converseLineSet(array, array4[9], array5[9], 2, 47);
    num |= _converseLineSet(array, array4[10], array5[10], 6, 11);
    num |= _converseLineSet(array, array4[11], array5[11], 8, 20);

    _converseChangeFaceAgain(array, 1, 7, 9, 3);
    _converseChangeFaceAgain(array, 4, 8, 6, 2);
    _converseChangeFaceAgain(array, 37, 19, 10, 46);
    _converseChangeFaceAgain(array, 38, 20, 11, 47);
    _converseChangeFaceAgain(array, 39, 21, 12, 48);
    _converseChangeFaceAgain(array, 40, 22, 13, 49);
    _converseChangeFaceAgain(array, 41, 23, 14, 50);
    _converseChangeFaceAgain(array, 42, 24, 15, 51);
    _converseChangeFaceAgain(array, 43, 25, 16, 52);
    _converseChangeFaceAgain(array, 44, 26, 17, 53);
    _converseChangeFaceAgain(array, 45, 27, 18, 54);
    _converseChangeFaceAgain(array, 34, 28, 30, 36);
    _converseChangeFaceAgain(array, 31, 29, 33, 35);

    if (num != 0) {
      for (int j = 0; j < 55; j++) {
        array[j] = 0;
      }
    }

    return array;
  }

  // Pomocné funkcie
  int _converseAngleSetXFirst(Uint8List cube, angle, angleFace, f1, f2, f3) {
    int num = 0;
    if (angle == 1) {
      num |=
          _converseAngleSetSingleXFirst(cube, angleFace, f1, f2, f3, 1, 2, 3);
    } else if (angle == 2) {
      num |=
          _converseAngleSetSingleXFirst(cube, angleFace, f1, f2, f3, 1, 3, 4);
    } else if (angle == 3) {
      num |=
          _converseAngleSetSingleXFirst(cube, angleFace, f1, f2, f3, 1, 4, 5);
    } else if (angle == 4) {
      num |=
          _converseAngleSetSingleXFirst(cube, angleFace, f1, f2, f3, 1, 5, 2);
    } else if (angle == 5) {
      num |=
          _converseAngleSetSingleXFirst(cube, angleFace, f1, f2, f3, 6, 3, 2);
    } else if (angle == 6) {
      num |=
          _converseAngleSetSingleXFirst(cube, angleFace, f1, f2, f3, 6, 4, 3);
    } else if (angle == 7) {
      num |=
          _converseAngleSetSingleXFirst(cube, angleFace, f1, f2, f3, 6, 5, 4);
    } else if (angle == 8) {
      num |=
          _converseAngleSetSingleXFirst(cube, angleFace, f1, f2, f3, 6, 2, 5);
    } else {
      num |= 2;
    }
    return num;
  }

  int _converseAngleSetSingleXFirst(cube, angleFace, p1, p2, p3, c1, c2, c3) {
    int result = 0;
    if (angleFace == 1) {
      cube[p1] = c3;
      cube[p2] = c1;
      cube[p3] = c2;
    } else if (angleFace == 2) {
      cube[p1] = c2;
      cube[p2] = c3;
      cube[p3] = c1;
    } else if (angleFace == 3) {
      cube[p1] = c1;
      cube[p2] = c2;
      cube[p3] = c3;
    } else {
      result = 1;
    }

    return result;
  }

  int _converseAngleSetYFirst(cube, angle, angleFace, f1, f2, f3) {
    int num = 0;
    if (angle == 1) {
      num |=
          _converseAngleSetSingleYFirst(cube, angleFace, f1, f2, f3, 1, 2, 3);
    } else if (angle == 2) {
      num |=
          _converseAngleSetSingleYFirst(cube, angleFace, f1, f2, f3, 1, 3, 4);
    } else if (angle == 3) {
      num |=
          _converseAngleSetSingleYFirst(cube, angleFace, f1, f2, f3, 1, 4, 5);
    } else if (angle == 4) {
      num |=
          _converseAngleSetSingleYFirst(cube, angleFace, f1, f2, f3, 1, 5, 2);
    } else if (angle == 5) {
      num |=
          _converseAngleSetSingleYFirst(cube, angleFace, f1, f2, f3, 6, 3, 2);
    } else if (angle == 6) {
      num |=
          _converseAngleSetSingleYFirst(cube, angleFace, f1, f2, f3, 6, 4, 3);
    } else if (angle == 7) {
      num |=
          _converseAngleSetSingleYFirst(cube, angleFace, f1, f2, f3, 6, 5, 4);
    } else if (angle == 8) {
      num |=
          _converseAngleSetSingleYFirst(cube, angleFace, f1, f2, f3, 6, 2, 5);
    } else {
      num |= 2;
    }

    return num;
  }

  int _converseAngleSetSingleYFirst(cube, angleFace, p1, p2, p3, c1, c2, c3) {
    int result = 0;

    if (angleFace == 2) {
      cube[p1] = c3;
      cube[p2] = c1;
      cube[p3] = c2;
    } else if (angleFace == 1) {
      cube[p1] = c2;
      cube[p2] = c3;
      cube[p3] = c1;
    } else if (angleFace == 3) {
      cube[p1] = c1;
      cube[p2] = c2;
      cube[p3] = c3;
    } else {
      result = 1;
    }

    return result;
  }

  int _converseLineSet(cube, line, lineFace, p1, p2) {
    int num = 0;

    if (line == 1) {
      num |= _converseLineSetSingle(cube, lineFace, p1, p2, 1, 2);
    } else if (line == 2) {
      num |= _converseLineSetSingle(cube, lineFace, p1, p2, 1, 3);
    } else if (line == 3) {
      num |= _converseLineSetSingle(cube, lineFace, p1, p2, 1, 4);
    } else if (line == 4) {
      num |= _converseLineSetSingle(cube, lineFace, p1, p2, 1, 5);
    } else if (line == 5) {
      num |= _converseLineSetSingle(cube, lineFace, p1, p2, 2, 3);
    } else if (line == 6) {
      num |= _converseLineSetSingle(cube, lineFace, p1, p2, 4, 3);
    } else if (line == 7) {
      num |= _converseLineSetSingle(cube, lineFace, p1, p2, 4, 5);
    } else if (line == 8) {
      num |= _converseLineSetSingle(cube, lineFace, p1, p2, 2, 5);
    } else if (line == 9) {
      num |= _converseLineSetSingle(cube, lineFace, p1, p2, 6, 2);
    } else if (line == 10) {
      num |= _converseLineSetSingle(cube, lineFace, p1, p2, 6, 3);
    } else if (line == 11) {
      num |= _converseLineSetSingle(cube, lineFace, p1, p2, 6, 4);
    } else if (line == 12) {
      num |= _converseLineSetSingle(cube, lineFace, p1, p2, 6, 5);
    } else {
      num = 4;
    }

    return num;
  }

  int _converseLineSetSingle(cube, lineFace, p1, p2, c1, c2) {
    int result = 0;

    if (lineFace == 1) {
      cube[p1] = c1;
      cube[p2] = c2;
    } else if (lineFace == 2) {
      cube[p1] = c2;
      cube[p2] = c1;
    } else {
      result = 3;
    }

    return result;
  }

  void _converseChangeFaceAgain(cube, a1, a2, a3, a4) {
    var num = cube[a4];
    cube[a4] = cube[a3];
    cube[a3] = cube[a2];
    cube[a2] = cube[a1];
    cube[a1] = num;
  }
}
