import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({Key? key, required String message})
      : super(
          key: key,
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
          duration: const Duration(seconds: 3),
          dismissDirection: DismissDirection.horizontal,
        );
}
