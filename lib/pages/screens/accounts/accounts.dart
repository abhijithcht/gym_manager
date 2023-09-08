import 'package:flutter/material.dart';
import 'package:gym_manager/utilities/custom_button.dart';

class GymAccounts extends StatefulWidget {
  const GymAccounts({Key? key}) : super(key: key);

  @override
  State<GymAccounts> createState() => _GymAccountsState();
}

class _GymAccountsState extends State<GymAccounts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 300,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: 'ADD REVENUE',
                    onPressed: () {
                      Navigator.pushNamed(context, '/addRevenue');
                    },
                  ),
                  CustomButton(
                    text: 'VIEW REVENUE',
                    onPressed: () {
                      Navigator.pushNamed(context, '/revenue');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 300,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: 'ADD EXPENSE',
                    onPressed: () {
                      Navigator.pushNamed(context, '/addExpense');
                    },
                  ),
                  CustomButton(
                    text: 'VIEW EXPENSE',
                    onPressed: () {
                      Navigator.pushNamed(context, '/expense');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
