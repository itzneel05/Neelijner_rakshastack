import 'package:flutter/material.dart';
class InputBoxWidget extends StatelessWidget {
  final String placeholderName;
  final IconData icon;
  const InputBoxWidget({
    super.key,
    required this.placeholderName,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
        ),
        prefixIcon: Icon(icon),
        hint: Text(
          placeholderName,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

