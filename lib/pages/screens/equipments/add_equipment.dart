import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../utilities/custom_button.dart';
import '../../../utilities/custom_textfield.dart';

class AddEquipment extends StatefulWidget {
  const AddEquipment({Key? key}) : super(key: key);

  @override
  State<AddEquipment> createState() => _AddEquipmentState();
}

class _AddEquipmentState extends State<AddEquipment> {
  final formKey = GlobalKey<FormState>();
  final firestore = FirebaseFirestore.instance;
  final equipmentCollection = 'equipment';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController warrantyController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    warrantyController.dispose();
    amountController.dispose();
    dateController.dispose();
    quantityController.dispose();
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

  Future<void> addEquipmentDetails() async {
    if (formKey.currentState!.validate()) {
      final name = nameController.text.trim();
      final quantity = _parseInt(quantityController.text);
      final warranty = _parseInt(warrantyController.text);
      final amount = _parseInt(amountController.text);
      final dateString = dateController.text.trim();
      final date = DateFormat('yyyy-MM-dd').parse(dateString);

      await firestore.collection(equipmentCollection).add({
        'name': name,
        'quantity': quantity,
        'date': date,
        'warranty': warranty,
        'amount': amount,
      });

      if (!mounted) return;

      Navigator.pop(
        context,
        {
          'name': name,
          'quantity': quantity,
          'date': date,
          'warranty': warranty,
          'amount': amount,
        },
      );
    }
  }

  int _parseInt(String text) {
    return int.tryParse(text.trim()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Equipment'),
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
                  image: AssetImage('assets/images/equipment.png'),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomTextInputField(
                controller: nameController,
                hintText: 'Equipment',
                prefixIcon: Icons.fitness_center_rounded,
                validator: _validateInput,
              ),
              CustomTextInputField(
                controller: quantityController,
                hintText: 'Quantity',
                prefixIcon: Icons.production_quantity_limits,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateInput,
              ),
              CustomTextInputField(
                controller: dateController,
                hintText: 'Purchase Date',
                prefixIcon: Icons.calendar_today_rounded,
                keyboardType: TextInputType.none,
                onTap: () async {
                  await _selectDate(context);
                },
                validator: _validateInput,
              ),
              CustomTextInputField(
                controller: warrantyController,
                hintText: 'Warranty in Years',
                prefixIcon: Icons.warning_rounded,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateInput,
              ),
              CustomTextInputField(
                controller: amountController,
                hintText: 'Total Purchase Amount',
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
                text: 'Add Equipment',
                onPressed: addEquipmentDetails,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
