import 'package:cubio/components/bluetooth_list/enums/supported_devices.dart';
import 'package:cubio/models/supported_device.dart';
import 'package:cubio/page/constants.dart';
import 'package:cubio/provider/bluetooth_providers.dart';
import 'package:cubio/provider/cube_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loggy/loggy.dart';
import 'dart:math';

class DevicesList extends ConsumerStatefulWidget {
  const DevicesList({super.key});

  @override
  ConsumerState<DevicesList> createState() => _DevicesListState();
}

class _DevicesListState extends ConsumerState<DevicesList> with UiLoggy {
  bool isConnecting = false;

  final Color chosen = cubeColorsList[Random().nextInt(cubeColorsList.length)];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _startBluetoothScan();
  }

  Future<void> _startBluetoothScan() async {
    await FlutterBluePlus.startScan(
      androidUsesFineLocation: true,
      timeout: const Duration(seconds: bluetoothScanDur),
    );
  }

  Future<void> _stopBluetoothScan() async {
    await FlutterBluePlus.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _buildSearchText(),
              const SizedBox(height: 30),
              _buildDeviceStreamBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: const Text(
        'PAIR YOUR DEVICE',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return StreamBuilder<bool>(
      stream: FlutterBluePlus.isScanning,
      initialData: true,
      builder: (context, snapshot) {
        return FloatingActionButton(
          onPressed: snapshot.data! ? _stopBluetoothScan : _startBluetoothScan,
          backgroundColor: snapshot.data! ? Colors.red : Colors.blue,
          child: Icon(snapshot.data! ? Icons.stop : Icons.search),
        );
      },
    );
  }

  Widget _buildSearchText() {
    return const Center(
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
    );
  }

  Widget _buildDeviceStreamBuilder() {
    return StreamBuilder<List<ScanResult>>(
      stream: FlutterBluePlus.onScanResults,
      initialData: const [],
      builder: (context, snapshot) {
        return _buildDeviceList(snapshot.data!);
      },
    );
  }

  Widget _buildDeviceList(List<ScanResult> items) {
    items = _filterSupportedDevices(items);
    return items.isEmpty ? _buildEmptyDeviceList() : _buildDeviceListView(items);
  }

  List<ScanResult> _filterSupportedDevices(List<ScanResult> items) {
    return items.where((element) =>
      element.device.platformName.isNotEmpty &&
      supportedDevices.map((e) => e.deviceName).contains(element.device.platformName)
    ).toList();
  }

  Widget _buildEmptyDeviceList() {
    return StreamBuilder<bool>(
      stream: FlutterBluePlus.isScanning,
      initialData: true,
      builder: (context, snapshot) {
        return snapshot.data!
            ? const Expanded(
          child: Center(
            child: SpinKitFadingGrid(
              color: Colors.white,
              size: 50.0,
            ),
          ),
        ) : const Expanded(
          child: Center(
            child: Text(
              "NO DEVICES FOUND.",
              style: regularTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeviceListView(List<ScanResult> items) {
    return SingleChildScrollView(
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var item = items[index];
          return _buildDeviceButton(item);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        itemCount: items.length,
      ),
    );
  }

  Widget _buildDeviceButton(ScanResult item) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) =>
        Colors.transparent),
        shape: WidgetStateProperty.resolveWith((states) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: chosen),
          );
        }),
      ),
      onPressed: () async => await _connectToDevice(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.device.platformName,
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
            isConnecting
                ? const SpinKitFadingGrid(color: Colors.white, size: 15.0)
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Future<void> _connectToDevice(ScanResult item) async {
    SupportedDevice targetDevice = supportedDevices
        .firstWhere((element) => element.deviceName == item.device.platformName);

    setState(() {
      isConnecting = true;
    });

    await item.device.connect(autoConnect: false);

    item.device.connectionState.listen((s) {
      ref.read(isConnectedProvider.notifier).state = s;
    });

    List<BluetoothService> services = await item.device.discoverServices();

    for (var service in services) {
      if (service.uuid.toString() == targetDevice.serviceUuid) {
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.uuid.toString() == targetDevice.characteristicUuid) {
            await c.setNotifyValue(true);
            ref.read(deviceNameProvider.notifier).state = item.device.platformName;

            c.lastValueStream.listen((value) async {
              loggy.debug("Data Received: $value");
              ref.read(cubeDataProvider.notifier).process(value);
            });
          }
        }
      }
    }

    setState(() {
      isConnecting = false;
    });

    if (mounted) {
      Navigator.pushNamed(context, '/menu');
    }
  }
}
