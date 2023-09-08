import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utilities/custom_button.dart';
import '../../utilities/custom_snack.dart';
import '../../utilities/custom_textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final String adminCollection = 'admin';

  final TextEditingController loginEmail = TextEditingController();
  final TextEditingController loginPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController gymNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Constants for snackbar messages
  final String passwordMismatchError = 'Passwords do not match.';
  final String weakPasswordError = 'Weak password.';
  final String emailInUseError = 'The account already exists for that email.';
  final String registrationError = 'Error during registration: ';
  final String userRegistered = 'User is Registered';

  // Show SnackBar with a given message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: message,
      ),
    );
  }

  Future<void> signup() async {
    if (loginPassword.text != confirmPassword.text) {
      _showSnackBar(passwordMismatchError);
      return;
    }

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: loginEmail.text,
        password: loginPassword.text,
      )
          .then((value) {
        _showSnackBar(userRegistered);
        db.collection(adminCollection).add({
          'owner': ownerNameController.text,
          'gym': gymNameController.text,
          'description': descriptionController.text,
          'email': loginEmail.text,
          'uid': auth.currentUser!.uid
        });
      });
      _clearTextFields();

      if (!mounted) return;
      await Navigator.pushNamed(context, '/homepage');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showSnackBar(weakPasswordError);
      } else if (e.code == 'email-already-in-use') {
        _showSnackBar(emailInUseError);
      } else {
        _showSnackBar(registrationError + e.toString());
      }
    } catch (e) {
      _showSnackBar(registrationError + e.toString());
    }
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill the field.';
    }
    return null;
  }

  // Clear text fields
  void _clearTextFields() {
    loginEmail.clear();
    loginPassword.clear();
    confirmPassword.clear();
    ownerNameController.clear();
    gymNameController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextInputField(
              controller: ownerNameController,
              validator: _validateInput,
              hintText: 'Owner Name',
              prefixIcon: Icons.person,
              keyboardType: TextInputType.name,
            ),
            CustomTextInputField(
              controller: gymNameController,
              validator: _validateInput,
              hintText: 'Gym Name',
              prefixIcon: Icons.fitness_center_rounded,
            ),
            CustomTextInputField(
              controller: descriptionController,
              validator: _validateInput,
              hintText: 'Description',
              prefixIcon: Icons.description_rounded,
              inputFormatters: [
                LengthLimitingTextInputFormatter(200),
              ],
            ),
            CustomTextInputField(
              controller: loginEmail,
              validator: _validateInput,
              hintText: 'Email',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
            ),
            CustomTextInputField(
              controller: loginPassword,
              validator: _validateInput,
              hintText: 'Password',
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
            CustomTextInputField(
              controller: confirmPassword,
              validator: _validateInput,
              hintText: 'Confirm Password',
              prefixIcon: Icons.lock,
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              text: 'Sign Up',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  signup();
                }
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already a Member?',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signin');
                  },
                  child: const Text(
                    'Login Now',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
