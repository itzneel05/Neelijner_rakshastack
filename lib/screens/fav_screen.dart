import 'package:flutter/material.dart';
import 'package:pg_application/screens/main_page.dart';
import 'package:pg_application/widgets/favcard_widget.dart';

class Fav extends StatefulWidget {
  const Fav({super.key});

  @override
  State<Fav> createState() => _FavState();
}

class _FavState extends State<Fav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(62.0),
        child: AppBar(
          elevation: 2.5,
          shadowColor: Colors.black,
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Color.fromRGBO(25, 118, 210, 1),
          title: Text(
            "My Favorites",
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // crossAxisSpacing: 12,
            // mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            return PropertyCard(
              imageUrl: "assets/images/pg_01.jpg",
              title: "Demo PG Room",
              location: "Surat, Gujarat",
              price: "₹4000/mo",
              rating: 4.8,
              isFavorite: true,
            );
          },
        ),
      ),
    );
  }
}
