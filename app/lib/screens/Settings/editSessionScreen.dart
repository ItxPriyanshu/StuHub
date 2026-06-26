import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stuhub/models/sessionModel.dart';
import 'package:stuhub/providers/sessionProvider.dart';
import 'package:stuhub/repositories/sessionRepository.dart';

class EditSessionScreen extends ConsumerStatefulWidget {
  const EditSessionScreen({super.key});

  @override
  ConsumerState<EditSessionScreen> createState() => _EditSessionScreenState();
}

class _EditSessionScreenState extends ConsumerState<EditSessionScreen> {
  DateTime? startDate;
  DateTime? endDate;

  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,

        title: Text("Edit Session", style: GoogleFonts.manrope()),
      ),

      body: session.when(
        data: (data) {
          if (data == null) {
            return const Center(child: Text("No Session Found"));
          }

          if (!initialized) {
            startDate = data.startDate;
            endDate = data.endDate;
            initialized = true;
          }

          return Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    "Session Start Date",
                    style: TextStyle(color: Colors.white),
                  ),

                  subtitle: Text(
                    DateFormat("dd MMM yyyy").format(startDate!),
                    style: const TextStyle(color: Colors.white60),
                  ),

                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          backgroundColor: const Color(0xff121212),

                          title: const Text(
                            "Start Date Locked",
                            style: TextStyle(color: Colors.white),
                          ),

                          content: const Text(
                            "The session start date is locked once attendance tracking begins.\n\n"
                            "Changing it may invalidate attendance records, timetable calculations, and analytics.\n\n"
                            "If you want to begin a new semester, please use 'Reset Session' from Settings.",
                            style: TextStyle(color: Colors.white70),
                          ),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Got It",style: TextStyle(color: Colors.yellow),),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  trailing: const Icon(Icons.info_outline,color: Colors.white54,),
                ),

                const SizedBox(height: 20),

                ListTile(
                  title: const Text(
                    "Session End Date",
                    style: TextStyle(color: Colors.white),
                  ),

                  subtitle: Text(
                    DateFormat("dd MMM yyyy").format(endDate!),
                    style: const TextStyle(color: Colors.white60),
                  ),

                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,

                      firstDate: DateTime(2020),

                      lastDate: DateTime(2035),

                      initialDate: endDate!,
                    );

                    if (picked != null) {
                      setState(() {
                        endDate = picked;
                      });
                    }
                  },
                ),

                const Spacer(),

                SizedBox(
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
                      await Sessionrepository().updateSession(
                        Sessionmodel(
                          id: data.id,

                          startDate: startDate!,

                          endDate: endDate!,

                          synced: false,

                          createdAt: data.createdAt,

                          updatedAt: DateTime.now(),
                        ),
                      );

                      ref.invalidate(sessionProvider);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Session Updated")),
                        );

                        Navigator.pop(context);
                      }
                    },

                    child: const Text("Save Changes"),
                  ),
                ),
                SizedBox(height: 40,)
              ],
            ),
          );
        },

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) {
          return Center(child: Text(e.toString()));
        },
      ),
    );
  }
}
