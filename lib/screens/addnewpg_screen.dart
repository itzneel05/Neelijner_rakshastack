import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

class AddEditPgRoomPage extends StatefulWidget {
  const AddEditPgRoomPage({super.key});

  @override
  State<AddEditPgRoomPage> createState() => _AddEditPgRoomPageState();
}

class _AddEditPgRoomPageState extends State<AddEditPgRoomPage> {
  int selectedGenderIndex = 0;
  final List<String> genderOptions = ['Male Only', 'Female Only', 'Co-ed'];
  final _formKey = GlobalKey<FormState>();
  String city = 'Surat, Gujarat';
  String occupancy = 'Double';
  Set<String> amenities = {};
  bool saving = false;

  final _pgNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  final amenityList = [
    {'label': 'WiFi', 'icon': Icons.wifi},
    {'label': 'AC', 'icon': Icons.ac_unit},
    {'label': 'Parking', 'icon': Icons.local_parking},
    {'label': 'Housekeeping', 'icon': Icons.cleaning_services},
    {'label': 'Laundry', 'icon': Icons.local_laundry_service},
    {'label': 'Food', 'icon': Icons.restaurant},
  ];

  @override
  void dispose() {
    _pgNameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(62.0),
        child: AppBar(
          elevation: 2.5,
          shadowColor: Colors.black,
          // automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Color.fromRGBO(25, 118, 210, 1),
          title: Text(
            "Add/Edit PG Room",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.check, color: Colors.white),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Info',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              SizedBox(height: 14),

              // PG Name
              TextFormField(
                controller: _pgNameController,
                decoration: InputDecoration(
                  labelText: 'PG Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter PG Name' : null,
              ),
              SizedBox(height: 14),

              // City dropdown
              DropdownButtonFormField<String>(
                value: city,
                decoration: InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Surat, Gujarat',
                    child: Text('Surat, Gujarat'),
                  ),
                  DropdownMenuItem(
                    value: 'Ahmedabad, Gujarat',
                    child: Text('Ahmedabad, Gujarat'),
                  ),
                ],
                onChanged: (val) => setState(() => city = val!),
              ),
              SizedBox(height: 14),

              // Price
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price per Month',
                  // hintText:
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixText: '₹',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter price' : null,
              ),
              SizedBox(height: 16),

              // Occupancy buttons
              Text('Occupancy', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                children: [
                  for (var option in ['Single', 'Double', 'Triple'])
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => occupancy = option),
                        child: Container(
                          margin: EdgeInsets.only(
                            right: option != 'Triple' ? 8 : 0,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            color: occupancy == option
                                ? Color(0xFFE8F2FE)
                                : Colors.white,
                            border: Border.all(
                              color: occupancy == option
                                  ? Color(0xFF1C79D3)
                                  : Colors.grey.shade300,
                              width: occupancy == option ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              option,
                              style: TextStyle(
                                color: occupancy == option
                                    ? Color(0xFF1C79D3)
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              //Gender Preference
              SizedBox(height: 22),
              Text(
                'Gender Preference',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(genderOptions.length, (index) {
                  final bool isSelected = selectedGenderIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedGenderIndex = index),
                      child: Container(
                        margin: EdgeInsets.only(
                          right: index < genderOptions.length - 1 ? 10 : 0,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
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
                            genderOptions[index],
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
              SizedBox(height: 24),

              // Amenities section
              Text('Amenities', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  for (final amenity in amenityList)
                    FilterChip(
                      selected: amenities.contains(amenity['label']),
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            amenity['icon'] as IconData?,
                            size: 17,
                            color: Color(0xFF1C79D3),
                          ),
                          SizedBox(width: 5),
                          Text(amenity['label'] as String),
                        ],
                      ),
                      selectedColor: Color(0xFFE8F2FE),
                      checkmarkColor: Color(0xFF1C79D3),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          width: 1.2,
                          color: amenities.contains(amenity['label'])
                              ? Color(0xFF1C79D3)
                              : Colors.grey.shade300,
                        ),
                      ),
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            amenities.add(amenity['label'] as String);
                          } else {
                            amenities.remove(amenity['label']);
                          }
                        });
                      },
                    ),
                ],
              ),
              SizedBox(height: 24),

              // Description field
              Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tell us more about the room...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 28),

              Text(
                'Upload PG Room Photo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload_file, color: Colors.white),
                label: const Text('Choose File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1C79D3), // Blue theme
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Bottom buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: BorderSide(color: Colors.grey.shade400),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1C79D3),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'SAVE CHANGES',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
