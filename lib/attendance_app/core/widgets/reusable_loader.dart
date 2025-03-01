import 'package:flutter/material.dart';

// ReusableLoader is a common loading indicator widget.
class ReusableLoader extends StatelessWidget {
  const ReusableLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(), // Displaying a circular loading indicator
    );
  }
}