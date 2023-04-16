import 'package:cubio/components/bluetooth_list/bluetooth_list.dart';
import 'package:cubio/components/main_screen/connected_device/connected_device.dart';
import 'package:cubio/components/main_screen/main_screen.dart';
import 'package:cubio/components/main_screen/solver/solver_screen.dart';
import 'package:cubio/components/main_screen/stats/stats_screen.dart';
import 'package:cubio/components/main_screen/timer/timer_screen.dart';
import 'package:cubio/components/main_screen/timer/ui/timer_playground.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => const BluetoothList(),
  '/menu': (context) => const MainScreen(),
  '/connected': (context) => const ConnectedDevice(),
  '/solver': (context) => const SolverScreen(),
  '/timer': (context) => const TimerScreen(),
  '/timer-playground': (context) => const TimerPlayground(),
  '/stats': (context) => const StatsScreen(),
};
