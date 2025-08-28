import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pg_application/animations/routeanimation.dart';
import 'package:pg_application/screens/addnewpg_screen.dart';
class AdmincardWidget extends StatelessWidget {
  final String docId;
  final String name;
  final String city;
  final int price;
  final List<String> amenities;
  const AdmincardWidget({
    super.key,
    required this.name,
    required this.city,
    required this.price,
    required this.amenities,
    required this.docId,
  });
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3),
                  Text(
                    "City: $city | Price: ₹$price/month",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 9),
                  Row(
                    children: amenities.take(3).map((amenity) {
                      IconData? icon;
                      switch (amenity.toLowerCase()) {
                        case 'wifi':
                          icon = Icons.wifi;
                          break;
                        case 'ac':
                          icon = Icons.ac_unit;
                          break;
                        case 'parking':
                          icon = Icons.local_parking;
                          break;
                        case 'housekeeping':
                          icon = Icons.cleaning_services;
                          break;
                        case 'laundry':
                          icon = Icons.local_laundry_service;
                          break;
                        case 'food':
                          icon = Icons.restaurant;
                          break;
                        default:
                          icon = Icons.check_circle_outline;
                      }
                      return Padding(
                        padding: EdgeInsets.only(right: 7),
                        child: Icon(icon, color: Colors.grey, size: 16),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Column(
              children: [
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
                  onPressed: () async {
                    final docSnapshot = await FirebaseFirestore.instance
                        .collection('pgRooms')
                        .doc(docId)
                        .get();
                    final data = docSnapshot.data();
                    if (data == null) return; 
                    Navigator.push(
                      context,
                      fadeAnimatedRoute(
                        AddEditPgRoomPage(docId: docId, initialData: data),
                      ),
                    );
                  },
                  child: Text("  Edit  "),
                ),
                SizedBox(height: 10),
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

