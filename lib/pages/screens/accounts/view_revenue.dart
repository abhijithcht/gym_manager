import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../utilities/custom_slidable.dart';

class ViewRevenue extends StatefulWidget {
  const ViewRevenue({Key? key}) : super(key: key);

  @override
  State<ViewRevenue> createState() => _ViewRevenueState();
}

class _ViewRevenueState extends State<ViewRevenue> {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('income');
  final CollectionReference _reference2 =
      FirebaseFirestore.instance.collection('member');

  Future<void> delete(String id) async {
    await _reference.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('R E V E N U E'),
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
                text: 'Member Fee',
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
              },
            ),
            StreamBuilder(
              stream: _reference2.snapshots(),
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
                            '${documentSnapshot['name']}\'s Fee',
                          ),
                          subtitle: Text(
                            documentSnapshot['phone'].toString(),
                          ),
                          leading: Text(
                            DateFormat('yyyy-MM-dd')
                                .format(documentSnapshot['date'].toDate()),
                          ),
                          trailing: Text(
                            '\$${documentSnapshot['fees'].toString()}',
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
