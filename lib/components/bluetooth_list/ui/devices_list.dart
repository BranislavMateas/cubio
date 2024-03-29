import 'package:cubio/components/bluetooth_list/enums/supported_devices.dart';
import 'package:cubio/page/constants.dart';
import 'package:cubio/provider/bluetooth_providers.dart';
import 'package:cubio/provider/cube_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loggy/loggy.dart';
import 'dart:math';

const serviceUUID = '0000aadb-0000-1000-8000-00805f9b34fb';
const characteristicUUID = '0000aadc-0000-1000-8000-00805f9b34fb';

class DevicesList extends ConsumerStatefulWidget {
  const DevicesList({Key? key}) : super(key: key);

  @override
  ConsumerState<DevicesList> createState() => _DevicesListState();
}

class _DevicesListState extends ConsumerState<DevicesList> with UiLoggy {
  bool isConnecting = false;

  final Color chosen = cubeColorsList[Random().nextInt(cubeColorsList.length)];

  @override
  void initState() {
    super.initState();
    ref
        .read(bluetoothInstanceProvider)
        .startScan(timeout: const Duration(seconds: bluetoothScanDur));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'PAIR YOUR DEVICE',
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: ref.read(bluetoothInstanceProvider).isScanning,
        initialData: true, // Pretože začíname scan už na začiatku
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () {
                ref.read(bluetoothInstanceProvider).stopScan();
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                ref.read(bluetoothInstanceProvider).startScan(
                      timeout: const Duration(seconds: bluetoothScanDur),
                    );
              },
              child: const Icon(Icons.search),
            );
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48.0),
                  child: Text(
                    "SEARCHING FOR DEVICES...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Naskenované zariadenia
              StreamBuilder<List<ScanResult>>(
                stream: ref.read(bluetoothInstanceProvider).scanResults,
                initialData: const [],
                builder: (c, snapshot) {
                  var items = snapshot.data!
                      .where((element) =>
                          element.device.name.isNotEmpty &&
                          element.device.name == SupportedDevices.Gi163347.name)
                      .toList();

                  // Kontrola. či existujú nejaké naskenované zariadenia
                  return items.isEmpty
                      ? StreamBuilder<bool>(
                          stream:
                              ref.read(bluetoothInstanceProvider).isScanning,
                          initialData: true,
                          builder: (c, snapshot) {
                            // Ak zariadenie vyhľadáva
                            if (snapshot.data!) {
                              return const Expanded(
                                child: Center(
                                  child: SpinKitFadingGrid(
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ),
                              );
                            } else {
                              return const Expanded(
                                child: Center(
                                  child: Text(
                                    "NO DEVICES FOUND.",
                                    style: regularTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      : SingleChildScrollView(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              var item = items[index];

                              return ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => Colors.transparent),
                                  shape: MaterialStateProperty.resolveWith(
                                    (states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(
                                        color: chosen,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.device.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      isConnecting
                                          ? const SpinKitFadingGrid(
                                              color: Colors.white,
                                              size: 15.0,
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isConnecting = true;
                                  });

                                  await item.device.connect(autoConnect: false);

                                  item.device.state.listen((s) {
                                    ref
                                        .read(isConnectedProvider.notifier)
                                        .state = s;
                                  });

                                  List<BluetoothService> services =
                                      await item.device.discoverServices();
                                  for (var service in services) {
                                    if (service.uuid.toString() ==
                                        serviceUUID) {
                                      var characteristics =
                                          service.characteristics;
                                      for (BluetoothCharacteristic c
                                          in characteristics) {
                                        if (c.uuid.toString() ==
                                            characteristicUUID) {
                                          await c.setNotifyValue(true);
                                          ref
                                              .read(deviceNameProvider.notifier)
                                              .state = item.device.name;
                                          c.value.listen((value) async {
                                            loggy
                                                .debug("Data Received: $value");
                                            ref
                                                .read(cubeDataProvider.notifier)
                                                .process(value);
                                          });
                                        }
                                      }
                                    }
                                  }

                                  setState(() {
                                    isConnecting = false;
                                  });

                                  if (!mounted) return;
                                  Navigator.pushNamed(context, '/menu');
                                },
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 10);
                            },
                            itemCount: items.length,
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
