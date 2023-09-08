import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../utilities/custom_card.dart';

class GymHome extends StatefulWidget {
  const GymHome({
    Key? key,
  }) : super(key: key);

  @override
  State<GymHome> createState() => _GymHomeState();
}

class _GymHomeState extends State<GymHome> {
  int trainersCount = 0;
  int membersCount = 0;
  int equipmentCount = 0;
  int totalQuantity = 0;
  int totalPurchase = 0;
  int totalSalary = 0;
  int totalFee = 0;
  int totalManualIncome = 0;
  int totalManualExpense = 0;
  int totalIncome = 0;
  int totalExpense = 0;

  @override
  void initState() {
    super.initState();
    fetchTrainersCount();
    fetchMembersCount();
    fetchEquipmentCount();
    calculateTotalQuantity().then((value) {
      setState(() {
        totalQuantity = value;
      });
    });
    calculateTotalPurchase().then((value) {
      setState(() {
        totalPurchase = value;
        calculateTotalExpense();
      });
    });
    calculateTotalSalary().then((value) {
      setState(() {
        totalSalary = value;
        calculateTotalExpense();
      });
    });
    calculateTotalFee().then((value) {
      setState(() {
        totalFee = value;
        calculateTotalIncome();
      });
    });
    calculateTotalManualIncome().then((value) {
      setState(() {
        totalManualIncome = value;
        calculateTotalIncome();
      });
    });
    calculateTotalManualExpense().then((value) {
      setState(() {
        totalManualExpense = value;
        calculateTotalExpense();
      });
    });
  }

  Future<void> fetchTrainersCount() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('trainer').get();
      trainersCount = querySnapshot.size;
      setState(() {});
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching trainers count: $error');
      }
    }
  }

  Future<void> fetchMembersCount() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('member').get();
      membersCount = querySnapshot.size;
      setState(() {});
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching members count: $error');
      }
    }
  }

  Future<void> fetchEquipmentCount() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('equipment').get();
      equipmentCount = querySnapshot.size;
      setState(() {});
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching equipment count: $error');
      }
    }
  }

  Future<int> calculateTotalQuantity() async {
    int totalQuantity = 0;
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('equipment').get();
      for (var doc in querySnapshot.docs) {
        final equipmentData = doc.data() as Map<String, dynamic>;
        final quantity = equipmentData['quantity'] as int? ?? 0;
        totalQuantity += quantity;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error calculating total quantity: $error');
      }
    }
    return totalQuantity;
  }

  Future<int> calculateTotalPurchase() async {
    int totalPurchase = 0;
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('equipment').get();
      for (var doc in querySnapshot.docs) {
        final equipmentData = doc.data() as Map<String, dynamic>;
        final amount = equipmentData['amount'] as int? ?? 0;
        totalPurchase += amount;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error calculating total amount: $error');
      }
    }
    return totalPurchase;
  }

  Future<int> calculateTotalSalary() async {
    int totalSalary = 0;
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('trainer').get();
      for (var doc in querySnapshot.docs) {
        final trainerData = doc.data() as Map<String, dynamic>;
        final salary = trainerData['salary'] as int? ?? 0;
        totalSalary += salary;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error calculating total salary: $error');
      }
    }
    return totalSalary;
  }

  Future<int> calculateTotalFee() async {
    int totalFee = 0;
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('member').get();
      for (var doc in querySnapshot.docs) {
        final memberData = doc.data() as Map<String, dynamic>;
        final fees = memberData['fees'] as int? ?? 0;
        totalFee += fees;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error calculating total fees: $error');
      }
    }
    return totalFee;
  }

  Future<int> calculateTotalManualIncome() async {
    int totalManualIncome = 0;
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('income').get();
      for (var doc in querySnapshot.docs) {
        final incomeData = doc.data() as Map<String, dynamic>;
        final manualIncome = incomeData['amount'] as int? ?? 0;
        totalManualIncome += manualIncome;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error calculating total manual income: $error');
      }
    }
    return totalManualIncome;
  }

  Future<int> calculateTotalManualExpense() async {
    int totalManualExpense = 0;
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('expense').get();
      for (var doc in querySnapshot.docs) {
        final expenseData = doc.data() as Map<String, dynamic>;
        final manualExpense = expenseData['amount'] as int? ?? 0;
        totalManualExpense += manualExpense;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error calculating total manual expense: $error');
      }
    }
    return totalManualExpense;
  }

  Future<int> calculateTotalIncome() async {
    try {
      totalIncome = totalManualIncome + totalFee;
      setState(() {});
    } catch (error) {
      if (kDebugMode) {
        print('Error calculating total income: $error');
      }
    }
    return totalIncome;
  }

  Future<int> calculateTotalExpense() async {
    try {
      totalExpense = totalManualExpense + totalSalary + totalPurchase;
      setState(() {});
    } catch (error) {
      if (kDebugMode) {
        print('Error calculating total income: $error');
      }
    }
    return totalExpense;
  }

  final String revenue =
      'Revenue is the total sum of members monthly fees and manually added revenue from accounts tab. In simple terms it is the income of the GYM.';
  final String expense =
      'Expense is the total sum of trainers monthly salaries, equipment purchase cost and manually added expense from accounts tab. In simple terms it is the expense of the GYM.';
  final String trainer =
      'A gym trainer is a fitness professional who guides individuals in achieving their health and fitness goals through personalized exercise routines and expert guidance.';
  final String member =
      'A gym member is an individual who has paid for a membership or access to a fitness facility to use its equipment and services for a specified period.';
  final String equipment =
      'Gym equipment refers to the various machines, weights, and tools used for exercise and strength training in a fitness facility. It is calculated based on quantity from equipment tab.';

  Widget buildCustomCard(String title, String number, String imageAsset,
      String description, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            );
          },
        );
      },
      child: CustomCard(
        name: title,
        number: number,
        image: imageAsset,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 30,
            ),
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                buildCustomCard('REVENUE', '$totalIncome',
                    'assets/images/up.png', revenue, context),
                buildCustomCard('EXPENSES', '$totalExpense',
                    'assets/images/down.png', expense, context),
                buildCustomCard('TRAINERS', '$trainersCount',
                    'assets/images/trainer.png', trainer, context),
                buildCustomCard('MEMBERS', '$membersCount',
                    'assets/images/member.png', member, context),
                buildCustomCard('EQUIPMENTS', '$totalQuantity',
                    'assets/images/equipment.png', equipment, context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
