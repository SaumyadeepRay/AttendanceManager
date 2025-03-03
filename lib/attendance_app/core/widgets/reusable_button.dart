import 'package:flutter/material.dart';

// ReusableButton is a common button widget that can be used across the app.
// It helps in code reusability and maintains a consistent design.
class ReusableButton extends StatelessWidget {
  final String label; // Button label text
  final VoidCallback onPressed; // Callback function when button is pressed
  final Color color; // Optional button color
  final double width; // Optional button width
  final double height; // Optional button height

  const ReusableButton({
    required this.label,
    required this.onPressed,
    this.color = Colors.blue, // Default button color
    this.width = double.infinity, // Default width to occupy full available space
    this.height = 50.0, // Default height of the button
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // Setting button width
      height: height, // Setting button height
      child: ElevatedButton(
        onPressed: onPressed, // Executing the callback on button press
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Setting button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Adding rounded corners
          ),
        ),
        child: Text(
          label, // Displaying button label
          style: TextStyle(color: Colors.white, fontSize: 16), // Styling the text
        ),
      ),
    );
  }
}