import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/providers/authMode_Provider.dart';
import 'package:stuhub/screens/auth/firstScreen.dart';
import 'package:stuhub/screens/auth/loginForm.dart';
import 'package:stuhub/screens/auth/registerForm.dart';

class Loginscreen extends ConsumerStatefulWidget {
  const Loginscreen({super.key});

  @override
  ConsumerState<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends ConsumerState<Loginscreen> {
  @override
  Widget build(BuildContext context) {
    final authMode = ref.watch(authModeProvider);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.black),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //top part
              Container(
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
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Firstscreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 2),
                          ),
                          child: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      //top headings
                      Text(
                        "Go ahead and set up your account",
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Making student life simpler, smarter, and more organized.",
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
          
              //login / register form
              Expanded(
                child: Container(
                  width: double.infinity,
                  // height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //login / register slider
                        Container(
                          height: 60,
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Stack(
                                children: [
                                  AnimatedAlign(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    alignment: authMode == AuthMode.login
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: Container(
                                      width: constraints.maxWidth / 2,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                    ),
                                  ),
                              
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            ref
                                                .read(authModeProvider.notifier)
                                                .setLogin();
                                          },
                                          child: Center(
                                            child: Text(
                                              "Login",
                                              style: GoogleFonts.manrope(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: authMode == AuthMode.login
                                                    ? Colors.black
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            ref
                                                .read(authModeProvider.notifier)
                                                .setRegister();
                                          },
                                          child: Center(
                                            child: Text(
                                              "Register",
                                              style: GoogleFonts.manrope(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    authMode == AuthMode.register
                                                    ? Colors.black
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                              
                        // FORM
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 15,
                          ),
                          child: Container(
                            child: (authMode == AuthMode.login)
                                ? Loginform()
                                : Registerform(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
