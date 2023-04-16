import 'package:cubio/page/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDialogBox extends ConsumerStatefulWidget {
  final String title, descriptions, text;

  const CustomDialogBox({
    super.key,
    required this.title,
    required this.descriptions,
    required this.text,
  });

  @override
  ConsumerState<CustomDialogBox> createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends ConsumerState<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: 20, top: 45 + 20, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 42.5),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: primaryAppColor,
              border: Border.all(
                color: Colors.green,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.descriptions,
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                            animationDuration: const Duration(seconds: 10),
                            overlayColor: MaterialStateProperty.resolveWith(
                              (states) {
                                return states.contains(MaterialState.pressed)
                                    ? Colors.blue.withOpacity(0.25)
                                    : null;
                              },
                            ),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.transparent),
                            shape: MaterialStateProperty.resolveWith(
                              (states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                side: const BorderSide(
                                  color: Colors.blue,
                                  width: 2.5,
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.text,
                              style: const TextStyle(fontSize: 18),
                            ),
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 85, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                ),
              ),
              const Center(
                child: Icon(
                  Icons.check_circle,
                  size: 85,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
