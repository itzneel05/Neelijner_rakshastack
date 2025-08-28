import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pg_application/widgets/favorites_service.dart';
import 'package:pg_application/widgets/pgimageslider.dart';
import 'package:pg_application/widgets/reviewcard_widget.dart';
import 'package:url_launcher/url_launcher.dart';
class ViewDetails extends StatefulWidget {
  final String pgId;
  const ViewDetails({super.key, required this.pgId});
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
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _submittingReview = false;
  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
  Future<void> openSavedWhatsAppLink(String saved) async {
    final hasScheme =
        saved.startsWith('http://') || saved.startsWith('https://');
    final uri = hasScheme ? Uri.parse(saved) : Uri.parse('https://$saved');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) throw 'Could not launch $uri';
  }
  Future<void> dialPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone); 
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }
  Future<void> _submitReview() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a rating')));
      return;
    }
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please write a review')));
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to submit a review')),
      );
      return;
    }
    setState(() {
      _submittingReview = true;
    });
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('authUid', isEqualTo: user.uid)
          .limit(1)
          .get();
      String username = 'Anonymous';
      String userAvatar = 'assets/images/profile.jpg';
      if (userDoc.docs.isNotEmpty) {
        final userData = userDoc.docs.first.data();
        username = userData['fullName'] ?? 'Anonymous';
        userAvatar = userData['photoUrl'] ?? 'assets/images/profile.jpg';
      }
      await FirebaseFirestore.instance.collection('reviews').add({
        'pgdocid': widget.pgId,
        'userid': user.uid,
        'username': username,
        'userAvatar': userAvatar,
        'rating': _selectedRating,
        'reviewText': _reviewController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      final pgDoc = await FirebaseFirestore.instance
          .collection('pgRooms')
          .doc(widget.pgId)
          .get();
      if (pgDoc.exists) {
        final pgData = pgDoc.data()!;
        final currentRating = (pgData['rating'] as num?)?.toDouble() ?? 0.0;
        final reviewsCount = (pgData['reviewsCount'] as num?)?.toInt() ?? 0;
        final newReviewsCount = reviewsCount + 1;
        final newRating =
            ((currentRating * reviewsCount) + _selectedRating) /
            newReviewsCount;
        await FirebaseFirestore.instance
            .collection('pgRooms')
            .doc(widget.pgId)
            .update({'rating': newRating, 'reviewsCount': newReviewsCount});
      }
      setState(() {
        _selectedRating = 0;
        _reviewController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit review: $e')));
    } finally {
      setState(() {
        _submittingReview = false;
      });
    }
  }
  Future<void> sendEmail(String to, {String? subject, String? body}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: to, 
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }
  final favs = FavoritesService();
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
          StreamBuilder<bool>(
            stream: favs.idsStream().map(
              (set) => set.contains(widget.pgId),
            ), 
            builder: (context, snap) {
              final isFav = snap.data ?? false;
              return IconButton(
                onPressed: () => favs.toggleKnown(widget.pgId, isFav),
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border_outlined,
                  color: Colors.white,
                ),
                tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('pgRooms')
            .doc(widget.pgId)
            .snapshots(), 
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.data!.exists) {
            return const Center(child: Text('This listing is unavailable'));
          }
          final m = snap.data!.data()!;
          final price = (m['pricePerMonth'] as num?)?.toInt() ?? 0;
          final title = (m['name'] as String?) ?? 'Untitled';
          final isFurnished = (m['isFurnished'] as bool?) ?? false;
          final city = (m['city'] as String?) ?? 'Unknown';
          final rating = (m['rating'] as num?)?.toDouble() ?? 0.0;
          final reviews = (m['reviewsCount'] as num?)?.toInt() ?? 0;
          final occupancy = (m['occupancy'] as String?) ?? 'N/A';
          final address =
              (m['fulllocation'] as String?) ?? 'Address not available';
          final photos = (m['photos'] ?? {}) as Map<String, dynamic>;
          final description =
              (m['description'] as String?) ?? 'No description available';
          final sliderUrls =
              (photos['galleryUrls'] as List?)?.cast<String>() ??
              const <String>[];
          final amenities =
              (m['amenities'] as List?)?.cast<String>() ?? const <String>[];
          final ownernumber = (m['ownerContact']['phone'] as String?) ?? 'N/A';
          final owneremail = (m['ownerContact']['email'] as String?) ?? 'N/A';
          final ownerwhatsapp =
              (m['ownerContact']['whatsappLink'] as String?) ?? 'N/A';
          return SingleChildScrollView(
            child: Column(
              children: [
                PGImageSlider(
                  images: sliderUrls.isNotEmpty ? sliderUrls : images,
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Card(
                    elevation: 0.5,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '$title ${isFurnished ? "- [Furnished]" : ""}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '$city, Gujarat',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color.fromARGB(255, 127, 127, 127),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
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
                                  "₹$price/mo",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber),
                                    const SizedBox(width: 3),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "(${reviews.toString()})",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Occupancy: ${occupancy.capitalizeFirst()}",
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
                            itemCount: (amenities.isEmpty
                                ? 3
                                : amenities.length.clamp(0, 6)),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(12),
                            itemBuilder: (context, index) {
                              final item = (amenities.isEmpty
                                  ? ['hehe']
                                  : amenities)[index];
                              IconData getIconForItem(String s) {
                                switch (s.toLowerCase()) {
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
                              return Container(
                                decoration: BoxDecoration(
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
                              IconButton(
                                onPressed: () {
                                  dialPhone(ownernumber);
                                },
                                icon: Icon(Icons.phone),
                              ),
                              IconButton(
                                onPressed: () {
                                  openSavedWhatsAppLink(ownerwhatsapp);
                                },
                                icon: Icon(Icons.message),
                              ),
                              IconButton(
                                onPressed: () {
                                  sendEmail(owneremail);
                                },
                                icon: Icon(Icons.email),
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
                            description,
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
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  address,
                                  maxLines: 5,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 130, 130, 130),
                                    fontSize: 13.5,
                                  ),
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
                            children: List.generate(5, (index) {
                              return IconButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedRating = index + 1;
                                  });
                                },
                                icon: Icon(
                                  index < _selectedRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 32,
                                  color: index < _selectedRating
                                      ? Colors.amber
                                      : Colors.grey,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(),
                            child: TextFormField(
                              controller: _reviewController,
                              maxLines: 4,
                              style: TextStyle(),
                              decoration: InputDecoration(
                                hintText: "Share Your Experience...",
                                hintStyle: TextStyle(color: Colors.grey),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      214,
                                      214,
                                      214,
                                    ),
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: const Color.fromARGB(
                                      255,
                                      214,
                                      214,
                                      214,
                                    ),
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
                              onPressed: _submittingReview
                                  ? null
                                  : _submitReview,
                              child: _submittingReview
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text("Submit"),
                            ),
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
                            "Reviews",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('reviews')
                                .where('pgdocid', isEqualTo: widget.pgId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
                                      'Error loading reviews: ${snapshot.error}',
                                    ),
                                  ),
                                );
                              }
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
                                      'No reviews yet. Be the first to review!',
                                    ),
                                  ),
                                );
                              }
                              final reviewDocs = snapshot.data!.docs;
                              return Container(
                                height:
                                    400, 
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      ClampingScrollPhysics(), 
                                  itemCount: reviewDocs.length,
                                  itemBuilder: (context, index) {
                                    final doc = reviewDocs[index];
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    final timestamp =
                                        data['createdAt'] as Timestamp?;
                                    final timeAgo = timestamp != null
                                        ? _getTimeAgo(timestamp.toDate())
                                        : 'Recently';
                                    return ReviewCard(
                                      username: data['username'] ?? 'Anonymous',
                                      userAvatar:
                                          data['userAvatar'] ??
                                          'assets/images/profile.jpg',
                                      rating:
                                          (data['rating'] as num?)
                                              ?.toDouble() ??
                                          0.0,
                                      reviewText: data['reviewText'] ?? '',
                                      timeAgo: timeAgo,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          );
        },
      ),
    );
  }
}
extension StringCasingX on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    final first = this[0].toUpperCase();
    final rest = substring(1).toLowerCase();
    return '$first$rest';
  }
}
String _getTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  if (difference.inDays > 365) {
    return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? 'Year' : 'Years'} Ago';
  } else if (difference.inDays > 30) {
    return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'Month' : 'Months'} Ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'Day' : 'Days'} Ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'Hour' : 'Hours'} Ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'Minute' : 'Minutes'} Ago';
  } else {
    return 'Just Now';
  }
}

