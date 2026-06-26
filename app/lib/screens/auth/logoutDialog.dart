import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

Future<bool?> showLogoutDialog(BuildContext context, WidgetRef ref) async {
  return await showDialog<bool>(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(
          "Logout",
          style: GoogleFonts.manrope(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrangeAccent,
          ),
        ),
        content: const Text(
          "Logging out will remove all local academic data from this device.\n\n"
          "We recommend backing up your latest data before logging out.",
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context, false);
            },
            child: const Text("Logout Anyway"),
          ),

          ElevatedButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: const Text("Backup & Logout"),
          ),
        ],
      );
    },
  );
}
