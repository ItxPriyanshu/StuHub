import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stuhub/repositories/authRepository.dart';
import 'package:stuhub/screens/auth/resetPasswordScreen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends State<OtpVerificationScreen> {
  final Authrepository repository = Authrepository();

  final TextEditingController otpController =
      TextEditingController();

  bool isLoading = false;

  bool canResend = false;

  int secondsRemaining = 30;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    secondsRemaining = 30;
    canResend = false;

    timer?.cancel();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsRemaining == 0) {
          timer.cancel();

          if (mounted) {
            setState(() {
              canResend = true;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              secondsRemaining--;
            });
          }
        }
      },
    );
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter valid OTP"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await repository.verifyResetOtp(
        email: widget.email,
        otp: otpController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            email: widget.email,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resendOtp() async {
    try {
      await repository.sendResetOtp(
        email: widget.email,
      );

      startTimer();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP sent successfully"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 30),

            Text(
              "Enter the OTP sent to\n${widget.email}",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            PinCodeTextField(
              appContext: context,
              controller: otpController,
              length: 6,
              keyboardType: TextInputType.number,
              autoDisposeControllers: false,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow,foregroundColor: Colors.black),
                onPressed: isLoading
                    ? null
                    : verifyOtp,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Verify OTP"),
              ),
            ),

            const SizedBox(height: 20),

            canResend
                ? TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white
                  ),
                    onPressed: resendOtp,
                    child: const Text("Resend OTP"),
                  )
                : Text(
                    "Resend OTP in $secondsRemaining s",
                  ),
          ],
        ),
      ),
    );
  }
}