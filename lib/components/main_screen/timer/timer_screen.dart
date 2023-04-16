import 'package:cubio/components/main_screen/main_screen.dart';
import 'package:cubio/components/main_screen/ui/primary_button.dart';
import 'package:cubio/page/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'TIMER',
          textAlign: TextAlign.center,
        ),
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  "SCRAMBLE YOUR\nCUBE NOW...",
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              const Center(
                child: Text(
                  "SCRAMBLE THE CUBE. WHENEVER YOU ARE READY, PRESS THE CONTINUE BUTTON.\n\n AFTERWARDS, MAKE A MOVE AND YOUR TIMER WILL START AND WILL STOP AFTER YOU SOLVE THE CUBE. \n\n READY?",
                  style: regularTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              PrimaryButton(
                color: MainScreen.menuColors[1],
                text: 'CONTINUE',
                route: '/timer-playground',
                checkForSolve: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
