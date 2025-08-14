import 'package:flutter/material.dart';
import 'package:pg_application/animations/routeanimation.dart';
import 'package:pg_application/screens/view_details.dart';

class PgcardWidget extends StatelessWidget {
  final String pgtitle;
  final double pgprice;
  final String pgimage;

  const PgcardWidget({
    super.key,
    required this.pgtitle,
    required this.pgprice,
    required this.pgimage,
  });

  final String demoImg = 'assets/images/pg_01.jpg';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, fadeAnimatedRoute(ViewDetails()));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: SizedBox(
          width: 220,
          // height: 50,
          // decoration: BoxDecoration(color: Colors.amber),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image(
                  image: AssetImage(pgimage),
                  width: 220,
                  height: 146,
                  fit: BoxFit.cover,
                ),
              ),
              // const SizedBox(height: 4),
              const SizedBox(height: 6),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        pgtitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    IconButton(
                      icon: Icon(Icons.favorite_border_outlined),
                      onPressed: () {},
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "₹$pgprice/Month",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.lightBlue,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      "4.8 (25 reviews)",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
