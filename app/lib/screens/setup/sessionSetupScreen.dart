import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/models/sessionModel.dart';
import 'package:stuhub/repositories/sessionRepository.dart';
import 'package:stuhub/repositories/setupRepository.dart';
import 'package:stuhub/screens/setup/setup_gate_screen.dart';
import 'package:stuhub/screens/setup/subjectsSetupScreen.dart';
import 'package:stuhub/widgets/setup/setupRestoreButton.dart';
import 'package:uuid/uuid.dart';

class SessionSetupScreen extends ConsumerStatefulWidget {
  final bool showRestoreOption;
  const SessionSetupScreen({super.key, this.showRestoreOption = false});

  @override
  ConsumerState<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends ConsumerState<SessionSetupScreen> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final Sessionrepository sessionrepository = Sessionrepository();

  final Setuprepository setuprepository = Setuprepository();

  //save function
  Future<void> saveSession() async {
    if (startDateController.text.isEmpty || endDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "Missing details",
            message: "Please select both dates",
            contentType: ContentType.warning,
          ),
        ),
      );
      return;
    }

    try {
      final startParts = startDateController.text.split('/');

      final endParts = endDateController.text.split('/');

      final startDate = DateTime(
        int.parse(startParts[2]),
        int.parse(startParts[1]),
        int.parse(startParts[0]),
      );
      final endDate = DateTime(
        int.parse(endParts[2]),
        int.parse(endParts[1]),
        int.parse(endParts[0]),
      );

      if (endDate.isBefore(startDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Wrong input',
              message: "End date cannot be before start date",
              contentType: ContentType.warning,
            ),
          ),
        );
        return;
      }

      final session = Sessionmodel(
        id: const Uuid().v4(),
        startDate: startDate,
        endDate: endDate,
        synced: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await sessionrepository.createSession(session);

      await setuprepository.markSessionComplete();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SetupGateScreen(showRestoreOption: widget.showRestoreOption,)),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'error',
            message: '$err',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

  Future<void> selectStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),

       builder: (context, child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.lightGreenAccent, // Selected date & header
          onPrimary: Colors.black,          // Header text
          surface: Color(0xFF1E1E1E),       // Dialog background
          onSurface: Colors.white,          // Calendar text
        ),
      ),

      child: child!,
    );
  },
    );

    if (pickedDate != null) {
      startDateController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  Future<void> selectEndDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),

             builder: (context, child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.lightGreenAccent, // Selected date & header
          onPrimary: Colors.black,          // Header text
          surface: Color(0xFF1E1E1E),       // Dialog background
          onSurface: Colors.white,          // Calendar text
        ),
      ),

      child: child!,
    );
  }
    );

    if (pickedDate != null) {
      endDateController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.black),

        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
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
                               (widget.showRestoreOption) ? RestoreBackupButton() :const SizedBox(),
                              ],
                            ),
                            SizedBox(height: 20),
                            //top headings
                            Text(
                              "Session setup",
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Create a session and start marking attendance.",
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

                    //START DATE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Start",
                                  style: GoogleFonts.manrope(
                                    color: Colors.redAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: TextField(
                                    cursorColor: Colors.white,
                                    onTap: selectStartDate,
                                    readOnly: true,
                                    controller: startDateController,
                                    decoration: InputDecoration(
                                      label: Text("Select Date",style: TextStyle(color: Colors.grey)),
                                      suffixIcon: Icon(
                                        Icons.calendar_month,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
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

                    SizedBox(height: 30),

                    //END DATE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "End",
                                  style: GoogleFonts.manrope(
                                    color: Colors.redAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: TextField(
                                    cursorColor: Colors.white,
                                    onTap: selectEndDate,
                                    readOnly: true,
                                    controller: endDateController,
                                    decoration: InputDecoration(
                                      label: const Text("Select Date",style: TextStyle(color: Colors.grey),),
                                      suffixIcon: Icon(
                                        Icons.calendar_month,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
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
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: saveSession,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
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
    );
  }
}
