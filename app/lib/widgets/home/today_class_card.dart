import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stuhub/models/attendanceModel.dart';
import 'package:stuhub/models/todayClassModel.dart';
import 'package:stuhub/providers/analyticsProvider.dart';
import 'package:stuhub/providers/attendance_Provider.dart';
import 'package:stuhub/providers/homeProvider.dart';
import 'package:uuid/uuid.dart';

class TodayClassCard extends ConsumerWidget {
  final Todayclassmodel todayClass;
  const TodayClassCard({super.key, required this.todayClass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceRepo = ref.read(AttendancerepositoryProvider);

    return Slidable(
      key: ValueKey(todayClass.subjectId),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              await attendanceRepo.markAttendance(
                attendance: Attendancemodel(
                  id: const Uuid().v4(),
                  subjectId: todayClass.subjectId,
                  date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  totalClasses: todayClass.classCount,
                  attendedClasses: 0,
                  status: "absent",
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              );
              ref.invalidate(todayClassesProvider);
              ref.invalidate(subjectHealthProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Marked Absent")));
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.close,
            label: 'Absent',
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),

        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff121212),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  todayClass.subjectName,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("<-- Swipe left to mark absent",style: TextStyle(fontSize: 12,color: Colors.grey),)
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "${todayClass.classCount} ${todayClass.classCount == 1 ? 'Class' : 'Classes'} Today",
              style: GoogleFonts.manrope(color: Colors.white70),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await attendanceRepo.markAttendance(
                        attendance: Attendancemodel(
                          id: const Uuid().v4(),
                          subjectId: todayClass.subjectId,
                          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          totalClasses: todayClass.classCount,
                          attendedClasses: todayClass.classCount,
                          status: "present",
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ),
                      );
                      ref.invalidate(todayClassesProvider);
                      ref.invalidate(subjectHealthProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Marked Presnet")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                    child: const Text(
                      "present",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await attendanceRepo.markAttendance(
                        attendance: Attendancemodel(
                          id: const Uuid().v4(),
                          subjectId: todayClass.subjectId,
                          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          totalClasses: todayClass.classCount,
                          attendedClasses: 0,
                          status: "holiday",
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ),
                      );
                      ref.invalidate(todayClassesProvider);
                      ref.invalidate(subjectHealthProvider);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Marked Holiday")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white38,
                    ),
                    child: const Text(
                      "Holiday",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
