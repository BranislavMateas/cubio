import 'package:cubio/components/bluetooth_list/ui/bluetooth_turned_off.dart';
import 'package:cubio/components/bluetooth_list/ui/devices_list.dart';
import 'package:cubio/components/error_page/error_page.dart';
import 'package:cubio/components/main_screen/main_screen.dart';
import 'package:cubio/provider/bluetooth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';

class BluetoothList extends ConsumerWidget with UiLoggy {
  const BluetoothList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<BluetoothAdapterState>(
      stream: FlutterBluePlus.adapterState,
      initialData: BluetoothAdapterState.unknown,
      builder: (c, snapshot) {
        final state = snapshot.data;

        if (state != BluetoothAdapterState.unknown) {
          FlutterNativeSplash.remove();

          if (state == BluetoothAdapterState.on) {
            return ref.read(isConnectedProvider) == BluetoothConnectionState.connected
                ? const MainScreen()
                : const DevicesList();
          }

          if (state == BluetoothAdapterState.off) {
            return const BluetoothTurnedOff();
          }

          return ErrorPage(errorMsg: state.toString());
        }

        return Container();
      },
    );
  }
}
