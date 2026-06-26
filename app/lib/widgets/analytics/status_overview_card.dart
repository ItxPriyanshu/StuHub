import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/providers/analyticsProvider.dart';

class StatusOverviewCard extends ConsumerWidget {
  const StatusOverviewCard({super.key});

  Widget tile(String title, String subtitle, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white10,width: 1
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.lightBlueAccent),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(subtitle, style: GoogleFonts.manrope(color: Colors.white60)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);

    
    return analytics.when(data: (data){
      if(data == null){
        return const SizedBox();
      }
      return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff121212),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "STATUS OVERVIEW",
            style: GoogleFonts.robotoMono(color: Colors.white70),
          ),

          const SizedBox(height: 20),

          tile("${data.canMiss} Classes", "Can Miss Safely", Icons.event_available),

          const SizedBox(height: 12),
          tile("${data.needToAttend} Classes", "Need To Attend", Icons.track_changes),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color:data.attendancePercentage >=75 ?  Colors.green.withOpacity(0.15) : Colors.orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: data.attendancePercentage >=75 ? Colors.lightGreenAccent.withAlpha(50) :Colors.orangeAccent.withAlpha(50),
                width: 1
              )
            ),
            child: Text(
              data.attendancePercentage >= 75
    ? "Safe Zone: Above 75%"
    : "Warning: Below 75%",
              style: GoogleFonts.robotoMono(color: data.attendancePercentage >=75 ? Colors.greenAccent : Colors.orangeAccent),
            ),
          ),
        ],
      ),
    );
    }, error: (_,_)=> const SizedBox(), loading: ()=> const SizedBox());
  }
}
