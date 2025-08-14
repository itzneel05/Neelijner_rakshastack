import 'package:flutter/material.dart';
import 'package:pg_application/animations/routeanimation.dart';
import 'package:pg_application/screens/addnewpg_screen.dart';

class AdmincardWidget extends StatefulWidget {
  const AdmincardWidget({super.key});

  @override
  State<AdmincardWidget> createState() => _AdmincardWidgetState();
}

class _AdmincardWidgetState extends State<AdmincardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Left Side - Home Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.home, color: Colors.grey.shade600, size: 32),
            ),
            SizedBox(width: 18),

            // Middle Side - Title/Description/Ametitis
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //PG Room Title
                  Text(
                    "Demo PG", // Change to dynamic value
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3),
                  //Description
                  Text(
                    "City: Surat, Gujarat | Price: ₹8,500/month", // Dynamic as needed
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 9),
                  //Amenities
                  Row(
                    children: [
                      Icon(Icons.wifi, color: Colors.grey, size: 16),
                      SizedBox(width: 7),
                      Icon(Icons.ac_unit, color: Colors.grey, size: 16),
                    ],
                  ),
                ],
              ),
            ),

            // Right Side - Edit/Delete Button
            Column(
              children: [
                //Edit Button
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF1C79D3)),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    foregroundColor: Color(0xFF1C79D3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      fadeAnimatedRoute(AddEditPgRoomPage()),
                    );
                  },
                  child: Text("  Edit  "),
                ),
                SizedBox(height: 10),
                //Delete Button
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
