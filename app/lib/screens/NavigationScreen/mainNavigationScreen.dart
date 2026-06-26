import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stuhub/providers/navigationProvider.dart';
import 'package:stuhub/screens/Settings/settingScreen.dart';
import 'package:stuhub/screens/analytic/analyticScreen.dart';
import 'package:stuhub/screens/home/homeScreen.dart';
import 'package:stuhub/screens/profile/profileScreen.dart';

class Mainnavigationscreen extends ConsumerWidget {
  const Mainnavigationscreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final index = ref.watch(bottomNavProvider);
    final screens = [
      const Homescreen(),
      const Analyticscreen(),
      const Settingscreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value){
          ref.read(bottomNavProvider.notifier).state = value;
        },
        backgroundColor: const Color(0xff121212),
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,

        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics),label: "Analytics"),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile")
        ]),
    );
  }
}