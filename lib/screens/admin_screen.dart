import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pg_application/animations/routeanimation.dart';
import 'package:pg_application/screens/addnewpg_screen.dart';
import 'package:pg_application/screens/login_screen.dart';
import 'package:pg_application/widgets/admincard_widget.dart';
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}
class _AdminScreenState extends State<AdminScreen> {
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut(); 
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully!'),
          ), 
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ), 
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error logging out: $e')));
      }
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
            "Admin Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _logout,
              icon: Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 210, 210, 210),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Search PG by name or city',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onSubmitted: (query) {},
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Exisiting PG Rooms",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      fadeAnimatedRoute(AddEditPgRoomPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 39, 126, 212),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Add New',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pgRooms')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No PG rooms available'));
                  }
                  final rooms = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final doc = rooms[index];
                      final docId = doc.id;
                      final data = doc.data()! as Map<String, dynamic>;
                      return AdmincardWidget(
                        docId: docId,
                        name: data['name'] ?? 'Unnamed PG',
                        city: data['city'] ?? '',
                        price: data['pricePerMonth'] ?? 0,
                        amenities: List<String>.from(data['amenities'] ?? []),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, fadeAnimatedRoute(AddEditPgRoomPage()));
        },
        backgroundColor: const Color.fromARGB(255, 28, 121, 211),
        child: Icon(Icons.add, color: Colors.white), 
      ),
    );
  }
}

