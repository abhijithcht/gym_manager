import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utilities/custom_button.dart';
import '../../utilities/custom_snack.dart';
import '../../utilities/custom_textfield.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  final TextEditingController loginEmail = TextEditingController();
  final TextEditingController loginPassword = TextEditingController();

  // constants for snackbar messages
  final String signInError = 'Sign-in failed. Please try again.';
  final String noUserError = 'No user found for that email.';
  final String wrongPasswordError = 'Wrong password provided for that user.';
  final String exeptionError = 'Sign-in error: ';
  final String otherError =
      'An error occurred during sign-in. Please try again.';
  final String emptyError = 'Please fill in all fields.';

  Future<void> signin() async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: loginEmail.text,
        password: loginPassword.text,
      );

      if (userCredential.user != null) {
        if (!mounted) return;
        await Navigator.pushNamed(context, '/homepage');
      } else {
        _showSnackBar(signInError);
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          _showSnackBar(noUserError);
        } else if (e.code == 'wrong-password') {
          _showSnackBar(wrongPasswordError);
        } else {
          _showSnackBar(exeptionError + e.toString());
        }
      } else {
        _showSnackBar(otherError + e.toString());
      }
      _showSnackBar(signInError);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: message,
      ),
    );
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill the field.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextInputField(
                controller: loginEmail,
                hintText: 'Email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: _validateInput,
                textCapitalization: TextCapitalization.none,
              ),
              CustomTextInputField(
                controller: loginPassword,
                hintText: 'Password',
                prefixIcon: Icons.lock,
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: _validateInput,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                text: 'Sign In',
                onPressed: () async {
                  if (loginEmail.text.isEmpty || loginPassword.text.isEmpty) {
                    _showSnackBar(emptyError);
                  } else {
                    await signin();
                  }
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a Member?',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      'Register Now',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
