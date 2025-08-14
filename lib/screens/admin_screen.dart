import 'package:flutter/material.dart';
import 'package:pg_application/animations/routeanimation.dart';
import 'package:pg_application/screens/addnewpg_screen.dart';
import 'package:pg_application/widgets/admincard_widget.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
              onPressed: () {},
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

            // Search Bar
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

            //Title - Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Exisiting PG Rooms",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                //Add New Button
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
                    // padding: const EdgeInsets.symmetric(vertical: 16),
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

            //Listview For Rooms
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 7,
                itemBuilder: (context, index) {
                  return AdmincardWidget();
                },
              ),
            ),

            // FloatingActionButton(onPressed: () {}),
          ],
        ),
      ),

      //Add New Floating Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, fadeAnimatedRoute(AddEditPgRoomPage()));
        },
        backgroundColor: const Color.fromARGB(255, 28, 121, 211),
        child: Icon(Icons.add, color: Colors.white), // Accessibility hint
      ),
    );
  }
}
