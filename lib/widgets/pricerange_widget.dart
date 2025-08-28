import 'package:flutter/material.dart';
class PriceRangeSlider extends StatefulWidget {
  const PriceRangeSlider({super.key});
  @override
  State<PriceRangeSlider> createState() => _PriceRangeSliderState();
}
class _PriceRangeSliderState extends State<PriceRangeSlider> {
  final double _min = 2500;
  final double _max = 25000;
  RangeValues _currentRange = const RangeValues(2500, 25000);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Price Range",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "₹${_currentRange.start.toInt()} - ₹${_currentRange.end.toInt()}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        RangeSlider(
          values: _currentRange,
          min: _min,
          max: _max,
          divisions: 10,
          activeColor: const Color.fromARGB(255, 31, 126, 222),
          inactiveColor: Colors.grey.shade300,
          labels: RangeLabels(
            "₹${_currentRange.start.toInt()}",
            "₹${_currentRange.end.toInt()}",
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRange = values;
            });
          },
        ),
      ],
    );
  }
}

