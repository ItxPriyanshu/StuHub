import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/models/timeTableModel.dart';
import 'package:stuhub/providers/appRefreshProvider.dart';
import 'package:stuhub/providers/editTimeTableProvider.dart';
import 'package:stuhub/providers/subjectProvider.dart';
import 'package:stuhub/providers/timetableProvider.dart';
import 'package:stuhub/repositories/timetableRepository.dart';
import 'package:stuhub/widgets/subjectTImetableCard.dart';
import 'package:uuid/uuid.dart';

class Edittimetablescreen extends ConsumerStatefulWidget {
  const Edittimetablescreen({super.key});

  @override
  ConsumerState<Edittimetablescreen> createState() =>
      _EdittimetablescreenState();
}

class _EdittimetablescreenState extends ConsumerState<Edittimetablescreen> {
  bool initialized = false;
  bool loaded = false;

  void preloadTimetable(WidgetRef ref, List<Timetablemodel> timetables) {
    final Map<String, Map<int, int>> timetableMap = {};

    for (final timetable in timetables) {
      timetableMap.putIfAbsent(
        timetable.subjectId,
        () => {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0},
      );

      timetableMap[timetable.subjectId]![timetable.weekday] =
          timetable.classCount;
    }

    ref.read(timetableSetupProvider.notifier).loadExisting(timetableMap);
  }

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectProvider);
    final timetable = ref.watch(allTimetableProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Edit Timetable", style: GoogleFonts.manrope()),
      ),
      body: subjects.when(
        data: (subjectsList) {
          return timetable.when(
            data: (timetables) {
              if (!loaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  preloadTimetable(ref, timetables);
                  loaded = true;
                });
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: subjectsList.length,

                      itemBuilder: (context, index) {
                        final subject = subjectsList[index];

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ref
                              .read(timetableSetupProvider.notifier)
                              .initializeSubject(subject.id);
                        });

                        return SubjectTimetableCard(subject: subject);
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),

                    child: SizedBox(
                      width: double.infinity,

                      height: 55,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.lightGreenAccent.withOpacity(.18),
                                side: const BorderSide(color: Colors.lightGreenAccent),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                        onPressed: () async {
                          final state = ref.read(timetableSetupProvider);

                          final repo = Timetablerepository();

                          await repo.clearTimetable();

                          final List<Timetablemodel> timetables = [];

                          state.forEach((subjectId, schedule) {
                            schedule.forEach((weekday, count) {
                              if (count <= 0) {
                                return;
                              }

                              timetables.add(
                                Timetablemodel(
                                  id: const Uuid().v4(),

                                  subjectId: subjectId,

                                  weekday: weekday,

                                  classCount: count,

                                  synced: false,

                                  createdAt: DateTime.now(),

                                  updatedAt: DateTime.now(),
                                ),
                              );
                            });
                          });

                          await repo.saveTimetable(timetables);

                          ApprefreshServiceProvider.refreshAll(ref);

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Timetable Updated Successfully"),
                              ),
                            );

                            Navigator.pop(context);
                          }
                        },

                        child: const Text("Save Changes"),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,)
                ],
              );
            },
            error: (e, _) {
              return Center(child: Text(e.toString()));
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
        error: (e, _) {
          return Center(child: Text(e.toString()));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
