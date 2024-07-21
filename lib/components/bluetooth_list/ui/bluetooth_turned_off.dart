import 'package:cubio/page/constants.dart';
import 'package:flutter/material.dart';

class BluetoothTurnedOff extends StatelessWidget {
  const BluetoothTurnedOff({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'PAIR YOUR DEVICE',
          textAlign: TextAlign.center,
        ),
      ),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Icon(
                  Icons.bluetooth_disabled,
                  size: 250,
                  color: Colors.lightBlue,
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48.0),
                  child: Text(
                    "TURN ON THE BLUETOOTH",
                    style: titleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
