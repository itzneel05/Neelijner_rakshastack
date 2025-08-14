import 'package:flutter/material.dart';
import 'package:pg_application/screens/main_page.dart';
// import 'package:pg_application/screens/profile_screen.dart';
import 'package:pg_application/widgets/pgcard_widget.dart';
import 'package:pg_application/widgets/select_city_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // String _selectedCity = '';
  String? _selectedCity;
  final String demoImg = 'assets/images/pg_01.jpg';

  final List<String> _cities = ['Surat', 'Ahmedabad', 'Vadodara', 'Mumbai'];

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
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        // padding: const EdgeInsets.symmetric(horizontal: 16),
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
                // bottomRight: Radius.circular(40),
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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return PgcardWidget(
                  pgtitle: 'Demo Paying Guest/PG Room',
                  pgprice: 4000.00,
                  pgimage: demoImg,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: const Text(
              "Surat City",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return PgcardWidget(
                  pgtitle: 'Demo PG Room',
                  pgprice: 4000.00,
                  pgimage: demoImg,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: const Text(
              "Random Street City",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return PgcardWidget(
                  pgtitle: 'Demo Paying Guest/PG Room',
                  pgprice: 4000.00,
                  pgimage: demoImg,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
