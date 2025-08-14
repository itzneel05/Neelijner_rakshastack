import 'package:flutter/material.dart';

class CustomCityDropdown extends StatelessWidget {
  final String? selectedCity;
  final Function(String?) onChanged;
  final List<String> cities;

  const CustomCityDropdown({
    super.key,
    required this.selectedCity,
    required this.onChanged,
    required this.cities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCity,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          isExpanded: true,
          borderRadius: BorderRadius.circular(14),
          hint: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Select Your City',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              Text(
                'Current City',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
          items: cities.map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(
                city,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
