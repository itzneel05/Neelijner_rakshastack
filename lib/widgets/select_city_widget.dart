import 'package:dropdown_search/dropdown_search.dart';
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
        child: DropdownSearch<String>(
          selectedItem: selectedCity,
          items: (filter, _) {
            if ((filter ?? '').trim().isEmpty) return cities;
            final f = filter!.toLowerCase();
            return cities.where((c) => c.toLowerCase().contains(f)).toList();
          },
          decoratorProps: const DropDownDecoratorProps(
            decoration: InputDecoration.collapsed(hintText: ''),
          ),
          dropdownBuilder: (context, value) {
            final currentText = (value == null || value.isEmpty)
                ? 'Current City'
                : 'Current City: $value';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Your City',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  currentText,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
          suffixProps: const DropdownSuffixProps(
            dropdownButtonProps: DropdownButtonProps(
              iconClosed: Icon(Icons.keyboard_arrow_down, color: Colors.black),
              iconOpened: Icon(Icons.keyboard_arrow_up, color: Colors.black),
            ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            constraints: const BoxConstraints(maxHeight: 320),
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Search cities...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
          onChanged: onChanged,
          validator: (v) =>
              v == null || v.isEmpty ? 'Please select a city' : null,
        ),
      ),
    );
  }
}

