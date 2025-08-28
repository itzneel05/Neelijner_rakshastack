import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddEditPgRoomPage extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? initialData;
  const AddEditPgRoomPage({super.key, this.docId, this.initialData});
  @override
  State<AddEditPgRoomPage> createState() => _AddEditPgRoomPageState();
}

enum Occupancy { single, doubleOcc, triple }

enum GenderPref { maleOnly, femaleOnly, coEd }

const occupancyLabel = {
  Occupancy.single: 'Single',
  Occupancy.doubleOcc: 'Double',
  Occupancy.triple: 'Triple',
};
const genderLabel = {
  GenderPref.maleOnly: 'Male Only',
  GenderPref.femaleOnly: 'Female Only',
  GenderPref.coEd: 'Co-ed',
};
const occupancyStore = {
  Occupancy.single: 'single',
  Occupancy.doubleOcc: 'double',
  Occupancy.triple: 'triple',
};
const genderStore = {
  GenderPref.maleOnly: 'male_only',
  GenderPref.femaleOnly: 'female_only',
  GenderPref.coEd: 'co_ed',
};

class _AddEditPgRoomPageState extends State<AddEditPgRoomPage> {
  int selectedGenderIndex = 0;
  final _formKey = GlobalKey<FormState>();
  Occupancy _occupancy = Occupancy.doubleOcc;
  GenderPref _gender = GenderPref.maleOnly;
  Set<String> amenities = {};
  bool saving = false;
  String? _coverPhotoUrl;
  XFile? _cardPhoto;
  List<String> _galleryPhotoUrls = [];
  bool isFurnished = false;
  static const List<String> _gujaratCities = [
    'Ahmedabad',
    'Surat',
    'Vadodara',
    'Rajkot',
    'Gandhinagar',
    'Bhavnagar',
    'Jamnagar',
    'Junagadh',
    'Anand',
    'Bharuch',
    'Vapi',
    'Navsari',
  ];
  final _pgNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _cityController = TextEditingController();
  final _fullLocationController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _ownerEmailController = TextEditingController();
  final _ownerWhatsupController = TextEditingController();
  final _picker = ImagePicker();
  final List<XFile> _detailPhotos = [];
  bool _pickingCard = false;
  bool _pickingDetails = false;
  Future<void> _pickCardPhoto() async {
    if (_pickingCard) return;
    setState(() => _pickingCard = true);
    try {
      final img = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (img != null) setState(() => _cardPhoto = img);
    } finally {
      if (mounted) setState(() => _pickingCard = false);
    }
  }

  Future<void> _pickDetailPhotos() async {
    if (_pickingDetails) return;
    setState(() => _pickingDetails = true);
    try {
      final imgs = await _picker.pickMultiImage(
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (imgs.isNotEmpty) {
        setState(() {
          _detailPhotos.addAll(imgs);
        });
      }
    } finally {
      if (mounted) setState(() => _pickingDetails = false);
    }
  }

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
    _cityController.dispose();
    _fullLocationController.dispose();
    _ownerPhoneController.dispose();
    _ownerEmailController.dispose();
    _ownerWhatsupController.dispose();
    super.dispose();
  }

