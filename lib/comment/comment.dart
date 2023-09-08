// CustomButton(
// text: 'Sign Up',
// onPressed: (context) async {
// if (loginEmail.text.isEmpty ||
// loginPassword.text.isEmpty ||
// confirmPassword.text.isEmpty ||
// _ownerNameController.text.isEmpty ||
// _gymNameController.text.isEmpty ||
// _descriptionController.text.isEmpty) {
// ScaffoldMessenger.of(context).showSnackBar(
// CustomSnackBar(message: 'Please fill in all fields.'),
// );
// } else if (loginEmail.text.isNotEmpty &&
// loginPassword.text.isNotEmpty &&
// confirmPassword.text.isNotEmpty &&
// _ownerNameController.text.isNotEmpty &&
// _gymNameController.text.isNotEmpty &&
// _descriptionController.text.isNotEmpty &&
// loginPassword.text != confirmPassword.text) {
// ScaffoldMessenger.of(context).showSnackBar(
// CustomSnackBar(message: 'Passwords doesn\'t match.'),
// );
// } else {
// if (formKey.currentState!.validate()) {
// await signup();
// }
// }
// },
// )

// DateTime parsedDate =
//     DateFormat('dd/MM/yyyy').parse(documentSnapshot['date']);
// dateController.text = DateFormat('dd/MM/yyyy').format(parsedDate);

// dateController.text =
//     DateFormat('dd/MM/yyyy').format(documentSnapshot['date'].toDate());
