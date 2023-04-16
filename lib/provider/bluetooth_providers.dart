import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bluetoothInstanceProvider = StateProvider<FlutterBluePlus>(
  (ref) => FlutterBluePlus.instance,
);

final deviceNameProvider = StateProvider<String>((ref) => "");

final isConnectedProvider = StateProvider<BluetoothDeviceState>(
    (ref) => BluetoothDeviceState.disconnected);
