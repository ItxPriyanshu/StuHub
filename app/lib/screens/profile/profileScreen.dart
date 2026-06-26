import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/providers/appRefreshProvider.dart';
import 'package:stuhub/providers/circularloadingProvider.dart';
import 'package:stuhub/providers/navigationProvider.dart';
import 'package:stuhub/providers/selected_subject_provider.dart';
import 'package:stuhub/providers/subjectControllersProvider.dart';
import 'package:stuhub/providers/timetableProvider.dart';

import 'package:stuhub/providers/userProfileProvider.dart';
import 'package:stuhub/repositories/backupRepository.dart';
import 'package:stuhub/repositories/logoutRepository.dart';
import 'package:stuhub/screens/auth/firstScreen.dart';
import 'package:stuhub/screens/auth/logoutDialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (e, _) => Center(
            child: Text(
              "Failed to load profile",
              style: GoogleFonts.manrope(color: Colors.white, fontSize: 16),
            ),
          ),

          data: (user) {
            if (user == null) {
              return Center(
                child: Text(
                  "No Profile Found",
                  style: GoogleFonts.manrope(color: Colors.white),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Page Title
                          Text(
                            "Profile",
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 35),

                          // Profile Avatar
                          Center(
                            child: Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.lightBlueAccent.withOpacity(.15),
                                border: Border.all(
                                  color: Colors.lightBlueAccent,
                                  width: 2,
                                ),
                              ),
                              child:
                                  user.profileImage != null &&
                                      user.profileImage!.isNotEmpty
                                  ? ClipOval(
                                      child: Image.file(
                                        File(user.profileImage!),
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) {
                                          return Center(
                                            child: Text(
                                              user.username[0].toUpperCase(),
                                              style: GoogleFonts.manrope(
                                                fontSize: 42,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.lightBlueAccent,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        user.username[0].toUpperCase(),
                                        style: GoogleFonts.manrope(
                                          fontSize: 42,
                                          color: Colors.lightBlueAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 60),

                          // Username
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white12,
                                width: 2,
                              ),
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.person_2_outlined,
                                color: Colors.lightBlueAccent,
                              ),
                              title: Text(
                                "Username",
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              subtitle: Text(
                                user.username,
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white12,
                                width: 2,
                              ),
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.person_2_outlined,
                                color: Colors.lightBlueAccent,
                              ),
                              title: Text(
                                "Username",
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              subtitle: Text(
                                user.email,
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(color: Colors.white12, height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await showLogoutDialog(context, ref);
                        if (result == null) return;

                        ref.read(circularloadingProvider.notifier).state = true;
                        try {
                          if (result) {
                            await Backuprepository().backupAll();
                          }

                          await Logoutrepository().clearLocalData();
                          ref.read(subjectControllerProvider.notifier).reset();
                          ref.read(timetableSetupProvider.notifier).clear();
                          ref.read(selectedSubjectProvider.notifier).state =
                              null;
                          ApprefreshServiceProvider.refreshAll(ref);
                          ref.read(bottomNavProvider.notifier).state = 0;

                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Firstscreen(),
                            ),
                            (_) => false,
                          );
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        } finally {
                          ref.read(circularloadingProvider.notifier).state =
                              false;
                        }
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Logout",
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withOpacity(.18),
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
