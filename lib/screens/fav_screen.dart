import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' show Rx;
import 'package:pg_application/widgets/avatar_widget.dart';
import 'package:pg_application/widgets/favorites_service.dart';
import 'package:pg_application/widgets/favcard_widget.dart'; 
class Fav extends StatelessWidget {
  const Fav({super.key});
  static const _chunkSize = 10;
  List<List<String>> _chunkIds(List<String> ids) {
    final chunks = <List<String>>[];
    for (var i = 0; i < ids.length; i += _chunkSize) {
      chunks.add(
        ids.sublist(
          i,
          i + _chunkSize > ids.length ? ids.length : i + _chunkSize,
        ),
      );
    }
    return chunks;
  }
  @override
  Widget build(BuildContext context) {
    final favs = FavoritesService(); 
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(62.0),
        child: AppBar(
          elevation: 2.5,
          shadowColor: Colors.black,
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(25, 118, 210, 1),
          title: const Text(
            "My Favorites",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: AppAvatar.byAuthUid(
                FirebaseAuth.instance.currentUser?.uid ?? '',
                size: 36,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<Set<String>>(
        stream: favs.idsStream(), 
        builder: (context, favSnap) {
          if (!favSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final ids = favSnap.data!.toList();
          if (ids.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.favorite_border_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No favorites yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          if (ids.length <= _chunkSize) {
            final stream = FirebaseFirestore.instance
                .collection('pgRooms')
                .where(FieldPath.documentId, whereIn: ids)
                .snapshots();
            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: stream,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data!.docs;
                return _FavoritesGrid(docs: docs);
              },
            );
          }
          final chunks = _chunkIds(ids);
          final streams = chunks
              .map(
                (chunk) => FirebaseFirestore.instance
                    .collection('pgRooms')
                    .where(FieldPath.documentId, whereIn: chunk)
                    .snapshots()
                    .map((qs) => qs.docs),
              )
              .toList();
          final combined =
              Rx.combineLatestList<
                List<QueryDocumentSnapshot<Map<String, dynamic>>>
              >(streams);
          return StreamBuilder<
            List<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
          >(
            stream: combined,
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final flat = snap.data!.expand((e) => e).toList();
              return _FavoritesGrid(docs: flat);
            },
          );
        },
      ),
    );
  }
}
class _FavoritesGrid extends StatelessWidget {
  const _FavoritesGrid({required this.docs});
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: docs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.66,
        ),
        itemBuilder: (context, index) {
          final doc = docs[index];
          final m = doc.data();
          final photos = (m['photos'] ?? {}) as Map<String, dynamic>;
          final cardUrl =
              (photos['cardUrl'] ?? '')
                  as String?; 
          final name = (m['name'] ?? '') as String;
          final city = (m['city'] ?? '') as String;
          final state = (m['state'] ?? '') as String? ?? '';
          final price = (m['pricePerMonth'] ?? 0).toString();
          final rating = (m['rating'] as num?)?.toDouble() ?? 0.0;
          return PropertyCard(
            imageUrl: cardUrl?.isNotEmpty == true
                ? cardUrl!
                : 'assets/images/pg_01.jpg',
            title: name,
            location: '$city, Gujarat',
            price: '₹$price/mo',
            rating: rating,
            isFavorite: true,
            pgId: doc.id,
          );
        },
      ),
    );
  }
}