  Future<void> insertPgRoom() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => saving = true);
    try {
      final name = _pgNameController.text.trim();
      final city = _cityController.text.trim();
      final fulllocation = _fullLocationController.text.trim();
      final description = _descController.text.trim();
      final priceText = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final price = int.tryParse(priceText) ?? 0;
      final occStr = occupancyStore[_occupancy];
      final genderStr = genderStore[_gender];
      final amenityList = amenities.toList()..sort();
      final ownerPhone = _ownerPhoneController.text.trim();
      final ownerEmail = _ownerEmailController.text.trim();
      String ownerWhatsapp = _ownerWhatsupController.text.trim();
      if (ownerWhatsapp.isEmpty && ownerPhone.isNotEmpty) {
        final digits = ownerPhone.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.isNotEmpty) ownerWhatsapp = 'https://wa.me/' + digits;
      }
      final rooms = FirebaseFirestore.instance.collection('pgRooms');
      final newDocRef = rooms.doc();
      final docId = newDocRef.id;
      const BUCKET = 'pg_rooms';
      final storage = Supabase.instance.client.storage.from(BUCKET);
      String? coverUrl;
      if (_cardPhoto != null) {
        coverUrl = await _uploadOneToSupabase(
          storage: storage,
          file: _cardPhoto!,
          path: '$docId/cover.jpg',
        );
      }
      final List<String> galleryUrls = [];
      for (int i = 0; i < _detailPhotos.length; i++) {
        final x = _detailPhotos[i];
        final url = await _uploadOneToSupabase(
          storage: storage,
          file: x,
          path: '$docId/gallery/img_$i.jpg',
        );
        if (url != null) galleryUrls.add(url);
      }
      final user = FirebaseAuth.instance.currentUser!;
      final uid = user.uid;
      final creatorEmail = user.email;
      final data = {
        'name': name,
        'city': city,
        'fulllocation': fulllocation,
        'pricePerMonth': price,
        'occupancy': occStr,
        'genderPreference': genderStr,
        'amenities': amenityList,
        'description': description,
        'isFurnished': isFurnished,
        'ownerContact': {
          'phone': ownerPhone,
          'email': ownerEmail,
          'whatsappLink': ownerWhatsapp,
        },
        'photos': {'cardUrl': coverUrl, 'galleryUrls': galleryUrls},
        'createdAt': FieldValue.serverTimestamp(),
        'createdByUid': uid,
        'createdByEmail': creatorEmail,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      await newDocRef.set(data);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('PG saved')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> updatePgRoom(String docId) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => saving = true);
    try {
      final name = _pgNameController.text.trim();
      final city = _cityController.text.trim();
      final description = _descController.text.trim();
      final priceText = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final price = int.tryParse(priceText) ?? 0;
      final occStr = occupancyStore[_occupancy];
      final genderStr = genderStore[_gender];
      final amenityList = amenities.toList()..sort();
      final ownerPhone = _ownerPhoneController.text.trim();
      final ownerEmail = _ownerEmailController.text.trim();
      String ownerWhatsapp = _ownerWhatsupController.text.trim();
      if (ownerWhatsapp.isEmpty && ownerPhone.isNotEmpty) {
        final digits = ownerPhone.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.isNotEmpty) ownerWhatsapp = 'https://wa.me/' + digits;
      }
      const BUCKET = 'pg_rooms';
      final storage = Supabase.instance.client.storage.from(BUCKET);
      String? coverUrl;
      if (_cardPhoto != null) {
        coverUrl = await _uploadOneToSupabase(
          storage: storage,
          file: _cardPhoto!,
          path: '$docId/cover.jpg',
        );
      }
      final List<String> newlyUploadedGalleryUrls = [];
      for (int i = 0; i < _detailPhotos.length; i++) {
        final url = await _uploadOneToSupabase(
          storage: storage,
          file: _detailPhotos[i],
          path: '$docId/gallery/img_$i.jpg',
        );
        if (url != null) newlyUploadedGalleryUrls.add(url);
      }
      final updatedGalleryUrls = List<String>.from(_galleryPhotoUrls)
        ..addAll(newlyUploadedGalleryUrls);
      final Map<String, dynamic> data = {
        'name': name,
        'city': city,
        'pricePerMonth': price,
        'occupancy': occStr,
        'genderPreference': genderStr,
        'amenities': amenityList,
        'description': description,
        'isFurnished': isFurnished,
        'ownerContact': {
          'phone': ownerPhone,
          'email': ownerEmail,
          'whatsappLink': ownerWhatsapp,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      };
      final photos = <String, dynamic>{};
      if (coverUrl != null) photos['cardUrl'] = coverUrl;
      if (updatedGalleryUrls.isNotEmpty) {
        photos['galleryUrls'] = updatedGalleryUrls;
      }
      if (photos.isNotEmpty) data['photos'] = photos;
      final docRef = FirebaseFirestore.instance
          .collection('pgRooms')
          .doc(docId);
      await docRef.set(data, SetOptions(merge: true));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PG room updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _pgNameController.text = data['name'] ?? '';
      _cityController.text = data['city'] ?? '';
      _priceController.text = (data['pricePerMonth']?.toString() ?? '');
      _descController.text = data['description'] ?? '';
      _fullLocationController.text = data['fulllocation'] ?? '';
      _coverPhotoUrl = widget.initialData?['photos']?['cardUrl'] as String?;
      isFurnished = data['isFurnished'] ?? false;
      final photos = widget.initialData?['photos'] ?? {};
      final List<dynamic>? galleryUrlsDynamic = photos['galleryUrls'];
      if (galleryUrlsDynamic != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _galleryPhotoUrls = List<String>.from(galleryUrlsDynamic);
          });
        });
      }
      final occStr = data['occupancy'] as String? ?? 'double';
      _occupancy = occupancyStore.entries
          .firstWhere(
            (element) => element.value == occStr,
            orElse: () => MapEntry(Occupancy.doubleOcc, 'double'),
          )
          .key;
      final genderStr = data['genderPreference'] as String? ?? 'male_only';
      _gender = genderStore.entries
          .firstWhere(
            (element) => element.value == genderStr,
            orElse: () => MapEntry(GenderPref.maleOnly, 'male_only'),
          )
          .key;
      final List amList = data['amenities'] ?? [];
      amenities = Set<String>.from(amList);
      final ownerContact = data['ownerContact'] ?? {};
      _ownerPhoneController.text = ownerContact['phone'] ?? '';
      _ownerEmailController.text = ownerContact['email'] ?? '';
      _ownerWhatsupController.text = ownerContact['whatsappLink'] ?? '';
    }
  }

  Widget _buildCoverPhoto() {
    if (_cardPhoto != null) {
      return Image.file(File(_cardPhoto!.path), fit: BoxFit.cover);
    } else if (_coverPhotoUrl != null && _coverPhotoUrl!.isNotEmpty) {
      return Image.network(
        _coverPhotoUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(child: CircularProgressIndicator());
        },
        errorBuilder: (_, __, ___) => Center(child: Icon(Icons.error)),
      );
    } else {
      return Center(
        child: Text(
          'No cover photo selected',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(62.0),
        child: AppBar(
          elevation: 2.5,
          shadowColor: Colors.black,
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
            children: <Widget>[
              Text(
                'Basic Info',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              SizedBox(height: 14),
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
              DropdownSearch<String>(
                items: (filter, infiniteScrollProps) => _gujaratCities,
                selectedItem: _cityController.text.isNotEmpty
                    ? _cityController.text
                    : null,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Search cities...",
                      prefixIcon: Icon(Icons.search),
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: 'City Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _cityController.text = value ?? '';
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a city' : null,
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _fullLocationController,
                decoration: InputDecoration(
                  labelText: 'Full Location',
                  hintText: 'e.g. Surat City, Gujarat, 394210',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Enter Full Location'
                    : null,
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price per Month',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixText: '₹',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter price' : null,
              ),
              SizedBox(height: 16),
              Text('Occupancy', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                children: Occupancy.values.map((opt) {
                  final selected = _occupancy == opt;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _occupancy = opt),
                      child: Container(
                        margin: EdgeInsets.only(
                          right: opt != Occupancy.triple ? 8 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFE8F2FE)
                              : Colors.white,
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF1C79D3)
                                : Colors.grey.shade300,
                            width: selected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            occupancyLabel[opt]!,
                            style: TextStyle(
                              color: selected
                                  ? const Color(0xFF1C79D3)
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 22),
              Text(
                'Gender Preference',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: GenderPref.values.asMap().entries.map((entry) {
                  final opt = entry.value;
                  final selected = _gender == opt;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _gender = opt),
                      child: Container(
                        margin: EdgeInsets.only(
                          right: entry.key < GenderPref.values.length - 1
                              ? 10
                              : 0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFE8F2FE)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF1C79D3)
                                : Colors.grey.shade300,
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            genderLabel[opt]!,
                            style: TextStyle(
                              color: selected
                                  ? const Color(0xFF1C79D3)
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "is PG Furnished?",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  Switch(
                    value: isFurnished,
                    onChanged: (val) {
                      setState(() => isFurnished = val);
                    },
                  ),
                ],
              ),
              SizedBox(height: 18),
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
              Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 3,
                maxLines: 8,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  labelText: 'PG Room Description',
                  hintText: 'Tell us more about the room...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Enter description'
                    : null,
              ),
              SizedBox(height: 28),
              Text(
                'Cover Photo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildCoverPhoto(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickingCard ? null : _pickCardPhoto,
                          icon: _pickingCard
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.photo_library,
                                  color: Colors.white,
                                ),
                          label: Text(
                            _cardPhoto == null
                                ? 'Pick Cover Photo'
                                : 'Replace Photo',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1C79D3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (_cardPhoto != null)
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _cardPhoto = null;
                                _coverPhotoUrl = null;
                              });
                            },
                            icon: Icon(Icons.delete_outline),
                            label: Text('Remove'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Gallery Photos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_galleryPhotoUrls.isEmpty && _detailPhotos.isEmpty)
                      Container(
                        height: 120,
                        alignment: Alignment.center,
                        child: Text(
                          'No detail photos added',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            _galleryPhotoUrls.length + _detailPhotos.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          Widget imageWidget;
                          bool isNetworkImage = false;
                          if (index < _galleryPhotoUrls.length) {
                            final url = _galleryPhotoUrls[index];
                            isNetworkImage = true;
                            imageWidget = ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) =>
                                    progress == null
                                    ? child
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.error),
                              ),
                            );
                          } else {
                            final xfile =
                                _detailPhotos[index - _galleryPhotoUrls.length];
                            imageWidget = ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(xfile.path),
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              imageWidget,
                              Positioned(
                                top: 4,
                                right: 4,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (isNetworkImage) {
                                        _galleryPhotoUrls.removeAt(index);
                                      } else {
                                        _detailPhotos.removeAt(
                                          index - _galleryPhotoUrls.length,
                                        );
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickingDetails ? null : _pickDetailPhotos,
                          icon: _pickingDetails
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.add_photo_alternate,
                                  color: Colors.white,
                                ),
                          label: const Text('Add Photos'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1C79D3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (_detailPhotos.isNotEmpty)
                          OutlinedButton.icon(
                            onPressed: () =>
                                setState(() => _detailPhotos.clear()),
                            icon: const Icon(Icons.delete_sweep_outlined),
                            label: const Text('Clear All'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Owner Contact',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ownerPhoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Owner Phone Number',
                  hintText: 'e.g. +919876543210',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                validator: (val) {
                  final v = (val ?? '').trim();
                  if (v.isEmpty) return 'Enter owner phone number';
                  final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
                  if (digits.length < 10) return 'Enter a valid phone number';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _ownerEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Owner Email',
                  hintText: 'e.g. owner@example.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (val) {
                  final v = (val ?? '').trim();
                  if (v.isEmpty) return 'Enter owner email';
                  final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
                  return ok ? null : 'Enter a valid email';
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _ownerWhatsupController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'Owner WhatsApp Link',
                  hintText: 'https://wa.me/919876543210',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.link),
                ),
                validator: (val) {
                  final v = (val ?? '').trim();
                  if (v.isEmpty) return null;
                  final ok =
                      Uri.tryParse(v)?.hasAbsolutePath == true &&
                      (v.startsWith('http://') || v.startsWith('https://'));
                  return ok ? null : 'Enter a valid URL (https://...)';
                },
              ),
              const SizedBox(height: 22),
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
                      onPressed: saving
                          ? null
                          : () {
                              if (widget.docId == null) {
                                insertPgRoom();
                              } else {
                                updatePgRoom(widget.docId!);
                              }
                            },
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

Future<String?> _uploadOneToSupabase({
  required StorageFileApi storage,
  required XFile file,
  required String path,
}) async {
  try {
    await storage.upload(
      path,
      File(file.path),
      fileOptions: const FileOptions(
        upsert: true,
        contentType: 'image/jpeg',
        cacheControl: '3600',
      ),
    );
    final url = storage.getPublicUrl(path);
    return url;
  } catch (e) {
    rethrow;
  }
}
