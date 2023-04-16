import 'package:cubio/components/main_screen/stats/ui/line_chart.dart';
import 'package:cubio/page/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<double> savedMoves = [];
  List<double> savedTps = [];
  List<double> savedTime = [];

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      // Nacitaj pohyby
      List<String> savedMovesRaw = prefs.getStringList("moveList") ?? [];
      savedMoves = savedMovesRaw.map(double.parse).toList();

      // Nacitaj TPS
      List<String> savedTpsRaw = prefs.getStringList("tpsList") ?? [];
      savedTps = savedTpsRaw.map(double.parse).toList();

      // Nacitaj čas
      List<String> savedTimeRaw = prefs.getStringList("timeList") ?? [];
      savedTime = savedTimeRaw.map(double.parse).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'STATS',
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "MOVES",
                        style: regularTextStyle,
                      ),
                      Expanded(
                        child: LineChartGraph(
                          spots:
                              savedMoves.asMap().entries.map((MapEntry entry) {
                            return FlSpot(double.parse(entry.key.toString()),
                                entry.value);
                          }).toList(),
                          gradientColors: const [
                            Colors.blue,
                            Colors.blueAccent,
                          ],
                          minX: 0,
                          maxX: savedMoves.isEmpty ? 0 : savedMoves.length - 1,
                          minY: 0,
                          maxY: savedMoves.isEmpty
                              ? 0
                              : (savedMoves.reduce(max) * 1.5)
                                  .round()
                                  .toDouble(),
                          leftAxis: (double value, TitleMeta title) {
                            String text;

                            int valInt = value.toInt();
                            if (valInt == 0) {
                              text = "0";
                            } else if (valInt ==
                                (savedMoves.reduce(max) * 1.5).toInt()) {
                              text = (savedMoves.reduce(max) * 1.5)
                                  .toInt()
                                  .toString();
                            } else {
                              return Container();
                            }

                            return Center(
                              child: Text(
                                text,
                                style: regularTextStyle.copyWith(fontSize: 14),
                                textAlign: TextAlign.left,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "TPS (TURNS-PER-SECOND)",
                        style: regularTextStyle,
                      ),
                      Expanded(
                        child: LineChartGraph(
                          spots: savedTps.asMap().entries.map((MapEntry entry) {
                            return FlSpot(double.parse(entry.key.toString()),
                                entry.value);
                          }).toList(),
                          gradientColors: const [
                            Colors.purple,
                            Colors.purpleAccent,
                          ],
                          minX: 0,
                          maxX: savedTps.isEmpty ? 0 : savedTps.length - 1,
                          minY: 0,
                          maxY: savedTps.isEmpty
                              ? 0
                              : (savedTps.reduce(max) * 1.5).round().toDouble(),
                          leftAxis: (double value, TitleMeta title) {
                            String text;

                            int valInt = value.toInt();
                            if (valInt == 0) {
                              text = "0";
                            } else if (valInt ==
                                (savedTps.reduce(max) * 1.5).toInt()) {
                              text = (savedTps.reduce(max) * 1.5)
                                  .toInt()
                                  .toString();
                            } else {
                              return Container();
                            }

                            return Center(
                                child: Text(text,
                                    style:
                                        regularTextStyle.copyWith(fontSize: 14),
                                    textAlign: TextAlign.left));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "TIME (SECONDS)",
                        style: regularTextStyle,
                      ),
                      Expanded(
                        child: LineChartGraph(
                          spots:
                              savedTime.asMap().entries.map((MapEntry entry) {
                            return FlSpot(double.parse(entry.key.toString()),
                                entry.value);
                          }).toList(),
                          gradientColors: const [
                            Colors.green,
                            Colors.greenAccent,
                          ],
                          minX: 0,
                          maxX: savedTime.isEmpty ? 0 : savedTime.length - 1,
                          minY: 0,
                          maxY: savedTime.isEmpty
                              ? 0
                              : (savedTime.reduce(max) * 1.5)
                                  .round()
                                  .toDouble(),
                          leftAxis: (double value, TitleMeta title) {
                            String text;

                            int valInt = value.toInt();
                            if (valInt == 0) {
                              text = "0";
                            } else if (valInt ==
                                (savedTime.reduce(max) * 1.5).toInt()) {
                              text = (savedTime.reduce(max) * 1.5)
                                  .toInt()
                                  .toString();
                            } else {
                              return Container();
                            }

                            return Center(
                                child: Text("$text:00",
                                    style:
                                        regularTextStyle.copyWith(fontSize: 14),
                                    textAlign: TextAlign.left));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
