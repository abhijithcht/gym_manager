import 'package:flutter/material.dart';

class GymNotification extends StatefulWidget {
  const GymNotification({Key? key}) : super(key: key);

  @override
  State<GymNotification> createState() => _GymNotificationState();
}

class _GymNotificationState extends State<GymNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N O T I F I C A T I O N'),
      ),
    );
  }
}
