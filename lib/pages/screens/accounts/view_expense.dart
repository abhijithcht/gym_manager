import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../utilities/custom_slidable.dart';

class ViewExpenses extends StatefulWidget {
  const ViewExpenses({Key? key}) : super(key: key);

  @override
  State<ViewExpenses> createState() => _ViewExpensesState();
}

class _ViewExpensesState extends State<ViewExpenses> {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('expense');
  final CollectionReference _reference2 =
      FirebaseFirestore.instance.collection('trainer');
  final CollectionReference _reference3 =
      FirebaseFirestore.instance.collection('equipment');

  Future<void> delete(String id) async {
    await _reference.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('E X P E N S E S'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.attach_money_rounded,
                ),
                text: 'Manual',
              ),
              Tab(
                icon: Icon(
                  Icons.person_rounded,
                ),
                text: 'Trainer Salary',
              ),
              Tab(
                icon: Icon(
                  Icons.fitness_center_rounded,
                ),
                text: 'Equipment',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
                stream: _reference.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasError) {
                    return const Text('Some error has occurred');
                  }
                  if (streamSnapshot.hasData &&
                      streamSnapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                        itemCount: streamSnapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          return Slidable(
                            startActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                CustomSlidable(
                                  onPressed: (context) async {
                                    await delete(documentSnapshot.id);
                                  },
                                )
                              ],
                            ),
                            child: Card(
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                title: Text(
                                  documentSnapshot['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                trailing: Text(
                                  '\$${documentSnapshot['amount'].toString()}',
                                ),
                                leading: Text(
                                  DateFormat('yyyy-MM-dd').format(
                                    documentSnapshot['date'].toDate(),
                                  ),
                                ),
                                onTap: () {},
                              ),
                            ),
                          );
                        });
                  } else if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return const Center(
                      child: Text('No data available.'),
                    );
                  }
                }),
            StreamBuilder(
              stream: _reference2.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasError) {
                  return const Text('Some Error has occurred');
                }
                if (streamSnapshot.hasData &&
                    streamSnapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: streamSnapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            '${documentSnapshot['name']}\'s Salary',
                          ),
                          subtitle: Text(
                            documentSnapshot['phone'].toString(),
                          ),
                          trailing: Text(
                            '\$${documentSnapshot['salary'].toString()}',
                          ),
                          leading: Text(
                            DateFormat('yyyy-MM-dd')
                                .format(documentSnapshot['date'].toDate()),
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  );
                } else if (streamSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const Center(
                    child: Text('No data available.'),
                  );
                }
              },
            ),
            StreamBuilder(
              stream: _reference3.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasError) {
                  return const Text('Some Error has occurred.');
                }
                if (streamSnapshot.hasData &&
                    streamSnapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: streamSnapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            documentSnapshot['name'],
                          ),
                          subtitle: Text(
                            '${documentSnapshot['quantity'].toString()} qty',
                          ),
                          trailing: Text(
                            '\$${documentSnapshot['amount'].toString()}',
                          ),
                          leading: Text(
                            DateFormat('yyyy-MM-dd')
                                .format(documentSnapshot['date'].toDate()),
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  );
                } else if (streamSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const Center(
                    child: Text('No data available.'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
