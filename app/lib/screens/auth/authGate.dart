import 'package:flutter/material.dart';
import 'package:stuhub/screens/NavigationScreen/mainNavigationScreen.dart';
import 'package:stuhub/screens/auth/firstScreen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
  _checkLogin();
});
  }

  Future<void> _checkLogin() async {
    try {
    final token = await TokenStorage.getToken();
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              token == null
                  ? const Firstscreen()
                  : const SetupGateScreen(),
        ),
      );
    } catch (e,s) {
      debugPrint("AuthGate Error: $e");
      debugPrintStack(stackTrace: s);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Firstscreen(),
        ),
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
