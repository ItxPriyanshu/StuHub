import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:stuhub/providers/homeProvider.dart';
import 'package:stuhub/widgets/home/today_class_card.dart';

class TodayClassesSectiton extends ConsumerWidget {
  const TodayClassesSectiton({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final todayclasses = ref.watch(todayClassesProvider);
    return todayclasses.when(
          data: (classes) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Today's Classes",
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        
                const SizedBox(height: 12),
        
                SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: classes.isEmpty
                        ? Center(
                            child: Container(
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color(0xff121212),
                                border: Border.all(width: 1,color: Colors.white12)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(height: 200,width: 200,child: Lottie.asset("assets/lotties/Loading_Paperplane.json"),),
                                  Text(
                                    "🎉 Attendance completed for today",
                                    style: GoogleFonts.manrope(color: Colors.white60),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: classes.length,
                            itemBuilder: (context, index) {
                              return TodayClassCard(todayClass: classes[index]);
                            },
                          ),
                  ),
                ),
              ],
            );
          },
        
          loading: () => const Center(child: CircularProgressIndicator()),
        
          error: (error, stackTrace) {
            return Center(
              child: Text(
                error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          },
        );
  }
}