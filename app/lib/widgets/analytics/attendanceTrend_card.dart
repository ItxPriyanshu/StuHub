import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/providers/attendanceTrendProvider.dart';

class AttendancetrendCard extends ConsumerWidget {
  const AttendancetrendCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trend = ref.watch(AttendancetrendProvider);
    return trend.when(
      data: (points) {
        if (points.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xff121212),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Text(
                "No attendance data",
                style: TextStyle(color: Colors.white54),
              ),
            ),
          );
        }
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: const Color(0xff121212),

            borderRadius: BorderRadius.circular(24),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "ATTENDANCE TREND",
                style: GoogleFonts.robotoMono(color: Colors.white70),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 250,

                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 100,

                    gridData: FlGridData(show: true),

                    borderData: FlBorderData(show: false),

                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),

                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,

                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();

                            if (index >= points.length) {
                              return const SizedBox();
                            }
                            
                            if (index % 2 != 0) {
                              return const SizedBox();
                            }

                            return Padding(
                              padding: const EdgeInsets.only(top: 8),

                              child: Text(
                                points[index].label,

                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,

                        color: Colors.lightBlueAccent,

                        barWidth: 4,

                        dotData: FlDotData(show: true),

                        spots: List.generate(points.length, (index) {
                          return FlSpot(
                            index.toDouble(),

                            points[index].percentage,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (e, _) => Text(e.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
