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
        loggy.debug("Bluetooth State: $state");

        if (state != BluetoothAdapterState.unknown) {
          FlutterNativeSplash.remove();

          if (state == BluetoothAdapterState.on) {
            if (ref.read(isConnectedProvider) ==
                BluetoothConnectionState.connected) {
              return const MainScreen();
            } else {
              return const DevicesList();
            }
          } else if (state == BluetoothAdapterState.off) {
            return const BluetoothTurnedOff();
          } else {
            return ErrorPage(errorMsg: state.toString());
          }
        }

        /*
          NOTE: I am returning container, because if the bluetooth state
          is still unknown (the initial), we will still see splash screen.
        */
        return Container();
      },
    );
  }
}
