import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../accounts/accounts.dart';
import '../equipments/equipments.dart';
import '../members/members.dart';
import '../trainers/trainers.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  int _selectedIndex = 0;

  final screens = [
    const GymHome(),
    const GymMembers(),
    const GymTrainers(),
    const GymEquipments(),
    const GymAccounts(),
  ];

  Future<void> _confirmSignOut() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await auth.signOut();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  final TextStyle _style1 = const TextStyle(
    fontSize: 18,
    color: Colors.black,
  );
  final TextStyle _style2 = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('G Y M   M A N A G E R'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notify');
            },
            tooltip: 'Open Notifications',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            icon: const Icon(
              Icons.notifications,
            ),
          ),
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('admin')
                    .where('uid', isEqualTo: auth.currentUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          var data = snapshot.data!.docs[i];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UserAccountsDrawerHeader(
                                accountName: Text(
                                  data['owner'],
                                  style: _style1,
                                ),
                                accountEmail: Text(
                                  data['email'],
                                  style: _style1,
                                ),
                                decoration:
                                    const BoxDecoration(color: Colors.blue),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, bottom: 8),
                                child: Text(
                                  'GYM Name :',
                                  style: _style2,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, bottom: 8),
                                child: Text(
                                  data['gym'],
                                  style: _style1,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, bottom: 8),
                                child: Text(
                                  'Description :',
                                  style: _style2,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, bottom: 8),
                                child: Text(
                                  data['description'],
                                  style: _style1,
                                ),
                              ),
                            ],
                          );
                        });
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 20,
                ),
                child: ListTile(
                  title: const Text(
                    'LOGOUT',
                  ),
                  trailing: const Icon(
                    Icons.logout_rounded,
                  ),
                  onTap: () async {
                    await _confirmSignOut();
                  },
                  tileColor: Colors.blue,
                  textColor: Colors.black,
                  iconColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
            tooltip: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_rounded),
            label: 'Member',
            tooltip: 'Member',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Trainer',
            tooltip: 'Trainer',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_rounded),
            label: 'Equipment',
            tooltip: 'Equipment',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Revenue',
            tooltip: 'Revenue',
          ),
        ],
      ),
    );
  }
}
