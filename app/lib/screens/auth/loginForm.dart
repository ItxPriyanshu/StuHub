import 'package:action_slider/action_slider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/models/userModel.dart';
import 'package:stuhub/repositories/authRepository.dart';
import 'package:stuhub/screens/auth/forgotPasswordScreen.dart';
import 'package:stuhub/screens/setup/setup_gate_screen.dart';

class Loginform extends StatefulWidget {
  const Loginform({super.key});

  @override
  State<Loginform> createState() => _LoginformState();
}

class _LoginformState extends State<Loginform> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
    bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            prefixIconColor: Colors.green,
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
          obscureText: obscurePassword,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            prefixIconColor: Colors.green,
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
             suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },

                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
          ),
        ),

        // SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            style: TextButton.styleFrom(overlayColor: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>ForgotPasswordScreen()));
            },
            child: Text(
              "Forgot Password",
              style: GoogleFonts.manrope(fontSize: 12, color: Colors.green),
            ),
          ),
        ),
        SizedBox(height: 10),
        ActionSlider.standard(
          rolling: true,
          backgroundColor: Colors.green,
          child: Text(
            "Slide to Login",
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          action: (controller) async {
            controller.loading();
            try {
              await Authrepository().login(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );

              controller.success();
              await Future.delayed(const Duration(seconds: 2));
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => SetupGateScreen(showRestoreOption: true),
                ),
                (route) => false,
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
              await Future.delayed(const Duration(seconds: 2));
              controller.reset();
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
                "Or login with",
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
                    message: 'This feature will be available in an upcoming update.',
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
