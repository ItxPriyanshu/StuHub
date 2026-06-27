import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:stuhub/providers/appRefreshProvider.dart';
import 'package:stuhub/providers/circularloadingProvider.dart';
import 'package:stuhub/providers/manageSubjectProvider.dart';
import 'package:stuhub/providers/sessionProvider.dart';
import 'package:stuhub/providers/subjectProvider.dart';
import 'package:stuhub/screens/NavigationScreen/mainNavigationScreen.dart';
import 'package:stuhub/screens/setup/sessionSetupScreen.dart';
import 'package:stuhub/screens/setup/setup_gate_screen.dart';
import 'package:stuhub/widgets/setup/setupRestoreButton.dart';
import 'package:stuhub/widgets/subjectTImetableCard.dart';
import 'package:stuhub/databse/database_helper.dart';
import 'package:stuhub/models/timeTableModel.dart';
import 'package:stuhub/providers/timetableProvider.dart';
import 'package:stuhub/repositories/setupRepository.dart';
import 'package:stuhub/repositories/subjectRepository.dart';
import 'package:stuhub/repositories/timetableRepository.dart';
import 'package:uuid/uuid.dart';

class TimatableSetupscreen extends ConsumerStatefulWidget {
  final bool showRestoreOption;
  const TimatableSetupscreen({super.key,this.showRestoreOption= false});

  @override
  ConsumerState<TimatableSetupscreen> createState() =>
      _TimatableSetupscreenState();
}

class _TimatableSetupscreenState extends ConsumerState<TimatableSetupscreen> {
  //debug database
  Future<void> debugDatabase() async {
    final db = await DatabaseHelper.instance.database;

    print("========== SUBJECTS ==========");

    final subjects = await db.query('subjects');

    print(subjects);

    print("========== SESSION ==========");

    final session = await db.query('session_config');

    print(session);

    print("========== TIMETABLE ==========");

    final timetable = await db.query('timetable');

    print(timetable);

    print("========== ATTENDANCE ==========");

    final attendance = await db.query('attendance');

    print(attendance);
  }

  // saving function
  Future<void> saveTimetable() async {
    final state = ref.read(timetableSetupProvider);

    final repo = Timetablerepository();

    for (final subjectEntry in state.entries) {
      final subjectId = subjectEntry.key;

      final schedule = subjectEntry.value;

      for (final dayEntry in schedule.entries) {
        if (dayEntry.value == 0) continue;

        await repo.createTimeTable(
          Timetablemodel(
            id: const Uuid().v4(),
            subjectId: subjectId,
            weekday: dayEntry.key,
            classCount: dayEntry.value,
            synced: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      }
    }

    await Setuprepository().markTimeTableComplete();
    ApprefreshServiceProvider.refreshAll(ref);
    // force rebuild important providers
ref.invalidate(sessionProvider);
ref.invalidate(subjectProvider);
ref.invalidate(manageSubjectProvider);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) =>  SetupGateScreen(showRestoreOption: widget.showRestoreOption)),
    );
  }

  @override
  Widget build(BuildContext context) {

final isLoading = ref.watch(circularloadingProvider);


    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.black),
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 40,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //top arrow
                                  Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white24,
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.arrow_downward,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Spacer(),
                                     (widget.showRestoreOption) ? RestoreBackupButton() : const SizedBox(),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  //top headings
                                  Text(
                                    "Time table setup",
                                    style: GoogleFonts.manrope(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Add the time table you want to track or record.",
                                    style: GoogleFonts.manrope(
                                      color: Colors.white,
                                      fontSize: 15,
                                      // fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
          
                          //subject wise time table
                          FutureBuilder(
                            future: Subjectrepository().getSubjects(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
          
                              final subjects = snapshot.data!;
          
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: subjects.length,
                                itemBuilder: (context, index) {
                                  final subject = subjects[index];
          
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    ref
                                        .read(timetableSetupProvider.notifier)
                                        .initializeSubject(subject.id);
                                  });
          
                                  return SubjectTimetableCard(subject: subject);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        saveTimetable();
                        debugDatabase();
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "Proceed",
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,)
                ],
              ),
            ),
          ),
           if(isLoading)
        Container(color: Colors.black54,
        child:  Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               const Text("Connecting to server...",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
               const SizedBox(height: 20,),
               SizedBox(
                height: 40,
                width: 40,
                child: Lottie.asset("assets/lotties/connectivity.json")),
            ],
          )
        ),)
        ],
      ),
    );
  }
}
