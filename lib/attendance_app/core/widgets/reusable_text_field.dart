import 'package:flutter/material.dart';

// ReusableTextField is a common text field widget to reduce code duplication.
class ReusableTextField extends StatelessWidget {
  final String hintText; // Placeholder text
  final TextEditingController controller; // Controller to get user input
  final bool obscureText; // To hide or show text (for passwords)
  final TextInputType keyboardType; // Keyboard type (number, email, text)

  const ReusableTextField({
    required this.hintText,
    required this.controller,
    this.obscureText = false, // Default to non-obscured text
    this.keyboardType = TextInputType.text, // Default keyboard type
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // Assigning controller
      obscureText: obscureText, // Managing password visibility
      keyboardType: keyboardType, // Setting keyboard type
      decoration: InputDecoration(
        hintText: hintText, // Placeholder text
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded borders
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding for input field
      ),
    );
  }
}
