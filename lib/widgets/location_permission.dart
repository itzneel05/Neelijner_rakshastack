import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
class LocationService {
  static Future<bool> _ensureServiceAndPermission() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      await Geolocator.openLocationSettings();
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      return false;
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }
    return true;
  }
  static Future<({String label, String city, String state})> _labelFromLatLng(
    double lat,
    double lng,
  ) async {
    final placemarks = await placemarkFromCoordinates(lat, lng);
    final p = placemarks.first;
    final city = (p.locality ?? '').trim();
    final state = (p.administrativeArea ?? '').trim();
    final parts = <String>[];
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    final label = parts.isNotEmpty ? parts.join(', ') : 'Unknown location';
    return (label: label, city: city, state: state);
  }
  static Future<String?> detectAndSaveToFirestore() async {
    final ok = await _ensureServiceAndPermission();
    if (!ok) return null;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    final users = FirebaseFirestore.instance.collection('users');
    final match = await users.where('authUid', isEqualTo: uid).limit(1).get();
    if (match.docs.isEmpty) {
      return null;
    }
    final userRef = match.docs.first.reference;
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final place = await _labelFromLatLng(pos.latitude, pos.longitude);
    await userRef.set({
      'location': {
        'label': place.label,
        'city': place.city.isNotEmpty ? place.city : null,
        'state': place.state.isNotEmpty ? place.state : null,
        'lat': pos.latitude,
        'lng': pos.longitude,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    }, SetOptions(merge: true));
    return place.label;
  }
}

