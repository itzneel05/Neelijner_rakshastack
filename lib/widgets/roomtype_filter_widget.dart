import 'package:flutter/material.dart';

class RoomTypeSelector extends StatefulWidget {
  const RoomTypeSelector({super.key});

  @override
  State<RoomTypeSelector> createState() => _RoomTypeSelectorState();
}

class _RoomTypeSelectorState extends State<RoomTypeSelector> {
  int selectedIndex = 0;

  final List<String> roomTypes = ['Single', 'Double', 'Triple'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Room Type",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(roomTypes.length, (index) {
              final bool isSelected = selectedIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedIndex = index),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index < roomTypes.length - 1 ? 10 : 0,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFFE8F2FE) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? Color(0xFF1C79D3)
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        roomTypes[index],
                        style: TextStyle(
                          color: isSelected
                              ? Color(0xFF1C79D3)
                              : Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
