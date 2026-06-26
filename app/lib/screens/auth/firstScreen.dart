import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/screens/auth/loginScreen.dart';

class Firstscreen extends StatefulWidget {
  const Firstscreen({super.key});

  @override
  State<Firstscreen> createState() => _FirstscreenState();
}

class _FirstscreenState extends State<Firstscreen>
    with TickerProviderStateMixin {
  late AnimationController floatingController;
  late AnimationController ScaleController;

  late Animation<double> floatinAnimation;
  late Animation<double> ScaleAnimation;

  late double scale;

  @override
  void initState() {
    super.initState();
    floatingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    floatinAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: floatingController, curve: Curves.easeInOut),
    );
    floatingController.repeat(reverse: true);

    ScaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    ScaleController.addListener(() {
      if (ScaleController.isCompleted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return Loginscreen();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        );
            Timer(Duration(milliseconds: 500), () {
      ScaleController.reset();
    });
      }
    });
  }

  @override
  void dispose() {
    floatingController.dispose();
    ScaleController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final size = MediaQuery.of(context).size;

    final radius = sqrt(size.width * size.width + size.height * size.height);

    scale = radius / 25;
    ScaleAnimation = Tween<double>(
      begin: 1,
      end: scale,
    ).animate(ScaleController);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Center content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: floatinAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, floatinAnimation.value),
                          child: child,
                        );
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white24.withAlpha(20),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      "StuHub",
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Track. Plan. Achieve.",
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  //animation container
                  ScaleTransition(
                    scale: ScaleAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      height: 50,
                      width: 50,
                      child: Text(
                        "",
                        style: TextStyle(color: Colors.transparent),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      print("get Started clicked");
                      ScaleController.forward();
                    },
                    child: Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Get Started",
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
