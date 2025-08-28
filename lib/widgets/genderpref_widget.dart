import 'package:flutter/material.dart';
class GenderPreferenceSelector extends StatefulWidget {
  final int initialIndex;
  final void Function(int index)? onChanged;
  GenderPreferenceSelector({this.initialIndex = 0, this.onChanged});
  @override
  State<GenderPreferenceSelector> createState() =>
      _GenderPreferenceSelectorState();
}
class _GenderPreferenceSelectorState extends State<GenderPreferenceSelector> {
  int selectedIndex = 0;
  final List<String> prefs = ['Male Only', 'Female Only', 'Co-ed'];
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: List.generate(prefs.length, (index) {
          final bool isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
                if (widget.onChanged != null) widget.onChanged!(index);
              },
              child: Container(
                margin: EdgeInsets.only(
                  right: index < prefs.length - 1 ? 10 : 0,
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
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
                    prefs[index],
                    style: TextStyle(
                      color: isSelected ? Color(0xFF1C79D3) : Colors.black87,
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
    );
  }
}

