import 'package:flutter/material.dart';

class FilterAmenities extends StatefulWidget {
  final bool initialWifi;
  final bool initialAC;
  final bool initialParking;
  final bool initialHousekeeping;
  final bool initialLaundry;
  final bool initialFood;
  final void Function(
    bool wifi,
    bool ac,
    bool parking,
    bool housekeeping,
    bool laundry,
    bool food,
  )
  onApply;

  const FilterAmenities({
    super.key,
    this.initialWifi = false,
    this.initialAC = false,
    this.initialParking = false,
    this.initialFood = false,
    this.initialHousekeeping = false,
    this.initialLaundry = false,
    required this.onApply,
  });

  @override
  State<FilterAmenities> createState() => _FilterAmenitiesState();
}

class _FilterAmenitiesState extends State<FilterAmenities> {
  late bool wifi = widget.initialWifi;
  late bool ac = widget.initialAC;
  late bool parking = widget.initialParking;
  late bool housekeeping = widget.initialHousekeeping;
  late bool laundry = widget.initialLaundry;
  late bool food = widget.initialFood;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // First Checkbox
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Row(
                  children: [
                    Checkbox(
                      side: BorderSide(
                        color: const Color.fromARGB(255, 104, 104, 104),
                        width: 1.2,
                      ),
                      value: wifi,
                      onChanged: (val) => setState(() => wifi = val ?? false),
                      activeColor: Color(0xFF1C79D3),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Icon(Icons.wifi, size: 22),
                    SizedBox(width: 6),
                    Text(
                      "Wifi",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Second Checkbox
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Row(
                  children: [
                    Checkbox(
                      side: BorderSide(
                        color: const Color.fromARGB(255, 104, 104, 104),
                        width: 1.2,
                      ),
                      value: ac,
                      onChanged: (val) => setState(() => ac = val ?? false),
                      activeColor: Color(0xFF1C79D3),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Icon(Icons.ac_unit, size: 22),
                    SizedBox(width: 6),
                    Text(
                      "AC",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // First Checkbox
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Row(
                  children: [
                    Checkbox(
                      side: BorderSide(
                        color: const Color.fromARGB(255, 104, 104, 104),
                        width: 1.2,
                      ),
                      value: parking,
                      onChanged: (val) =>
                          setState(() => parking = val ?? false),
                      activeColor: Color(0xFF1C79D3),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Icon(Icons.local_parking, size: 22),
                    SizedBox(width: 6),
                    Text(
                      "Parking",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Second Checkbox
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Row(
                  children: [
                    Checkbox(
                      side: BorderSide(
                        color: const Color.fromARGB(255, 104, 104, 104),
                        width: 1.2,
                      ),
                      value: laundry,
                      onChanged: (val) =>
                          setState(() => laundry = val ?? false),
                      activeColor: Color(0xFF1C79D3),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Icon(Icons.local_laundry_service_outlined, size: 22),
                    SizedBox(width: 6),
                    Text(
                      "Laundry",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // First Checkbox
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Row(
                  children: [
                    Checkbox(
                      side: BorderSide(
                        color: const Color.fromARGB(255, 104, 104, 104),
                        width: 1.2,
                      ),
                      value: housekeeping,
                      onChanged: (val) =>
                          setState(() => housekeeping = val ?? false),
                      activeColor: Color(0xFF1C79D3),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Icon(Icons.cleaning_services_outlined, size: 22),
                    SizedBox(width: 6),
                    Text(
                      "Cleaning",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Second Checkbox
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Row(
                  children: [
                    Checkbox(
                      side: BorderSide(
                        color: const Color.fromARGB(255, 104, 104, 104),
                        width: 1.2,
                      ),
                      value: food,
                      onChanged: (val) => setState(() => food = val ?? false),
                      activeColor: Color(0xFF1C79D3),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Icon(Icons.lunch_dining, size: 22),
                    SizedBox(width: 6),
                    Text(
                      "Food",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
