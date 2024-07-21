import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceNameProvider = StateProvider<String>((ref) => "");

final isConnectedProvider = StateProvider<BluetoothConnectionState>(
  (ref) => BluetoothConnectionState.disconnected,
);
