import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/providers/homeHeaderProvider.dart';

class HomeHeaderSection extends ConsumerWidget {
  final String greeting;
  const HomeHeaderSection({super.key, required this.greeting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalClasses = ref.watch(totalClassesTodayProvider);
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xff121212)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          totalClasses.when(
            data: (count) {
              return Text(
                "You have $count ${count == 1 ? 'class' : 'classes'} today",
                style: GoogleFonts.manrope(
                  color: Colors.lightBlueAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              );
            },

            loading: () => const SizedBox(),

            error: (_,_) => const SizedBox(),
          ),
        ],
      ),
    );
  }
}
