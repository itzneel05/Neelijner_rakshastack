import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FavoritesService {
  FavoritesService({
    FirebaseFirestore? db,
    FirebaseAuth? auth,
    this.fieldName = 'favoritePgIds',
  }) : _db = db ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  final String fieldName;
  DocumentReference<Map<String, dynamic>> _userDoc() =>
      _db.collection('users').doc(_auth.currentUser!.uid); 
  Stream<Set<String>> idsStream() {
    return _userDoc().snapshots().map((doc) {
      final arr = (doc.data()?[fieldName] as List<dynamic>?) ?? const [];
      return arr.map((e) => e.toString()).toSet();
    });
  }
  Stream<bool> isFavoriteStream(String pgId) =>
      idsStream().map((set) => set.contains(pgId)).distinct();
  Future<void> add(String pgId) => _userDoc().set({
    fieldName: FieldValue.arrayUnion([pgId]),
  }, SetOptions(merge: true));
  Future<void> remove(String pgId) => _userDoc().set({
    fieldName: FieldValue.arrayRemove([pgId]),
  }, SetOptions(merge: true));
  Future<void> toggleKnown(String pgId, bool isFavorite) =>
      isFavorite ? remove(pgId) : add(pgId);
}

