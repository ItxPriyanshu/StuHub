import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:stuhub/models/subjectModel.dart';
import 'package:stuhub/providers/circularloadingProvider.dart';
import 'package:stuhub/providers/subjectControllersProvider.dart';
import 'package:stuhub/repositories/setupRepository.dart';
import 'package:stuhub/repositories/subjectRepository.dart';
import 'package:stuhub/screens/setup/sessionSetupScreen.dart';
import 'package:stuhub/screens/setup/setup_gate_screen.dart';
import 'package:stuhub/screens/setup/timaTableSetupScreen.dart';
import 'package:stuhub/widgets/setup/setupRestoreButton.dart';
import 'package:uuid/uuid.dart';

class SubjectSetupScreen extends ConsumerStatefulWidget {
  final bool showRestoreOption;
  const SubjectSetupScreen({super.key, this.showRestoreOption = false});

  @override
  ConsumerState<SubjectSetupScreen> createState() => _SubjectSetupScreenState();
}

class _SubjectSetupScreenState extends ConsumerState<SubjectSetupScreen> {
  //function for saving subjects
  Future<void> saveSubjects() async {
    final controllers = ref.read(subjectControllerProvider);

    final repository = Subjectrepository();

    for (final controller in controllers) {
      final subjectName = controller.text.trim();

      if (subjectName.isEmpty) continue;

      final subject = Subjectmodel(
        id: const Uuid().v4(),
        name: subjectName,
        requiredAttendance: 75,
        synced: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repository.createSubject(subject);
    }
    await Setuprepository().markSubjectsComplete();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) =>  SetupGateScreen(showRestoreOption: widget.showRestoreOption,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjectControllers = ref.watch(subjectControllerProvider);
    final isLoading = ref.watch(circularloadingProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
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
                                    "Subjects setup",
                                    style: GoogleFonts.manrope(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Add the subjects you want to track or record.",
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
          
                          // SUBJECTS LIST
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: subjectControllers.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10,
                                      sigmaY: 10,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          width: 1.5,
                                        ),
                                      ),
          
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width: 130,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blueAccent
                                                        .withAlpha(40),
                                                    border: Border.all(
                                                      color: Colors.white24,
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(16),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Subject ${(index + 1).toString().padLeft(2, '0')}",
                                                      style: GoogleFonts.manrope(
                                                        color: Colors.blueAccent,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                          subjectControllerProvider
                                                              .notifier,
                                                        )
                                                        .removeSubject(index);
                                                  },
                                                  icon: Icon(
                                                    Icons.remove,
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(
                                                  14,
                                                ),
                                              ),
                                              child: TextField(
                                                cursorColor: Colors.white,
                                                controller:
                                                    subjectControllers[index],
                                                decoration: InputDecoration(
                                                  hint: Text("eg: Mathematics"),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(14),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2))
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1.5,
                                  ),
                                ),
          
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          ref
                                              .read(
                                                subjectControllerProvider.notifier,
                                              )
                                              .addSubject();
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white24,
                                              width: 1.5,
                                            ),
                                            borderRadius: BorderRadius.circular(15),
                                            color: Colors.blueAccent.withAlpha(50),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Add Subject",
                                        style: GoogleFonts.manrope(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: saveSubjects,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "Proceed",
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
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
