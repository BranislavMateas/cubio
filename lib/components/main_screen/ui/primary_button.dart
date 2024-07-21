import 'package:cubio/components/main_screen/timer/provider/moves_provider.dart';
import 'package:cubio/components/main_screen/timer/provider/stopwatch_provider.dart';
import 'package:cubio/page/constants.dart';
import 'package:cubio/provider/cube_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrimaryButton extends ConsumerStatefulWidget {
  final Color color;
  final String text;
  final String route;
  final bool checkForSolve;

  const PrimaryButton({
    super.key,
    required this.route,
    required this.color,
    required this.text,
    required this.checkForSolve,
  });

  @override
  ConsumerState<PrimaryButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends ConsumerState<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        animationDuration: const Duration(seconds: 10),
        overlayColor: WidgetStateProperty.resolveWith(
              (states) {
            return states.contains(WidgetState.pressed)
                ? widget.color.withOpacity(0.25)
                : null;
          },
        ),
        backgroundColor:
        WidgetStateProperty.resolveWith((states) => Colors.transparent),
        shape: WidgetStateProperty.resolveWith(
              (states) =>
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
                side: BorderSide(
                  color: widget.color,
                  width: 2.5,
                ),
              ),
        ),
      ),
      onPressed: () async {
        if (widget.route == '/timer-playground') {
          ref
              .read(movesProvider.notifier)
              .state = 0;
          ref.read(stopwatchProvider.notifier).stopStopwatch();
          ref.read(stopwatchProvider.notifier).resetStopwatch();
        }

        if (ref
            .read(cubeDataProvider.notifier)
            .isSolved &&
            widget.checkForSolve) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor: primaryAppColor,
              content: const Text(
                "MIX YOUR CUBE AT FIRST!",
                style: alertTextStyle,
                textAlign: TextAlign.center,
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(
                  color: widget.color,
                  width: 2,
                ),
              ),
            ),
          );
        } else {
          if (!mounted) return;
          Navigator.pushNamed(context, widget.route);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          widget.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
