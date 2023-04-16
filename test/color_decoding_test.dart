import 'dart:typed_data';
import 'package:cubio/decoder/communication_decoder.dart';
import 'package:test/test.dart';

void main() {
  CommunicationDecoder communicationDecoder = CommunicationDecoder();

  test('decode bytes to mixed data', () {
    // 13, 156, 176, 121, 250, 57, 138, 188, 97, 242, 12, 72, 106, 208, 107, 76, 64, 153, 167, 55

    Uint8List uint8list = Uint8List(20);

    uint8list[0] = 13;
    uint8list[1] = 156;
    uint8list[2] = 176;
    uint8list[3] = 121;
    uint8list[4] = 250;
    uint8list[5] = 57;
    uint8list[6] = 138;
    uint8list[7] = 188;
    uint8list[8] = 97;
    uint8list[9] = 242;
    uint8list[10] = 12;
    uint8list[11] = 72;
    uint8list[12] = 106;
    uint8list[13] = 208;
    uint8list[14] = 107;
    uint8list[15] = 76;
    uint8list[16] = 64;
    uint8list[17] = 153;
    uint8list[18] = 167;
    uint8list[19] = 55;

    var expected = [
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
    var result = communicationDecoder.bytesToCubeOutputData(uint8list);

    expect(result, expected);
  });

  test("paper type conversion", () {
    List<int> cubeOutput = [
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

    List<int> result = communicationDecoder.cubeOutputToPaperType(cubeOutput);
    List<int> expected = [
      0,
      4,
      2,
      3,
      1,
      6,
      3,
      2,
      4,
      6,
      4,
      4,
      4,
      6,
      5,
      6,
      5,
      2,
      3,
      3,
      6,
      5,
      6,
      2,
      3,
      6,
      3,
      6,
      3,
      2,
      2,
      4,
      1,
      1,
      2,
      3,
      1,
      1,
      5,
      6,
      5,
      3,
      2,
      1,
      1,
      4,
      1,
      5,
      5,
      5,
      4,
      4,
      2,
      1,
      5
    ];

    expect(result, expected);
  });
}
