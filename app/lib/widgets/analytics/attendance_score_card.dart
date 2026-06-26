import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:stuhub/providers/analyticsProvider.dart';

class AttendanceScoreCard extends ConsumerWidget {
  const AttendanceScoreCard({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final analytics = ref.watch(analyticsProvider);
    
    return analytics.when(data: (data){
      if(data == null){
        return const SizedBox();
      }
      final percentage = data.attendancePercentage;
      Color color;
      if (percentage >= 85) {
      color = Colors.green;
    } else if (percentage >= 75) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }


    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20,),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff121212),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("CURRENT ATTENDANCE",
           style:
                GoogleFonts.robotoMono(
              color:
                  Colors.white70,
            ),
          ),

          const SizedBox(height: 30,),

          Center(child: CircularPercentIndicator(
            radius: 90,
            lineWidth: 12,
            percent: percentage/100,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: color,
            backgroundColor: Colors.white12,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${percentage.toStringAsFixed(1)}%",
                style:
                        GoogleFonts.manrope(
                      color:
                          Colors.white,
                      fontSize:
                          34,
                      fontWeight:
                          FontWeight.bold,
                    ),
                ),

                Text("Overall Score",
                 style:
                        GoogleFonts.manrope(
                      color:
                          Colors.white60,
                    ),
                )
              ],
            ),
          ),),

          SizedBox(height: 50,),
          Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: color,foregroundColor: Colors.lightBlueAccent,
                  ),
                  SizedBox(width: 8,),

                  Text("Attended",
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),)
                ],
              ),

               Row(
                children: [
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.grey,foregroundColor: Colors.grey,
                  ),
                  SizedBox(width: 8,),
                  Text("Threshold",
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),)
                ],
              )
            ],
          ),)
        ],
      ),
    );
    }, error: (e,_)=>Text(e.toString()), loading:()=> const Center(child:CircularProgressIndicator() ,));
  }
}