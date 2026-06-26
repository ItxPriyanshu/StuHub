import 'package:flutter/material.dart';
import 'package:stuhub/repositories/setupRepository.dart';
import 'package:stuhub/screens/NavigationScreen/mainNavigationScreen.dart';
import 'package:stuhub/screens/auth/firstScreen.dart';
import 'package:stuhub/screens/home/homeScreen.dart';
import 'package:stuhub/screens/setup/sessionSetupScreen.dart';
import 'package:stuhub/screens/setup/setup_gate_screen.dart';
import 'package:stuhub/storage/token_storage.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final token = await TokenStorage.getToken();
    if (!mounted) return;
    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Firstscreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SetupGateScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(color: Colors.lightGreenAccent),
      ),
    );
  }
}
