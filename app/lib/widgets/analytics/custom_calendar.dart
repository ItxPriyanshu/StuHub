import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:stuhub/providers/calendarMonthProvider.dart';
import 'package:stuhub/providers/calendarProvider.dart';

class CustomCalendar extends ConsumerWidget {
  const CustomCalendar({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final month = ref.watch(
      calendarMonthProvider,
    );

    final calendar = ref.watch(
      calendarProvider,
    );

    return Column(
      children: [
        /// Month Header
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

          children: [
            IconButton(
              onPressed: () {
                final previous =
                    DateTime(
                  month.year,
                  month.month - 1,
                );

                ref
                    .read(
                      calendarMonthProvider
                          .notifier,
                    )
                    .state = previous;
              },
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
            ),

            Text(
              DateFormat(
                'MMMM yyyy',
              ).format(month),
              style:
                  const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            IconButton(
              onPressed: () {
                final next =
                    DateTime(
                  month.year,
                  month.month + 1,
                );

                ref
                    .read(
                      calendarMonthProvider
                          .notifier,
                    )
                    .state = next;
              },
              icon: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// Weekdays
        Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceAround,
          children: const [
            Text(
              "S",
              style: TextStyle(
                color:
                    Colors.white54,
              ),
            ),
            Text(
              "M",
              style: TextStyle(
                color:
                    Colors.white54,
              ),
            ),
            Text(
              "T",
              style: TextStyle(
                color:
                    Colors.white54,
              ),
            ),
            Text(
              "W",
              style: TextStyle(
                color:
                    Colors.white54,
              ),
            ),
            Text(
              "T",
              style: TextStyle(
                color:
                    Colors.white54,
              ),
            ),
            Text(
              "F",
              style: TextStyle(
                color:
                    Colors.white54,
              ),
            ),
            Text(
              "S",
              style: TextStyle(
                color:
                    Colors.white54,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /// Calendar Grid
        calendar.when(
          data: (days) {
            return GridView.builder(
              shrinkWrap: true,

              physics:
                  const NeverScrollableScrollPhysics(),

              itemCount:
                  days.length,

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    7,

                mainAxisSpacing:
                    8,

                crossAxisSpacing:
                    8,

                childAspectRatio:
                    1,
              ),

              itemBuilder:
                  (
                    context,
                    index,
                  ) {
                final day =
                    days[index];

                final isToday =
                    day.date.year ==
                            DateTime.now()
                                .year &&
                        day.date.month ==
                            DateTime.now()
                                .month &&
                        day.date.day ==
                            DateTime.now()
                                .day;

                Color tileColor;

                if (!day.inSession) {
                  tileColor =
                      Colors.white10;
                } else if (isToday) {
                  tileColor =
                      Colors
                          .lightBlue
                          .shade200;
                } else {
                  tileColor =
                      const Color(
                    0xff1A1A1A,
                  );
                }

                Color textColor;

                if (isToday) {
                  textColor =
                      Colors.black;
                } else if (!day.inSession) {
                  textColor =
                      Colors.white30;
                } else {
                  textColor =
                      Colors.white;
                }

                return Container(
                  decoration:
                      BoxDecoration(
                    color:
                        tileColor,

                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [
                      Text(
                        day.date.day
                            .toString(),

                        style:
                            TextStyle(
                          color:
                              textColor,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      if (day.status !=
                          null)
                        Container(
                          width: 6,
                          height: 6,

                          decoration:
                              BoxDecoration(
                            shape:
                                BoxShape.circle,

                            color: day.status ==
                                    "present"
                                ? Colors.green
                                : day.status ==
                                        "absent"
                                    ? Colors.red
                                    : Colors.blue,
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },

          loading:
              () =>
                  const Center(
                    child:
                        CircularProgressIndicator(),
                  ),

          error:
              (
                e,
                _,
              ) =>
                  Text(
                    e.toString(),
                    style:
                        const TextStyle(
                      color:
                          Colors.red,
                    ),
                  ),
        ),

        const SizedBox(height: 20),

        /// Legend
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            _legend(
              Colors.green,
              "Present",
            ),

            const SizedBox(
              width: 20,
            ),

            _legend(
              Colors.red,
              "Absent",
            ),

            const SizedBox(
              width: 20,
            ),

            _legend(
              Colors.blue,
              "Holiday",
            ),
          ],
        ),
      ],
    );
  }

  Widget _legend(
    Color color,
    String text,
  ) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,

          decoration:
              BoxDecoration(
            color: color,
            shape:
                BoxShape.circle,
          ),
        ),

        const SizedBox(
          width: 6,
        ),

        Text(
          text,
          style:
              const TextStyle(
            color:
                Colors.white70,
          ),
        ),
      ],
    );
  }
}