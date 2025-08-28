import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pg_application/screens/main_page.dart';
import 'package:pg_application/widgets/avatar_widget.dart';
import 'package:pg_application/widgets/pglisting_widget.dart';
import 'package:pg_application/widgets/pricerange_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Search extends StatefulWidget {
  const Search({super.key});
  @override
  State<Search> createState() => _SearchState();
}
class _SearchState extends State<Search> {
  final double _min = 2000;
  final double _max = 12000;
  RangeValues _currentRange = const RangeValues(2000, 12000);
  final TextEditingController _searchCtl = TextEditingController();
  Timer? _debounce;
  String _query = '';
  bool _isFilterActive = false;
  bool _wifiFilter = false;
  bool _acFilter = false;
  bool _parkingFilter = false;
  bool _housekeepingFilter = false;
  bool _laundryFilter = false;
  bool _foodFilter = false;
  int _roomTypeIndex = 0;
  final List<String> _roomTypes = ['Single', 'Double', 'Triple'];
  int _genderPrefIndex = 0;
  final List<String> _genderPrefs = ['male_only', 'female_only', 'co_ed'];
  bool _isFurnishedFilter = false;
  bool _applyFilters(DocumentSnapshot doc) {
    if (!_isFilterActive) return true;
    final data = doc.data() as Map<String, dynamic>;
    final price = data['price'] as num?;
    if (price != null) {
      if (price < _currentRange.start || price > _currentRange.end) {
        return false;
      }
    }
    final amenities = data['amenities'] as List<dynamic>? ?? [];
    if (_wifiFilter && !amenities.contains('WiFi')) return false;
    if (_acFilter && !amenities.contains('AC')) return false;
    if (_parkingFilter && !amenities.contains('Parking')) return false;
    if (_housekeepingFilter && !amenities.contains('Housekeeping'))
      return false;
    if (_laundryFilter && !amenities.contains('Laundry')) return false;
    if (_foodFilter && !amenities.contains('Food')) return false;
    if (_roomTypeIndex > 0) {
      final roomType = data['occupancy'] as String?;
      if (roomType != _roomTypes[_roomTypeIndex].toLowerCase()) return false;
    }
    if (_genderPrefIndex > 0) {
      final genderPref = data['genderPreference'] as String?;
      if (genderPref != _genderPrefs[_genderPrefIndex].toLowerCase()) {
        return false;
      }
    }
    if (_isFurnishedFilter) {
      final isFurnished = data['isFurnished'] as bool? ?? false;
      if (!isFurnished) return false;
    }
    return true;
  }
  void _onSearchChanged(String val) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _query = val.trim();
      });
    });
  }
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _searchRooms(
    String q,
  ) async {
    if (q.isEmpty) return const [];
    final col = FirebaseFirestore.instance.collection('pgRooms');
    final nameQs = await col
        .orderBy('name') 
        .startAt([q]) 
        .endAt(['$q\uf8ff']) 
        .limit(30)
        .get(); 
    final cityQs = await col
        .orderBy('city')
        .startAt([q])
        .endAt(['$q\uf8ff'])
        .limit(30)
        .get();
    final seen = <String>{};
    final merged = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
    for (final d in [...nameQs.docs, ...cityQs.docs]) {
      if (seen.add(d.id)) merged.add(d);
    }
    return merged;
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> _getFilteredStream() {
    var query = FirebaseFirestore.instance
        .collection('pgRooms')
        .orderBy('createdAt', descending: true);
    query = query.where(
      'pricePerMonth',
      isGreaterThanOrEqualTo: _currentRange.start,
    );
    query = query.where(
      'pricePerMonth',
      isLessThanOrEqualTo: _currentRange.end,
    );
    return query.snapshots();
  }
  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtl.dispose();
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
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(25, 118, 210, 1),
          title: Text(
            "PGFinder",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MainPage(initialTab: 3),
                  ),
                  (route) => false,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: AppAvatar.byAuthUid(
                  FirebaseAuth.instance.currentUser?.uid ?? '',
                  size: 36, 
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchCtl,
                        onChanged: _onSearchChanged,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Search for PG, location…',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF1C79D3),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                        onSubmitted: (query) {},
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Material(
                      color: Color.fromARGB(255, 26, 112, 198),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                      child: IconButton(
                        icon: const Icon(
                          size: 30,
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                        tooltip: 'Filter',
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (BuildContext context) {
                              bool localWifiFilter = _wifiFilter;
                              bool localAcFilter = _acFilter;
                              bool localParkingFilter = _parkingFilter;
                              bool localHousekeepingFilter =
                                  _housekeepingFilter;
                              bool localLaundryFilter = _laundryFilter;
                              bool localFoodFilter = _foodFilter;
                              int localRoomTypeIndex = _roomTypeIndex;
                              int localGenderPrefIndex = _genderPrefIndex;
                              bool localIsFurnishedFilter = _isFurnishedFilter;
                              RangeValues localCurrentRange = _currentRange;
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  localWifiFilter = false;
                                                  localAcFilter = false;
                                                  localParkingFilter = false;
                                                  localHousekeepingFilter =
                                                      false;
                                                  localLaundryFilter = false;
                                                  localFoodFilter = false;
                                                  localRoomTypeIndex = 0;
                                                  localGenderPrefIndex = 0;
                                                  localIsFurnishedFilter =
                                                      false;
                                                  localCurrentRange =
                                                      RangeValues(_min, _max);
                                                });
                                              },
                                              child: Text(
                                                "Reset All",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: const Color.fromARGB(
                                                    255,
                                                    123,
                                                    123,
                                                    123,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Filters",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(Icons.close),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Price Range",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    "₹${localCurrentRange.start.toInt()} - ₹${localCurrentRange.end.toInt()}",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            RangeSlider(
                                              values: localCurrentRange,
                                              min: _min,
                                              max: _max,
                                              divisions: 10,
                                              activeColor: const Color.fromARGB(
                                                255,
                                                31,
                                                126,
                                                222,
                                              ),
                                              inactiveColor:
                                                  Colors.grey.shade300,
                                              labels: RangeLabels(
                                                "₹${localCurrentRange.start.toInt()}",
                                                "₹${localCurrentRange.end.toInt()}",
                                              ),
                                              onChanged: (RangeValues values) {
                                                setState(() {
                                                  localCurrentRange = values;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Amenities",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                        right: 8,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                          width: 1.2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 6,
                                                            horizontal: 12,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            side: BorderSide(
                                                              color:
                                                                  const Color.fromARGB(
                                                                    255,
                                                                    104,
                                                                    104,
                                                                    104,
                                                                  ),
                                                              width: 1.2,
                                                            ),
                                                            value:
                                                                localWifiFilter,
                                                            onChanged: (val) =>
                                                                setState(
                                                                  () =>
                                                                      localWifiFilter =
                                                                          val ??
                                                                          false,
                                                                ),
                                                            activeColor: Color(
                                                              0xFF1C79D3,
                                                            ),
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                          ),
                                                          Icon(
                                                            Icons.wifi,
                                                            size: 22,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            "Wifi",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                          width: 1.2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 6,
                                                            horizontal: 12,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            side: BorderSide(
                                                              color:
                                                                  const Color.fromARGB(
                                                                    255,
                                                                    104,
                                                                    104,
                                                                    104,
                                                                  ),
                                                              width: 1.2,
                                                            ),
                                                            value:
                                                                localAcFilter,
                                                            onChanged: (val) =>
                                                                setState(
                                                                  () =>
                                                                      localAcFilter =
                                                                          val ??
                                                                          false,
                                                                ),
                                                            activeColor: Color(
                                                              0xFF1C79D3,
                                                            ),
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                          ),
                                                          Icon(
                                                            Icons.ac_unit,
                                                            size: 22,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            "AC",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                        right: 8,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                          width: 1.2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 6,
                                                            horizontal: 12,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            side: BorderSide(
                                                              color:
                                                                  const Color.fromARGB(
                                                                    255,
                                                                    104,
                                                                    104,
                                                                    104,
                                                                  ),
                                                              width: 1.2,
                                                            ),
                                                            value:
                                                                localParkingFilter,
                                                            onChanged: (val) =>
                                                                setState(
                                                                  () =>
                                                                      localParkingFilter =
                                                                          val ??
                                                                          false,
                                                                ),
                                                            activeColor: Color(
                                                              0xFF1C79D3,
                                                            ),
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                          ),
                                                          Icon(
                                                            Icons.local_parking,
                                                            size: 22,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            "Parking",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                          width: 1.2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 6,
                                                            horizontal: 12,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            side: BorderSide(
                                                              color:
                                                                  const Color.fromARGB(
                                                                    255,
                                                                    104,
                                                                    104,
                                                                    104,
                                                                  ),
                                                              width: 1.2,
                                                            ),
                                                            value:
                                                                localHousekeepingFilter,
                                                            onChanged: (val) =>
                                                                setState(
                                                                  () =>
                                                                      localHousekeepingFilter =
                                                                          val ??
                                                                          false,
                                                                ),
                                                            activeColor: Color(
                                                              0xFF1C79D3,
                                                            ),
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .cleaning_services,
                                                            size: 22,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            "Cleaning",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                        right: 8,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                          width: 1.2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 6,
                                                            horizontal: 12,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            side: BorderSide(
                                                              color:
                                                                  const Color.fromARGB(
                                                                    255,
                                                                    104,
                                                                    104,
                                                                    104,
                                                                  ),
                                                              width: 1.2,
                                                            ),
                                                            value:
                                                                localLaundryFilter,
                                                            onChanged: (val) =>
                                                                setState(
                                                                  () =>
                                                                      localLaundryFilter =
                                                                          val ??
                                                                          false,
                                                                ),
                                                            activeColor: Color(
                                                              0xFF1C79D3,
                                                            ),
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .local_laundry_service,
                                                            size: 22,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            "Laundry",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                          width: 1.2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 6,
                                                            horizontal: 12,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            side: BorderSide(
                                                              color:
                                                                  const Color.fromARGB(
                                                                    255,
                                                                    104,
                                                                    104,
                                                                    104,
                                                                  ),
                                                              width: 1.2,
                                                            ),
                                                            value:
                                                                localFoodFilter,
                                                            onChanged: (val) =>
                                                                setState(
                                                                  () =>
                                                                      localFoodFilter =
                                                                          val ??
                                                                          false,
                                                                ),
                                                            activeColor: Color(
                                                              0xFF1C79D3,
                                                            ),
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                          ),
                                                          Icon(
                                                            Icons.restaurant,
                                                            size: 22,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            "Food",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Room Type",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                children: List.generate(_roomTypes.length, (
                                                  index,
                                                ) {
                                                  final bool isSelected =
                                                      localRoomTypeIndex ==
                                                      index;
                                                  return Expanded(
                                                    child: GestureDetector(
                                                      onTap: () => setState(
                                                        () =>
                                                            localRoomTypeIndex =
                                                                index,
                                                      ),
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                          right:
                                                              index <
                                                                  _roomTypes
                                                                          .length -
                                                                      1
                                                              ? 10
                                                              : 0,
                                                        ),
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 14,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: isSelected
                                                              ? Color(
                                                                  0xFFE8F2FE,
                                                                )
                                                              : Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          border: Border.all(
                                                            color: isSelected
                                                                ? Color(
                                                                    0xFF1C79D3,
                                                                  )
                                                                : Colors
                                                                      .grey
                                                                      .shade300,
                                                            width: isSelected
                                                                ? 2
                                                                : 1,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            _roomTypes[index],
                                                            style: TextStyle(
                                                              color: isSelected
                                                                  ? Color(
                                                                      0xFF1C79D3,
                                                                    )
                                                                  : Colors
                                                                        .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                        ),
                                        const SizedBox(height: 16),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text(
                                            "Additional Filters",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text(
                                            "Gender Preference",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: const Color.fromARGB(
                                                255,
                                                111,
                                                111,
                                                111,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Row(
                                            children: List.generate(
                                              _genderPrefs.length,
                                              (index) {
                                                final bool isSelected =
                                                    localGenderPrefIndex ==
                                                    index;
                                                return Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(
                                                        () =>
                                                            localGenderPrefIndex =
                                                                index,
                                                      );
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                        right:
                                                            index <
                                                                _genderPrefs
                                                                        .length -
                                                                    1
                                                            ? 10
                                                            : 0,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 15,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? Color(0xFFE8F2FE)
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        border: Border.all(
                                                          color: isSelected
                                                              ? Color(
                                                                  0xFF1C79D3,
                                                                )
                                                              : Colors
                                                                    .grey
                                                                    .shade300,
                                                          width: isSelected
                                                              ? 2
                                                              : 1,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          index == 0
                                                              ? 'Male'
                                                              : index == 1
                                                              ? 'Female'
                                                              : 'Co-ed',
                                                          style: TextStyle(
                                                            color: isSelected
                                                                ? Color(
                                                                    0xFF1C79D3,
                                                                  )
                                                                : Colors
                                                                      .black87,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Furnished/Unfurnished",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Switch(
                                                value: localIsFurnishedFilter,
                                                onChanged: (val) {
                                                  setState(
                                                    () =>
                                                        localIsFurnishedFilter =
                                                            val,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(
                                                0xFF1C79D3,
                                              ),
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              elevation: 2,
                                            ),
                                            onPressed: () {
                                              this.setState(() {
                                                _wifiFilter = localWifiFilter;
                                                _acFilter = localAcFilter;
                                                _parkingFilter =
                                                    localParkingFilter;
                                                _housekeepingFilter =
                                                    localHousekeepingFilter;
                                                _laundryFilter =
                                                    localLaundryFilter;
                                                _foodFilter = localFoodFilter;
                                                _roomTypeIndex =
                                                    localRoomTypeIndex;
                                                _genderPrefIndex =
                                                    localGenderPrefIndex;
                                                _isFurnishedFilter =
                                                    localIsFurnishedFilter;
                                                _currentRange =
                                                    localCurrentRange;
                                                _isFilterActive = true;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Apply Filters",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 50),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _query.isEmpty
                  ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('pgRooms')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snap) {
                        if (!snap.hasData)
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        final docs = snap.data!.docs;
                        if (docs.isEmpty)
                          return const Center(child: Text('No PG rooms found'));
                        final filteredDocs = _isFilterActive
                            ? docs.where((doc) => _applyFilters(doc)).toList()
                            : docs;
                        if (filteredDocs.isEmpty)
                          return const Center(
                            child: Text('No PG rooms match your filters'),
                          );
                        return ListView.builder(
                          itemCount: filteredDocs.length,
                          itemBuilder: (_, i) {
                            final d = filteredDocs[i];
                            final m = d.data();
                            final photos =
                                (m['photos'] ?? {}) as Map<String, dynamic>;
                            final cardUrl =
                                (photos['cardUrl'] ?? '') as String?;
                            final amenities = List<String>.from(
                              m['amenities'] ?? const [],
                            );
                            return PglistingWidget(
                              docId: d.id,
                              name: (m['name'] ?? '') as String,
                              city: (m['city'] ?? '') as String,
                              pricePerMonth: (m['pricePerMonth'] ?? 0) as int,
                              cardUrl: cardUrl,
                              amenities: amenities,
                              rating: (m['rating'] as num?)?.toDouble() ?? 0.0,
                            );
                          },
                        );
                      },
                    )
                  : FutureBuilder<
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    >(
                      future: _searchRooms(_query), 
                      builder: (context, snap) {
                        if (!snap.hasData)
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        var docs = snap.data!;
                        docs = _isFilterActive
                            ? docs.where((doc) => _applyFilters(doc)).toList()
                            : docs.where((doc) {
                                final m = doc.data();
                                final p =
                                    (m['pricePerMonth'] as num?)?.toDouble() ??
                                    0.0;
                                return p >= _currentRange.start &&
                                    p <= _currentRange.end;
                              }).toList();
                        if (docs.isEmpty)
                          return const Center(child: Text('No results'));
                        return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (_, i) {
                            final d = docs[i];
                            final m = d.data();
                            final photos =
                                (m['photos'] ?? {}) as Map<String, dynamic>;
                            final cardUrl =
                                (photos['cardUrl'] ?? '') as String?;
                            final amenities = List<String>.from(
                              m['amenities'] ?? const [],
                            );
                            return PglistingWidget(
                              docId: d.id,
                              name: (m['name'] ?? '') as String,
                              city: (m['city'] ?? '') as String,
                              pricePerMonth: (m['pricePerMonth'] ?? 0) as int,
                              cardUrl: cardUrl,
                              amenities: amenities,
                              rating: (m['rating'] as num?)?.toDouble() ?? 0.0,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

