import 'package:cubio/page/constants.dart';
import 'package:cubio/provider/bluetooth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectedDevice extends ConsumerStatefulWidget {
  const ConnectedDevice({Key? key}) : super(key: key);

  @override
  ConsumerState<ConnectedDevice> createState() => _ConnectedDeviceState();
}

class _ConnectedDeviceState extends ConsumerState<ConnectedDevice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(4),
          child: IconButton(
            iconSize: 28,
            splashRadius: 28,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () async {
              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        title: const Text(
          'CONNECTED CUBE',
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset("assets/cube.png"),
              Column(
                children: [
                  const Text("DEVICE NAME:", style: titleTextStyle),
                  Text(
                    ref.read(deviceNameProvider),
                    style: titleTextStyle.copyWith(
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
