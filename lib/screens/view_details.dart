import 'package:flutter/material.dart';
import 'package:pg_application/widgets/pgimageslider.dart';
import 'package:pg_application/widgets/reviewcard_widget.dart';

class ViewDetails extends StatefulWidget {
  const ViewDetails({super.key});

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  final List<String> images = [
    'assets/images/pg_room_01.jpeg',
    'assets/images/pg_room_02.jpeg',
    'assets/images/pg_room_03.jpeg',
  ];

  List<String> pgItems = [
    'WiFi',
    'AC',
    'Parking',
    'Housekeeping',
    'Laundry',
    'Food',
  ];

  @override
  Widget build(BuildContext context) {
    List<String> fixedItems =
        pgItems.length > 6 ? pgItems.sublist(0, 6) : List.from(pgItems)
          ..addAll(List.filled(6 - pgItems.length, 'N/A'));

    IconData getIconForItem(String item) {
      switch (item.toLowerCase()) {
        case 'wifi':
          return Icons.wifi;
        case 'ac':
          return Icons.ac_unit;
        case 'parking':
          return Icons.local_parking;
        case 'housekeeping':
          return Icons.cleaning_services;
        case 'laundry':
          return Icons.local_laundry_service;
        case 'food':
          return Icons.dining;
        default:
          return Icons.info_outline;
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 2.5,
        shadowColor: Colors.black,
        backgroundColor: Color.fromRGBO(25, 118, 210, 1),
        title: Text(
          "Room Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_border_outlined, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PGImageSlider(images: images),
            SizedBox(height: 8),
            Container(
              // height: 80,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                elevation: 0.5,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹4000/mo",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.blue,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber),
                                Text(
                                  "4.8",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "(25)",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Occupancy: Double",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        "Amenities",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.2,
                            ),
                        itemCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(12),
                        itemBuilder: (context, index) {
                          String item = fixedItems[index];
                          return Container(
                            decoration: BoxDecoration(
                              // color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  getIconForItem(item),
                                  color: Colors.grey,
                                  size: 30,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Contact Owner ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.phone)),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.message),
                          ),
                          IconButton(onPressed: () {}, icon: Icon(Icons.email)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        style: TextStyle(
                          color: const Color.fromARGB(255, 130, 130, 130),
                        ),
                        "This room offers a comfortable and convenient living space, perfect for students or young professionals. It includes essential amenities and is located in a safe and accessible area of Surat.",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Location",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.pin_drop,
                            color: Color.fromARGB(255, 130, 130, 130),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "123, Harinagar-2, Surat, Gujarat - 394210",
                            style: TextStyle(
                              color: Color.fromARGB(255, 130, 130, 130),
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Write A Review",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.star_border,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                          // const SizedBox(width: 6),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.star_border,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                          // const SizedBox(width: 6),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.star_border,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                          // const SizedBox(width: 6),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.star_border,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                          // const SizedBox(width: 6),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.star_border,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(),
                        child: TextFormField(
                          maxLines: 4,

                          style: TextStyle(),
                          decoration: InputDecoration(
                            hint: Text(
                              "Share Your Experience...",
                              style: TextStyle(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: const Color.fromARGB(255, 214, 214, 214),
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: const Color.fromARGB(255, 214, 214, 214),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Submit"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ReviewCard(
              username: "Neel Ijner",
              userAvatar: 'assets/images/profile.jpg',
              rating: 4,
              reviewText: 'Great Place!',
              timeAgo: '3 Days Ago',
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
