import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stuhub/databse/database_helper.dart';
import 'package:stuhub/providers/appRefreshProvider.dart';
import 'package:stuhub/repositories/attendanceRepository.dart';

Future<void> showResetAttendanceDialog(BuildContext context,WidgetRef ref)async{
  final confirm = await showDialog<bool>(context: context, builder: (_){
    return AlertDialog(
        title: const Text(
          "Reset Attendance",
        ),

        content: const Text(
          "This will permanently delete all attendance records. Subjects, timetable and session will remain untouched.",
        ),

        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(
                context,
                false,
              );
            },
            child: const Text(
              "Cancel",
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white
                            ),
            onPressed: () {
              Navigator.pop(
                context,
                true,
              );
            },
            child: const Text(
              "Reset",
            ),
          ),
        ],
      );
    },
  );
  if(confirm !=true) return;
  await Attendancerepository(DatabaseHelper.instance).clearAttendance();
  ApprefreshServiceProvider.refreshAll(ref);
  if(context.mounted){
     ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Attendance reset successfully",
        ),
      ),
    );
  }
}