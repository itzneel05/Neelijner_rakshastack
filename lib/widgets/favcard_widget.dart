import 'package:flutter/material.dart';
import 'package:pg_application/animations/routeanimation.dart';
import 'package:pg_application/screens/view_details.dart';
import 'package:pg_application/widgets/fav_icon.dart';

class PropertyCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String price;
  final double rating;
  final bool isFavorite;
  final String pgId;
  const PropertyCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.pgId,
    this.isFavorite = false,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, fadeAnimatedRoute(ViewDetails(pgId: pgId)));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 130,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 40),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: FavoriteIconButton(pgId: pgId),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      location,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
