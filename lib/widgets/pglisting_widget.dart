import 'package:flutter/material.dart';
import 'package:pg_application/animations/routeanimation.dart';
import 'package:pg_application/screens/view_details.dart';

class PglistingWidget extends StatefulWidget {
  const PglistingWidget({super.key});

  @override
  State<PglistingWidget> createState() => _PglistingWidgetState();
}

class _PglistingWidgetState extends State<PglistingWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/pg_01.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      height: 22,
                      child: MediaQuery.removePadding(
                        context: context,
                        removeRight: true,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "Demo Paying Guest/PG Room ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(maxHeight: 24),
                              icon: Icon(Icons.favorite_border, size: 28),
                            ),
                            const SizedBox(width: 1),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.pin_drop, size: 20, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          "Surat, Gujarat",
                          style: TextStyle(
                            fontSize: 13,
                            color: const Color.fromARGB(255, 118, 118, 118),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.only(left: 2),
                      child: Text(
                        "₹7000 / Month",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: EdgeInsets.only(left: 2),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 26),
                          Icon(Icons.star, color: Colors.amber, size: 26),
                          Icon(Icons.star, color: Colors.amber, size: 26),
                          Icon(Icons.star, color: Colors.amber, size: 26),
                          Icon(
                            Icons.star,
                            color: const Color.fromARGB(255, 207, 207, 207),
                            size: 26,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "4.2",
                            style: TextStyle(
                              fontSize: 13,
                              color: const Color.fromARGB(255, 130, 130, 130),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(Icons.wifi, color: Colors.grey, size: 18),
                  const SizedBox(width: 2),
                  Text(
                    "Wifi",
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 110, 110, 110),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.ac_unit, color: Colors.grey, size: 18),
                  const SizedBox(width: 2),
                  Text(
                    "AC",
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 110, 110, 110),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.local_parking, color: Colors.grey, size: 18),
                  const SizedBox(width: 2),
                  Text(
                    "Parking",
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 110, 110, 110),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xFF1C79D3),
                  side: const BorderSide(color: Color(0xFF1C79D3)),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, fadeAnimatedRoute(ViewDetails()));
                },
                child: const Text("View Details"),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
