import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/models/subjectModel.dart';
import 'package:stuhub/providers/appRefreshProvider.dart';
import 'package:stuhub/providers/manageSubjectProvider.dart';
import 'package:stuhub/providers/subjectProvider.dart';
import 'package:stuhub/repositories/subjectRepository.dart';
import 'package:uuid/uuid.dart';

class Managesubjectsscreen extends ConsumerWidget {
  const Managesubjectsscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(manageSubjectProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Manage Subjects",
          style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
        ),
      ),

      body: subjects.when(
        data: (subjectList) {
          if (subjectList.isEmpty) {
            return Center(
              child: Text(
                "No Subjects Found",
                style: GoogleFonts.manrope(color: Colors.white60),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: subjectList.length,
            itemBuilder: (context, index) {
              final subject = subjectList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xff121212),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject.name,
                            style: GoogleFonts.manrope(
                              color: Colors.white,

                              fontWeight: FontWeight.bold,

                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Required Attendance: ${subject.requiredAttendance.toStringAsFixed(0)}%",
                            style: GoogleFonts.manrope(color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showEditSubjectDialog(context, ref, subject);
                      },
                      icon: Icon(Icons.edit, color: Colors.orange),
                    ),
                    IconButton(
                      onPressed: () {
                        _showDeleteSubjectDialog(context, ref, subject);
                      },
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                    ),
                  ],
                ),
              );
            },
          );
        },
        error: (e, _) {
          return Center(
            child: Text(
              e.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          _showAddSubjectDialog(context, ref);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }



//add subject method


  Future<void> _showAddSubjectDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final nameController = TextEditingController();
    final attendanceController = TextEditingController(text: "75");
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xff121221),
          title: const Text(
            "Add Subject",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                cursorColor: Colors.white,
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(label: Text("Subject Name",style:TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white,width: 2)
                )
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                cursorColor: Colors.white,
                controller: attendanceController,

                keyboardType: TextInputType.number,

                style: const TextStyle(color: Colors.white),

                decoration: const InputDecoration(
                  label: Text("Required Attendance %",style:TextStyle(color: Colors.grey),),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2))
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  return null;
                }

                final existing = await Subjectrepository().getSubjects();
                final alreadyExists = existing.any(
                  (subject) => subject.name.toLowerCase() == name.toLowerCase(),
                );

                if (alreadyExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Subejct already exists")),
                  );
                  Navigator.pop(context);
                  return;
                }
                await Subjectrepository().createSubject(
                  Subjectmodel(
                    id: const Uuid().v4(),

                    name: name,

                    requiredAttendance:
                        double.tryParse(attendanceController.text) ?? 75,

                    synced: false,

                    createdAt: DateTime.now(),

                    updatedAt: DateTime.now(),
                  ),
                );
                ref.invalidate(manageSubjectProvider);
                ApprefreshServiceProvider.refreshAll(ref);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  //edit method
  Future<void> _showEditSubjectDialog(
    BuildContext context,
    WidgetRef ref,
    Subjectmodel subject,
  ) async {
    final nameController = TextEditingController(text: subject.name);
    final attendanceController = TextEditingController(
      text: subject.requiredAttendance.toStringAsFixed(0),
    );

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xff121212),
          title: const Text(
            "Edit Subject",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                cursorColor: Colors.white,
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(label: Text("Subject Name",style:TextStyle(color: Colors.grey),),
                
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2,color: Colors.white))
                ),
              ),
              const SizedBox(height: 16),
              TextField(

                cursorColor: Colors.white,
                controller: attendanceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(label: Text("Required Attendance %",style: TextStyle(color: Colors.grey),),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2))
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white
              ),
              onPressed: () async {
                final updatedSubject = Subjectmodel(
                  id: subject.id,

                  name: nameController.text.trim(),

                  requiredAttendance:
                      double.tryParse(attendanceController.text) ?? 75,

                  synced: false,

                  createdAt: subject.createdAt,

                  updatedAt: DateTime.now(),
                );

                await Subjectrepository().updateSubject(updatedSubject);

                ref.invalidate(manageSubjectProvider);
                ApprefreshServiceProvider.refreshAll(ref);

                Navigator.pop(context);
              },

              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  //delete method

  Future<void> _showDeleteSubjectDialog(
    BuildContext context,
    WidgetRef ref,
    Subjectmodel subject,
  ) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xff121212),
          title: const Text(
            "Delete Subject",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "This will permanently delete '${subject.name}' along with all attendance records and timetable entries.",
            style: const TextStyle(color: Colors.white70),
          ),

          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
              foregroundColor: Colors.white
              ),
              onPressed: () async {
                await Subjectrepository().deleteSubject(subject.id);
                ref.invalidate(manageSubjectProvider);
                ApprefreshServiceProvider.refreshAll(ref);
                Navigator.pop(context);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${subject.name} deleted")),
                  );
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
