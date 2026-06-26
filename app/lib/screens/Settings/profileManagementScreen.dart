import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stuhub/providers/userProfileProvider.dart';

class ProfileManagementScreen extends ConsumerStatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  ConsumerState<ProfileManagementScreen> createState() =>
      _ProfileManagementScreenState();
}

class _ProfileManagementScreenState
    extends ConsumerState<ProfileManagementScreen> {
  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    await ref
        .read(userProfilereRepositoryProvider)
        .updateProfilePhoto(image.path);
    ref.invalidate(userProfileProvider);
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,

        title: Text("Profile", style: GoogleFonts.manrope()),
      ),

      body: profile.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text("No Profile Found"));
          }

          usernameController.text = user.username;

          emailController.text = user.email;

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                  
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                  
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white12,
                          backgroundImage: user.profileImage != null
                              ? FileImage(File(user.profileImage!))
                              : null,
                  
                          child: user.profileImage == null
                              ? const Icon(Icons.person, size: 60, color: Colors.white)
                              : null,
                        ),
                  
                        const SizedBox(height: 16),
                  
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.lightBlueAccent,
                          ),
                          onPressed: pickImage,
                          child: const Text("Change Photo"),
                        ),
                  
                        const SizedBox(height: 30),
                  
                        TextField(
                          cursorColor: Colors.white,
                          controller: usernameController,
                          decoration: InputDecoration(
                            label: Text(
                              "Username",
                              style: TextStyle(color: Colors.grey),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                  
                        const SizedBox(height: 20),
                  
                        TextField(
                          controller: emailController,
                          cursorColor: Colors.white,
                  
                          decoration: InputDecoration(
                            label: Text("Email", style: TextStyle(color: Colors.grey)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                 const SizedBox(height: 40),
                  
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                                            
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
                                try {
                                  await ref
                                      .read(userProfilereRepositoryProvider)
                                      .updateProfile(
                                        username: usernameController.text.trim(),
                                            
                                        email: emailController.text.trim(),
                                      );
                                            
                                  ref.invalidate(userProfileProvider);
                                            
                                  if (!mounted) return;
                                            
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Profile Updated")),
                                  );
                                } catch (e) {
                                  if (!mounted) return;
                                            
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                                }
                              },
                                            
                              child: const Text("Save"),
                            ),
                          ),
                        ),
                        SizedBox(height: 40,),
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
