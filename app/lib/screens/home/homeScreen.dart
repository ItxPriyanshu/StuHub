import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/providers/homeProvider.dart';
import 'package:stuhub/widgets/home/action_requried_section.dart';
import 'package:stuhub/widgets/home/home_header_section.dart';
import 'package:stuhub/widgets/home/today_classes_sectiton.dart';
import 'package:stuhub/widgets/home/subject_health_section.dart';
import 'package:stuhub/widgets/home/today_class_card.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning 👋";
    } else if (hour < 17) {
      return "Good Afternoon ☀️";
    } else {
      return "Good Evening 🌙";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeHeaderSection(greeting: greeting(),),
              const SizedBox(height: 20,),
              const TodayClassesSectiton(),

              const SizedBox(height: 30,),

              const SubjectHealthSection(),
              const SizedBox(height: 20,),
              const ActionRequriedSection(),
              const SizedBox(height: 20,),
            ],
          ),
        )
      ),
    );
  }
}
