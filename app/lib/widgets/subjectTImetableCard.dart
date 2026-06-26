import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/models/subjectModel.dart';
import 'package:stuhub/providers/timetableProvider.dart';

class SubjectTimetableCard extends ConsumerWidget {
  final Subjectmodel subject;

  const SubjectTimetableCard({
    super.key,
    required this.subject,
  });

  static const days = [
    {'id': 1, 'label': 'M'},
    {'id': 2, 'label': 'T'},
    {'id': 3, 'label': 'W'},
    {'id': 4, 'label': 'Th'},
    {'id': 5, 'label': 'F'},
    {'id': 6, 'label': 'S'},
    {'id': 7, 'label': 'Su'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timetableSetupProvider);

    final schedule = state[subject.id] ??
        {
          1: 0,
          2: 0,
          3: 0,
          4: 0,
          5: 0,
          6: 0,
          7: 0,
        };

    final totalClasses =
        schedule.values.fold(0, (sum, item) => sum + item);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: .2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subject.name,
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent.withAlpha(40),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Text(
                        "$totalClasses Classes/Week",
                        style: GoogleFonts.manrope(
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Row(
                        children: days.map((day) {
                          final dayId =
                              day["id"] as int;

                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(
                                    timetableSetupProvider
                                        .notifier,
                                  )
                                  .increment(
                                    subject.id,
                                    dayId,
                                  );
                            },
                            onLongPress: () {
                              ref
                                  .read(
                                    timetableSetupProvider
                                        .notifier,
                                  )
                                  .decrement(
                                    subject.id,
                                    dayId,
                                  );
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.all(4),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  day["label"]
                                      as String,
                                  style:
                                      GoogleFonts.manrope(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: days.map((day) {
                          final count = schedule[
                                  day["id"]
                                      as int] ??
                              0;

                          return SizedBox(
                            width: 58,
                            child: Center(
                              child: Text(
                                "x$count",
                                style:
                                    GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "Tap to increase • Long press to decrease",
                  style: GoogleFonts.manrope(
                    color: Colors.white54,
                    fontSize: 12,
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