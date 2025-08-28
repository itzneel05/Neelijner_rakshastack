import 'package:flutter/material.dart';
import 'package:pg_application/animations/routeanimation.dart';
import 'package:pg_application/screens/view_details.dart';
import 'package:pg_application/widgets/fav_icon.dart';
class PglistingWidget extends StatefulWidget {
  final String docId;
  final String name;
  final String city;
  final int pricePerMonth;
  final List<String> amenities;
  final String? cardUrl;
  final double rating;
  const PglistingWidget({
    super.key,
    required this.docId,
    required this.name,
    required this.city,
    required this.pricePerMonth,
    required this.amenities,
    this.cardUrl,
    this.rating = 0.0,
  });
  @override
  State<PglistingWidget> createState() => _PglistingWidgetState();
}
class _PglistingWidgetState extends State<PglistingWidget> {
  bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final shownAmenities = widget.amenities.take(3).toList();
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
                child: (widget.cardUrl == null || widget.cardUrl!.isEmpty)
                    ? Image.asset(
                        'assets/images/pg_01.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ) 
                    : Image.network(
                        widget.cardUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        loadingBuilder: (ctx, child, prog) => prog == null
                            ? child
                            : SizedBox(
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ), 
                        errorBuilder: (_, __, ___) => Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image),
                        ), 
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
                                widget.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() => _isFavorite = !_isFavorite);
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(maxHeight: 24),
                              icon: FavoriteIconButton(pgId: widget.docId),
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
                          "${widget.city}, Gujarat",
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
                        "₹${widget.pricePerMonth} / Month",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.only(left: 2),
                      child: Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color: index < widget.rating
                                  ? Colors.amber
                                  : const Color.fromARGB(255, 207, 207, 207),
                              size: 26,
                            );
                          }),
                          const SizedBox(width: 4),
                          Text(
                            widget.rating.toStringAsFixed(1),
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
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Wrap(
                  spacing: 10, 
                  runSpacing: 6, 
                  children: shownAmenities.map((a) {
                    IconData icon;
                    switch (a.toLowerCase()) {
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
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: Colors.grey, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          a,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6E6E6E),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 140,
                height: 40,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1C79D3),
                    side: const BorderSide(color: Color(0xFF1C79D3)),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      fadeAnimatedRoute(ViewDetails(pgId: widget.docId)),
                    );
                  },
                  child: const Text("View Details"),
                ),
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

