import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../utilities/custom_button.dart';
import '../../../utilities/custom_textfield.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({Key? key}) : super(key: key);

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  final expenseCollection = 'expense';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill the field.';
    }
    return null;
  }

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(
        () {
          selectedDate = picked;
          dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        },
      );
    }
  }

  Future<void> addExpenses() async {
    if (formKey.currentState!.validate()) {
      String name = nameController.text.trim();
      int amount = int.tryParse(amountController.text.trim()) ?? 0;
      String dateString = dateController.text.trim();
      DateTime date = DateFormat('yyyy-MM-dd').parse(dateString);

      await FirebaseFirestore.instance.collection(expenseCollection).add(
        {
          'name': name,
          'amount': amount,
          'date': date,
        },
      );

      if (!mounted) return;

      Navigator.pop(
        context,
        {
          'name': name,
          'amount': amount,
          'date': date,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A D D  E X P E N S E'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const CircleAvatar(
                radius: 60,
                child: Image(
                  image: AssetImage('assets/images/down.png'),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomTextInputField(
                  controller: nameController,
                  hintText: 'Expense',
                  prefixIcon: Icons.wallet_rounded,
                  validator: _validateInput),
              CustomTextInputField(
                controller: amountController,
                hintText: 'Amount',
                prefixIcon: Icons.attach_money_rounded,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateInput,
              ),
              CustomTextInputField(
                controller: dateController,
                hintText: 'Date',
                prefixIcon: Icons.calendar_today_rounded,
                keyboardType: TextInputType.none,
                validator: _validateInput,
                onTap: () async {
                  await _selectDate(context);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                text: 'ADD',
                onPressed: addExpenses,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
