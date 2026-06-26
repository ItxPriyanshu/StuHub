import 'package:action_slider/action_slider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/repositories/authRepository.dart';
import 'package:stuhub/screens/setup/setup_gate_screen.dart';

class Registerform extends StatefulWidget {
  const Registerform({super.key});

  @override
  State<Registerform> createState() => _RegisterformState();
}

class _RegisterformState extends State<Registerform> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: usernameController,
          cursorColor: Colors.grey,

          style: GoogleFonts.manrope(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          // obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_2_outlined),
            prefixIconColor: Colors.orange,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 2, color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                width: 3,
                color: const Color.fromARGB(199, 158, 158, 158),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 2, color: Colors.grey),
            ),
            filled: true,
            fillColor: Colors.white,
            hint: Text(
              "Username",
              style: GoogleFonts.manrope(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),

        TextField(
          controller: emailController,
          cursorColor: Colors.grey,
          style: GoogleFonts.manrope(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),

          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
            prefixIconColor: Colors.orange ,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 2, color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                width: 3,
                color: const Color.fromARGB(199, 158, 158, 158),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 2, color: Colors.grey),
            ),
            filled: true,
            fillColor: Colors.white,
            hint: Text(
              "Email",
              style: GoogleFonts.manrope(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: passwordController,
          cursorColor: Colors.grey,

          style: GoogleFonts.manrope(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            prefixIconColor: Colors.orange,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 2, color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                width: 3,
                color: const Color.fromARGB(199, 158, 158, 158),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 2, color: Colors.grey),
            ),
            filled: true,
            fillColor: Colors.white,
            hint: Text(
              "Password",
              style: GoogleFonts.manrope(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: confirmPasswordController,
          cursorColor: Colors.grey,

          style: GoogleFonts.manrope(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.password),
            prefixIconColor: Colors.orange,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 2, color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                width: 3,
                color: const Color.fromARGB(199, 158, 158, 158),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 2, color: Colors.grey),
            ),
            filled: true,
            fillColor: Colors.white,
            hint: Text(
              "Confirm Password",
              style: GoogleFonts.manrope(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 60),
        ActionSlider.standard(
          backgroundColor: Colors.orange,
          child: Text(
            "Slide to Register",
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          action: (controller) async {
            if (passwordController.text.trim() ==
                confirmPasswordController.text.trim()) {
              controller.loading();

              try {
                await Authrepository().register(
                  name: usernameController.text.trim(),
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );

                controller.success();
                Future.delayed(const Duration(seconds: 3));
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (_)=>SetupGateScreen(showRestoreOption: false,)),
                  (route)=>false,
                  );
              } catch (e) {
                controller.failure();
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: AwesomeSnackbarContent(
                    title: 'Failed',
                    message: '$e',
                    contentType: ContentType.failure,
                  ),
                ),
              );
                Future.delayed(const Duration(seconds: 2));
                controller.reset();
              }
            } else {
              //scaffold messenger
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: AwesomeSnackbarContent(
                    // inMaterialBanner:true,
                    title: 'Failed',
                    message: 'Password does not match',
                    contentType: ContentType.failure,
                  ),
                ),
              );
            }
          },
        ),

        SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 2,
                color: const Color.fromARGB(216, 158, 158, 158),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Or Register with",
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                thickness: 2,
                color: const Color.fromARGB(216, 158, 158, 158),
              ),
            ),
          ],
        ),
        SizedBox(height: 30),

        Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: InkWell(
              onTap: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: AwesomeSnackbarContent(
                    title: 'Failed',
                    message: 'Oops! Something went wrong.',
                    contentType: ContentType.failure,
                  ),
                ),
              );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.google, color: Colors.black),
                  SizedBox(width: 12),
                  Text(
                    "Google",
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}
