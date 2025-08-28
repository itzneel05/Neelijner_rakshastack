import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class AppAvatar extends StatelessWidget {
  final String? photoUrl;
  final DateTime? photoUpdatedAt;
  final String? fullName;
  final String? authUid;
  final String? userDocId;
  final double size;
  final Color? bgColor;
  final Color? textColor;
  final IconData fallbackIcon;
  const AppAvatar.data({
    super.key,
    required this.photoUrl,
    required this.photoUpdatedAt,
    required this.fullName,
    this.size = 40,
    this.bgColor,
    this.textColor,
    this.fallbackIcon = Icons.person,
  }) : authUid = null,
       userDocId = null;
  const AppAvatar.byAuthUid(
    this.authUid, {
    super.key,
    this.size = 40,
    this.bgColor,
    this.textColor,
    this.fallbackIcon = Icons.person,
  }) : photoUrl = null,
       photoUpdatedAt = null,
       fullName = null,
       userDocId = null;
  const AppAvatar.byDocId(
    this.userDocId, {
    super.key,
    this.size = 40,
    this.bgColor,
    this.textColor,
    this.fallbackIcon = Icons.person,
  }) : photoUrl = null,
       photoUpdatedAt = null,
       fullName = null,
       authUid = null;
  @override
  Widget build(BuildContext context) {
    if (photoUrl != null || fullName != null) {
      return _buildCircle(
        _versionedUrl(photoUrl, photoUpdatedAt),
        _initials(fullName),
      );
    }
    if (userDocId != null && userDocId!.isNotEmpty) {
      final stream = FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId)
          .snapshots();
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snap) {
          if (!snap.hasData || !snap.data!.exists) {
            return _buildCircle(null, null);
          }
          final data = snap.data!.data()!;
          return _buildFromMap(data);
        },
      );
    }
    if (authUid != null && authUid!.isNotEmpty) {
      final stream = FirebaseFirestore.instance
          .collection('users')
          .where('authUid', isEqualTo: authUid)
          .limit(1)
          .snapshots();
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snap) {
          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return _buildCircle(null, null);
          }
          final data = snap.data!.docs.first.data();
          return _buildFromMap(data);
        },
      );
    }
    return _buildCircle(null, null);
  }
  Widget _buildFromMap(Map<String, dynamic> data) {
    final url = (data['photoUrl'] as String?)?.trim();
    final ts = data['photoUpdatedAt'];
    final updatedAt = ts is Timestamp ? ts.toDate() : null;
    final name = (data['fullName'] as String?)?.trim();
    final displayUrl = _versionedUrl(url, updatedAt);
    final initials = _initials(name);
    return _buildCircle(displayUrl, initials);
  }
  Widget _buildCircle(String? displayUrl, String? initials) {
    final bg = bgColor ?? Colors.grey[300]!;
    final fg = textColor ?? Colors.grey[700]!;
    return CircleAvatar(
      key: ValueKey(displayUrl ?? initials ?? 'avatar-empty'),
      radius: size / 2,
      backgroundColor: bg,
      backgroundImage: (displayUrl != null && displayUrl.isNotEmpty)
          ? NetworkImage(displayUrl)
          : null,
      child: (displayUrl == null || displayUrl.isEmpty)
          ? (initials != null && initials.isNotEmpty
                ? Text(
                    initials,
                    style: TextStyle(
                      color: fg,
                      fontWeight: FontWeight.w600,
                      fontSize: size * 0.38,
                      letterSpacing: 0.2,
                    ),
                  )
                : Icon(fallbackIcon, size: size * 0.6, color: Colors.grey[500]))
          : null,
    );
  }
  static String _initials(String? name) {
    final parts = (name ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    final a = parts.first[0];
    final b = parts.length > 1 ? parts.last[0] : '';
    return (a + b).toUpperCase();
  }
  static String? _versionedUrl(String? url, DateTime? updatedAt) {
    if (url == null || url.isEmpty) return null;
    final v = updatedAt?.millisecondsSinceEpoch;
    return v != null ? '$url?v=$v' : url;
  }
}

