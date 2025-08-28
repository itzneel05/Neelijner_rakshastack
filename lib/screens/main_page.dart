import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pg_application/screens/fav_screen.dart';
import 'package:pg_application/screens/home_screen.dart';
import 'package:pg_application/screens/profile_screen.dart';
import 'package:pg_application/screens/search_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:pg_application/widgets/location_permission.dart';
class MainPage extends StatefulWidget {
  final int initialTab;
  const MainPage({super.key, this.initialTab = 0});
  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  int _selected = 0;
  bool _promptedThisSession = false;
  bool _updatingLocation = false;
  @override
  void initState() {
    super.initState();
    _selected = widget.initialTab;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _maybePromptForLocation(),
    );
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
  Future<void> _maybePromptForLocation() async {
    if (_promptedThisSession) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final users = FirebaseFirestore.instance.collection('users');
    final q = await users.where('authUid', isEqualTo: uid).limit(1).get();
    if (q.docs.isEmpty) return; 
    final data = q.docs.first.data();
    final location = data['location'] as Map<String, dynamic>?;
    final hasLabel =
        (location?['label'] is String) &&
        (location?['label'] as String).trim().isNotEmpty;
    if (hasLabel) return; 
    _promptedThisSession = true;
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enable location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Allow location to show your city and state on your profile.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Not now'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _updatingLocation
                            ? null
                            : () async {
                                setState(() => _updatingLocation = true);
                                try {
                                  final label =
                                      await LocationService.detectAndSaveToFirestore();
                                  if (!mounted) return;
                                  if (label != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Location set: $label'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Location not set'),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to set location: $e',
                                      ),
                                    ),
                                  );
                                } finally {
                                  if (mounted)
                                    setState(() => _updatingLocation = false);
                                  if (mounted) Navigator.pop(context);
                                }
                              },
                        child: _updatingLocation
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Allow location'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
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

