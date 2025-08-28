import 'package:flutter/material.dart';
import 'package:pg_application/animations/routeanimation.dart';
import 'package:pg_application/screens/view_details.dart';
import 'package:pg_application/widgets/fav_icon.dart';
class PgcardWidget extends StatelessWidget {
  final String docId;
  final String pgtitle;
  final double pgprice;
  final String pgimage; 
  final String pgreview; 
  final String? cardUrl; 
  final bool isFavorite; 
  const PgcardWidget({
    super.key,
    required this.pgtitle,
    required this.pgprice,
    required this.pgimage,
    required this.pgreview,
    this.cardUrl,
    required this.docId,
    required this.isFavorite,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.push(context, fadeAnimatedRoute(ViewDetails(pgId: docId))),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: SizedBox(
          width: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: (cardUrl == null || cardUrl!.isEmpty)
                    ? Image.asset(
                        pgimage,
                        width: 220,
                        height: 146,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        cardUrl!,
                        width: 220,
                        height: 146,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          pgimage,
                          width: 220,
                          height: 146,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        pgtitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    FavoriteIconButton(pgId: docId),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "₹$pgprice/Month",
                  style: const TextStyle(
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
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      pgreview, 
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
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

