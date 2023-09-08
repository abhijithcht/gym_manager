// String? ownerName;
// String? gymName;
// String? description;
// String? email;
//
// @override
// void initState() {
//   super.initState();
//   setState(() {
//     fetchUserInfo();
//   });
// }
//
// void fetchUserInfo() async {
//   final currentUser = auth.currentUser;
//   if (currentUser != null) {
//     final userDoc = await FirebaseFirestore.instance
//         .collection('user')
//         .doc(currentUser.uid)
//         .collection('Profile')
//         .doc(currentUser.uid)
//         .get();
//
//     if (userDoc.exists) {
//       print('Fetched data: $userDoc');
//       setState(() {
//         ownerName = userDoc['owner'];
//         gymName = userDoc['gym'];
//         description = userDoc['description'];
//         email = userDoc['email'];
//       });
//     } else {
//       print('User document does not exist.');
//     }
//   }
// }

// ListTile(
//   leading: const Icon(Icons.logout_rounded),
//   title: Text(
//     'Logout',
//     style: _style,
//   ),
//   onTap: () async {
//     Navigator.pop(context);
//     await _confirmSignOut();
//   },
// )

// Future<void> fetchUserData() async {
//   if (FirebaseAuth.instance.currentUser != null) {
//     print(FirebaseAuth.instance.currentUser?.uid);
//   }
//   try {
//     String uid = auth.currentUser?.uid ?? "";
//     DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await db
//         .collection('admin')
//         .doc(uid)
//         .collection('Profile')
//         .doc(uid)
//         .get();
//
//     if (documentSnapshot.exists) {
//       setState(() {
//         owner = documentSnapshot.data()?['owner'];
//         gym = documentSnapshot.data()?['gym'];
//         description = documentSnapshot.data()?['description'];
//         email = documentSnapshot.data()?['email'];
//         if (kDebugMode) {
//           print(
//               "Owner: $owner, Gym: $gym, Description: $description, Email: $email");
//         }
//       });
//     }
//   } catch (e) {
//     if (kDebugMode) {
//       print("Error fetching user data: $e");
//     }
//   }
// }

// addUser(UserModel userData) async {
//   await db
//       .collection(adminCollection)
//       .doc(auth.currentUser?.uid)
//       .collection(profileCollection)
//       .add(
//     userData.toMap(),
//   );
//   if (kDebugMode) {
//     print("User data added: $userData");
//   }
// }
