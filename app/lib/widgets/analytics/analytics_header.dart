import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalyticsHeader extends StatelessWidget {
  const AnalyticsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Analytics",
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white10,
            child: Icon(Icons.analytics,color: Colors.white,),
          )
        ],
      ),
    );
  }
}
