import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final dynamic image;
  final String name;
  final String number;

  const CustomCard({
    super.key,
    this.image,
    required this.name,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 180,
      child: Card(
        color: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                image,
                width: 100,
              ),
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              number,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
