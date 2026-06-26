import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/providers/analyticsProvider.dart';

class SubjectHealthSection extends ConsumerWidget {
  const SubjectHealthSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(subjectHealthProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Subjects Health",
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: health.when(
            data: (subjects) {
              return Column(
                children: subjects.map((subject) {
                  final percentage = subject.attendancePercentage;

                  Color color;

                  if (percentage >= 85) {
                    color = Colors.green;
                  } else if (percentage >= 75) {
                    color = Colors.orange;
                  } else {
                    color = Colors.red;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),

                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: const Color(0xff121212),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12, width: 1),
                    ),

                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              subject.subjectName,

                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "${percentage.toStringAsFixed(1)}%",

                              style: GoogleFonts.manrope(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(20),
                          child: LinearProgressIndicator(
                            value: percentage / 100,

                            color: color,
                            borderRadius: BorderRadius.circular(20),
                            backgroundColor: Colors.white12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },

            loading: () => const Center(child: CircularProgressIndicator()),

            error: (e, _) => Text(e.toString()),
          ),
        ),
      ],
    );
  }
}
