import 'package:flutter/material.dart';
import 'package:pg_application/widgets/favorites_service.dart';
class FavoriteIconButton extends StatelessWidget {
  const FavoriteIconButton({
    super.key,
    required this.pgId,
    this.size,
    this.activeColor,
  });
  final String pgId;
  final double? size;
  final Color? activeColor;
  @override
  Widget build(BuildContext context) {
    final favs = FavoritesService();
    return StreamBuilder<bool>(
      stream: favs.isFavoriteStream(pgId),
      builder: (context, snap) {
        final isFav = snap.data ?? false;
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(maxHeight: 24),
          iconSize: size ?? 24,
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border_outlined,
            color: isFav ? (activeColor ?? Colors.red) : Colors.black54,
          ),
          onPressed: () => favs.toggleKnown(pgId, isFav),
          tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
        );
      },
    );
  }
}

