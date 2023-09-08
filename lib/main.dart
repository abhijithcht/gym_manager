import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'pages/auth/firebase_api.dart';
import 'pages/auth/signin.dart';
import 'pages/auth/signup.dart';
import 'pages/screens/accounts/accounts.dart';
import 'pages/screens/accounts/add_expense.dart';
import 'pages/screens/accounts/add_revenue.dart';
import 'pages/screens/accounts/view_expense.dart';
import 'pages/screens/accounts/view_revenue.dart';
import 'pages/screens/equipments/add_equipment.dart';
import 'pages/screens/equipments/equipments.dart';
import 'pages/screens/home/main_page.dart';
import 'pages/screens/members/add_member.dart';
import 'pages/screens/members/members.dart';
import 'pages/screens/notification/notification.dart';
import 'pages/screens/trainers/add_trainer.dart';
import 'pages/screens/trainers/trainers.dart';
import 'utilities/page_transition.dart';

void main() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();
  await Firebase.initializeApp();

  // Initialize FirebaseApi
  final FirebaseApi firebaseApi = FirebaseApi();

  // Initialize notifications
  await firebaseApi.initNotifications();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'gym_members_channel',
    'Gym Members Notifications',
    importance: Importance.high,
    description: 'Notifications for Gym Members',
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/gym_manager'),
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  DateTime registrationDate = DateTime(2023, 9, 7);

  tz.TZDateTime scheduledDate = tz.TZDateTime(
    tz.getLocation('Asia/Kolkata'),
    registrationDate.year,
    registrationDate.month,
    registrationDate.day,
  ).add(const Duration(days: 30));

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Membership Renewal Reminder',
    'Your gym membership needs to be renewed!',
    scheduledDate, // Scheduled date
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'gym_members_channel', // Same as the channel ID
        'Gym Members Notifications',
        channelDescription: 'Notifications for Gym Members',
        importance: Importance.high,
      ),
    ),
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        duration: 500,
        splash: Icons.android,
        splashIconSize: 160,
        nextScreen: const MyApp(),
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: Colors.blue,
      ),
    ),
  );
  // Retrieve gym members' data and schedule notifications
  final List<DocumentSnapshot> gymMembers = await FirebaseApi()
      .getGymMembers(); // Update this to match your Firebase data retrieval logic
  scheduleNotifications(gymMembers, flutterLocalNotificationsPlugin);
}

// Schedule notifications based on gym members' registration dates
void scheduleNotifications(List<DocumentSnapshot> gymMembers,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  for (final member in gymMembers) {
    final Timestamp timestamp = member['date'];
    final DateTime registrationDate = timestamp.toDate();
    final timeDifference = registrationDate.difference(DateTime.now());

    if (timeDifference.inDays >= 30) {
      final tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.getLocation('Asia/Kolkata'),
        registrationDate.year,
        registrationDate.month,
        registrationDate.day,
      ).add(const Duration(days: 30));

      flutterLocalNotificationsPlugin.zonedSchedule(
        member.id.hashCode, // Use a unique ID for each member
        'Membership Renewal Reminder',
        'Your gym membership needs to be renewed!',
        scheduledDate, // Scheduled date
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'gym_members_channel', // Same as the channel ID
            'Gym Members Notifications',
            channelDescription: 'Notifications for Gym Members',
            importance: Importance.high,
          ),
        ),
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigoAccent,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        scaffoldBackgroundColor: Colors.white,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.blue,
          iconSize: 40,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.grey[200],
        ),
        tabBarTheme: TabBarTheme(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        primaryColor: Colors.indigoAccent,
        cardTheme: CardTheme(
          color: Colors.blue[100],
        ),
        listTileTheme: const ListTileThemeData(
          horizontalTitleGap: 40,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          subtitleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          leadingAndTrailingTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.blue,
          backgroundColor: Colors.grey[200],
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainPage();
          } else {
            return const SignInPage();
          }
        },
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/homepage':
            return buildPageTransition(const MainPage());
          case '/signup':
            return buildPageTransition(const SignUpPage());
          case '/signin':
            return buildPageTransition(const SignInPage());
          case '/member':
            return buildPageTransition(const GymMembers());
          case '/trainer':
            return buildPageTransition(const GymTrainers());
          case '/equipment':
            return buildPageTransition(const GymEquipments());
          case '/account':
            return buildPageTransition(const GymAccounts());
          case '/newMember':
            return buildPageTransition(const AddMember());
          case '/newTrainer':
            return buildPageTransition(const AddTrainer());
          case '/newEquipment':
            return buildPageTransition(const AddEquipment());
          case '/addExpense':
            return buildPageTransition(const AddExpenses());
          case '/addRevenue':
            return buildPageTransition(const AddRevenue());
          case '/expense':
            return buildPageTransition(const ViewExpenses());
          case '/revenue':
            return buildPageTransition(const ViewRevenue());
          case '/notify':
            return buildPageTransition(const GymNotification());
          default:
            return null;
        }
      },
    );
  }
}
