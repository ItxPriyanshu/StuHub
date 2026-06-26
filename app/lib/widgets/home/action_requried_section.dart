import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stuhub/providers/actionRequiredProvider.dart';

class ActionRequriedSection extends ConsumerWidget {
  const ActionRequriedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(actionRequiredProvider);
    return action.when(
      data: (required) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: required ? Colors.orange.withAlpha(20) : Colors.green.withAlpha(20),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                        color: Colors.white12,
                        width: 1
                      )
          ),
          child: Row(
            children: [
              Icon(
                required ? Icons.warning_amber_rounded : Icons.verified,
                color: required ? Colors.orange : Colors.green,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      required ? "Action Required" : "No Action Required",
                      style: GoogleFonts.manrope(
                        color: required ? Colors.orange : Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      required
                          ? "Some subjects are below the required attendance percentage."
                          : "Your attendance is looking great. Keep it up! 🎉",
                      style: GoogleFonts.manrope(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      error: (e, _) => Text(e.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
