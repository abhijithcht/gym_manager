import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../utilities/custom_button.dart';
import '../../../utilities/custom_textfield.dart';

class AddRevenue extends StatefulWidget {
  const AddRevenue({Key? key}) : super(key: key);

  @override
  State<AddRevenue> createState() => _AddRevenueState();
}

class _AddRevenueState extends State<AddRevenue> {
  final firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  final revenueCollection = 'income';

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

  Future _selectDate(BuildContext context) async {
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

  Future<void> addRevenue() async {
    if (formKey.currentState!.validate()) {
      String name = nameController.text.trim();
      int amount = int.tryParse(amountController.text.trim()) ?? 0;
      String dateString = dateController.text.trim();
      DateTime date = DateFormat('yyyy-MM-dd').parse(dateString);

      await FirebaseFirestore.instance.collection(revenueCollection).add(
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
        title: const Text('A D D  R E V E N U E'),
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
                  image: AssetImage('assets/images/up.png'),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomTextInputField(
                controller: nameController,
                hintText: 'Revenue',
                prefixIcon: Icons.wallet_rounded,
                validator: _validateInput,
              ),
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
                onPressed: addRevenue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
