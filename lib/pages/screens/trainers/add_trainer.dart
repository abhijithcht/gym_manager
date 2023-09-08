import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../utilities/custom_button.dart';
import '../../../utilities/custom_textfield.dart';

class AddTrainer extends StatefulWidget {
  const AddTrainer({Key? key}) : super(key: key);

  @override
  State<AddTrainer> createState() => _AddTrainerState();
}

class _AddTrainerState extends State<AddTrainer> {
  final formKey = GlobalKey<FormState>();
  final firestore = FirebaseFirestore.instance;
  final trainerCollection = 'trainer';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    mobileController.dispose();
    dateController.dispose();
    salaryController.dispose();
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
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> addTrainerDetails() async {
    if (formKey.currentState!.validate()) {
      String name = nameController.text.trim();
      int age = int.tryParse(ageController.text.trim()) ?? 0;
      String phone = mobileController.text.trim();
      String dateString = dateController.text.trim();
      DateTime date = DateFormat('yyyy-MM-dd').parse(dateString);
      int salary = int.tryParse(salaryController.text.trim()) ?? 0;

      await FirebaseFirestore.instance.collection(trainerCollection).add({
        'name': name,
        'age': age,
        'phone': phone,
        'date': date,
        'salary': salary,
      });

      if (!mounted) return;

      Navigator.pop(
        context,
        {
          'name': name,
          'age': age,
          'phone': phone,
          'date': date,
          'salary': salary,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Trainer'),
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
                  image: AssetImage('assets/images/trainer.png'),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomTextInputField(
                controller: nameController,
                hintText: 'Name',
                prefixIcon: Icons.person,
                keyboardType: TextInputType.name,
                validator: _validateInput,
              ),
              CustomTextInputField(
                controller: ageController,
                hintText: 'Age',
                prefixIcon: Icons.face,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateInput,
              ),
              CustomTextInputField(
                controller: mobileController,
                hintText: 'Phone Number',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: _validateInput,
              ),
              CustomTextInputField(
                controller: dateController,
                hintText: 'Join Date',
                prefixIcon: Icons.calendar_today_rounded,
                keyboardType: TextInputType.none,
                onTap: () async {
                  await _selectDate(context);
                },
                validator: _validateInput,
              ),
              CustomTextInputField(
                controller: salaryController,
                hintText: 'Monthly Salary',
                prefixIcon: Icons.attach_money_rounded,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.done,
                validator: _validateInput,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                text: 'Add Trainer',
                onPressed: addTrainerDetails,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
