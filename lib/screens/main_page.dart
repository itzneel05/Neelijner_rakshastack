import 'package:flutter/material.dart';
import 'package:pg_application/screens/fav_screen.dart';
import 'package:pg_application/screens/home_screen.dart';
import 'package:pg_application/screens/profile_screen.dart';
import 'package:pg_application/screens/search_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainPage extends StatefulWidget {
  final int initialTab;
  const MainPage({super.key, this.initialTab = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialTab;
  }

  void switchTab(int index) {
    setState(() {
      _selected = index;
    });
  }

  final List<Widget> _pages = [
    const Home(),
    const Search(),
    const Fav(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selected, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color.fromARGB(255, 212, 212, 212)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: StylishBottomBar(
            // backgroundColor: const Color.fromARGB(255, 223, 235, 248),
            currentIndex: _selected,

            onTap: (index) {
              setState(() {
                _selected = index;
              });
            },
            items: [
              BottomBarItem(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                selectedColor: Colors.blue,
                title: const Text('Home'),
              ),
              BottomBarItem(
                icon: const Icon(Icons.search_outlined),
                selectedIcon: const Icon(Icons.search),
                selectedColor: Colors.blue,

                title: const Text('Search'),
              ),
              BottomBarItem(
                icon: const Icon(Icons.favorite_border),
                selectedIcon: const Icon(Icons.favorite),
                selectedColor: Colors.blue,

                title: const Text('Favorites'),
              ),
              BottomBarItem(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                selectedColor: Colors.blue,

                title: const Text('Profile'),
              ),
            ],
            option: AnimatedBarOptions(
              iconSize: 24,
              barAnimation: BarAnimation.fade,
              iconStyle: IconStyle.animated,
              opacity: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
