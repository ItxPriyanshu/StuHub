import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stuhub/providers/appRefreshProvider.dart';
import 'package:stuhub/providers/navigationProvider.dart';
import 'package:stuhub/providers/selected_subject_provider.dart';
import 'package:stuhub/providers/subjectControllersProvider.dart';
import 'package:stuhub/providers/timetableProvider.dart';

import 'package:stuhub/repositories/sessionRepository.dart';
import 'package:stuhub/repositories/subjectRepository.dart';
import 'package:stuhub/repositories/timetableRepository.dart';
import 'package:stuhub/repositories/attendanceRepository.dart';
import 'package:stuhub/repositories/setupRepository.dart';

import 'package:stuhub/databse/database_helper.dart';

import 'package:stuhub/screens/setup/setup_gate_screen.dart';

Future<void> showResetSessionDialog(BuildContext context, WidgetRef ref) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text("Reset Session"),

        content: const Text(
          "This will permanently delete all attendance, timetable, subjects and session data. Your profile and login will remain intact.\n \n ⚠️ We recommend creating a backup before resetting your session.",
        ),

        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Reset"),
          ),
        ],
      );
    },
  );

  if (confirm != true) return;

  final attendanceRepo = Attendancerepository(DatabaseHelper.instance);

  await attendanceRepo.clearAttendance();

  await Timetablerepository().clearTimetable();

  await Subjectrepository().clearSubjects();

  await Sessionrepository().clearSession();

  await Setuprepository().resetSetup();

  ref.read(subjectControllerProvider.notifier).reset();
  ref.read(timetableSetupProvider.notifier).clear();
  ref.read(selectedSubjectProvider.notifier).state = null;
  ApprefreshServiceProvider.refreshAll(ref);
  ref.read(bottomNavProvider.notifier).state = 0;

  if (context.mounted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SetupGateScreen()),
      (route) => false,
    );
  }
}
