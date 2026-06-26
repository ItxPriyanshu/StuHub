import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/providers/analyticsProvider.dart';

class StatsRow extends ConsumerWidget {
  const StatsRow({super.key});

  Widget card(String title, String value) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xff121212),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.robotoMono(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
      return Padding(padding: const EdgeInsets.symmetric(
      horizontal: 20,
    ),
    child: Row(
      children: [
        card("PRESENT", data.present.toString()),
        const SizedBox(width: 12,),
        card("ABSENT", data.absent.toString()),
        const SizedBox(width: 12,),
        card("HOLIDAY", data.holiday.toString()),
      ],
    ),
    );
    }, error: (_,_)=> const SizedBox(), loading: ()=> const SizedBox());
  }
}
