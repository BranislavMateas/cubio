import 'package:cubio/components/main_screen/stats/ui/line_chart.dart';
import 'package:cubio/page/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<double> savedMoves = [];
  List<double> savedTps = [];
  List<double> savedTime = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedMoves = _loadListFromPrefs(prefs, 'moveList');
      savedTps = _loadListFromPrefs(prefs, 'tpsList');
      savedTime = _loadListFromPrefs(prefs, 'timeList');
    });
  }

  List<double> _loadListFromPrefs(SharedPreferences prefs, String key) {
    List<String> rawList = prefs.getStringList(key) ?? [];
    return rawList.map(double.parse).toList();
  }

  Widget _buildChartSection(String title, List<double> data, List<Color> gradientColors, String unit) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: regularTextStyle),
          Expanded(
            child: LineChartGraph(
              spots: _generateFlSpots(data),
              gradientColors: gradientColors,
              minX: 0,
              maxX: data.isEmpty ? 0 : data.length - 1,
              minY: 0,
              maxY: _calculateMaxY(data),
              leftAxis: (double value, TitleMeta title) => _buildLeftAxisLabel(value, data),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateFlSpots(List<double> data) {
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
  }

  double _calculateMaxY(List<double> data) {
    return data.isEmpty ? 0 : (data.reduce(max) * 1.5).round().toDouble();
  }

  Widget _buildLeftAxisLabel(double value, List<double> data) {
    int valInt = value.toInt();
    String text;
    if (valInt == 0) {
      text = '0';
    } else if (valInt == (data.reduce(max) * 1.5).toInt()) {
      text = (data.reduce(max) * 1.5).toInt().toString();
    } else {
      return Container();
    }

    return Center(child: Text(text, style: regularTextStyle.copyWith(fontSize: 14), textAlign: TextAlign.left));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('STATS', textAlign: TextAlign.center),
        leading: Padding(
          padding: const EdgeInsets.all(4),
          child: IconButton(
            iconSize: 28,
            splashRadius: 28,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
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
                _buildChartSection('MOVES', savedMoves, [Colors.blue, Colors.blueAccent], ''),
                const SizedBox(height: 24),
                _buildChartSection('TPS (TURNS-PER-SECOND)', savedTps, [Colors.purple, Colors.purpleAccent], ''),
                const SizedBox(height: 24),
                _buildChartSection('TIME (SECONDS)', savedTime, [Colors.green, Colors.greenAccent], ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
