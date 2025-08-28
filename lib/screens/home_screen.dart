import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:pg_application/screens/main_page.dart';
import 'package:pg_application/widgets/avatar_widget.dart';
import 'package:pg_application/widgets/pgcard_widget.dart';
import 'package:pg_application/widgets/select_city_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pg_application/widgets/favorites_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _favs = FavoritesService();
  String? _selectedCity;
  final String demoImg = 'assets/images/pg_01.jpg';
  final List<String> _cities = [
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
  final List<String> kOtherCities = [
    'Surat',
    'Ahmedabad',
    'Gandhinagar',
    'Rajkot',
    'Vadodara',
  ];
  String _normalizeCity(String? c) {
    final s = (c ?? '').trim();
    if (s.isEmpty) return 'Surat';
    switch (s.toLowerCase()) {
      case 'ahmedabad':
        return 'Ahmedabad';
      case 'gandhinagar':
        return 'Gandhinagar';
      case 'rajkot':
        return 'Rajkot';
      case 'vadodara':
        return 'Vadodara';
      case 'surat':
        return 'Surat';
      default:
        return s;
    }
  }

  Widget _citySection({
    required BuildContext context,
    required String city,
    required String fallbackAsset,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            '$city City',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 270,
          child: StreamBuilder<Set<String>>(
            stream: _favs.idsStream(),
            builder: (context, favSnap) {
              final favSet = favSnap.data ?? <String>{};
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('pgRooms')
                    .where('city', isEqualTo: city)
                    .snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snap.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(child: Text('No PG rooms found'));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final m = doc.data();
                      final photos =
                          (m['photos'] ?? {}) as Map<String, dynamic>;
                      final cardUrl = (photos['cardUrl'] ?? '') as String?;
                      final title = (m['name'] ?? '') as String;
                      final price = (m['pricePerMonth'] ?? 0) as int;
                      final rating = (m['rating'] as num?)?.toDouble() ?? 0.0;
                      final reviews = (m['reviewsCount'] as num?)?.toInt() ?? 0;
                      final isFav = favSet.contains(doc.id);
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: PgcardWidget(
                          docId: doc.id,
                          pgtitle: title,
                          pgprice: price.toDouble(),
                          pgimage: fallbackAsset,
                          pgreview:
                              '${rating.toStringAsFixed(1)} ($reviews reviews)',
                          cardUrl: cardUrl,
                          isFavorite: isFav,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cityToUse = _normalizeCity(_selectedCity);
    final otherFixed = kOtherCities.where((c) => c != cityToUse).toList();
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
      body: ListView(
        children: [
          Container(
            height: 125,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(28, 121, 211, 1),
                  Color.fromRGBO(95, 177, 243, 1),
                ],
                stops: [0.0, 0.9],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(35, 35),
                bottomRight: Radius.elliptical(35, 35),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10.0,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomCityDropdown(
                  selectedCity: _selectedCity,
                  onChanged: (city) {
                    setState(() => _selectedCity = city);
                  },
                  cities: _cities,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 12.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MainPage(initialTab: 1),
                    ),
                    (route) => false,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Color.fromRGBO(28, 121, 211, 1),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Search for PG, location…',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: const Text(
              "Popular Near You",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 270,
            child: StreamBuilder<Set<String>>(
              stream: _favs.idsStream(),
              builder: (context, favSnap) {
                final favSet = favSnap.data ?? <String>{};
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('pgRooms')
                      .where('city', isEqualTo: _selectedCity)
                      .snapshots(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final docs = snap.data!.docs;
                    if (docs.isEmpty) {
                      return const Center(child: Text('No PG rooms found'));
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final m = doc.data();
                        final photos =
                            (m['photos'] ?? {}) as Map<String, dynamic>;
                        final cardUrl = (photos['cardUrl'] ?? '') as String?;
                        final title = (m['name'] ?? '') as String;
                        final price = (m['pricePerMonth'] ?? 0) as int;
                        final rating = (m['rating'] as num?)?.toDouble() ?? 0.0;
                        final reviews =
                            (m['reviewsCount'] as num?)?.toInt() ?? 0;
                        final isFav = favSet.contains(doc.id);
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: PgcardWidget(
                            docId: doc.id,
                            pgtitle: title,
                            pgprice: price.toDouble(),
                            pgimage: demoImg,
                            pgreview:
                                '${rating.toStringAsFixed(1)} ($reviews reviews)',
                            cardUrl: cardUrl,
                            isFavorite: isFav,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          for (final c in otherFixed)
            _citySection(context: context, city: c, fallbackAsset: demoImg),
        ],
      ),
    );
  }
}
