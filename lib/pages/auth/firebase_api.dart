import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('Token: $fCMToken');
    }
  }

  Future<List<DocumentSnapshot>> getGymMembers() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('member').get();
      return querySnapshot.docs;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching gym members: $e');
      }
      return [];
    }
  }
}
