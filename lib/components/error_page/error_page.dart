import 'package:cubio/page/constants.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String errorMsg;

  const ErrorPage({super.key, required this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ERROR',
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Icon(
                Icons.error,
                size: 250,
                color: Colors.red,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Text(
                  errorMsg,
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
