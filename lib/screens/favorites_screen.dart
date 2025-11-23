import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../services/favorites_service.dart';
import '../models/favorite_design.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<FavoriteDesign>> _future;

  @override
  void initState() {
    super.initState();
    _future = FavoritesService().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<List<FavoriteDesign>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loadingShimmer();
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _emptyState();
          }

          final favorites = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final design = favorites[index];

              return _favoriteCard(design, index);
            },
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ Favorite item card with glass effect + animation
  // ---------------------------------------------------------------------------
  Widget _favoriteCard(FavoriteDesign design, int index) {
    return AnimatedScale(
      scale: 1,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 400),

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white.withOpacity(0.8),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                offset: const Offset(0, 4),
                color: Colors.black.withOpacity(0.08),
              ),
            ],
          ),

          child: ListTile(
            contentPadding: const EdgeInsets.all(12),

            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(design.thumbnailPath),
                width: 65,
                height: 65,
                fit: BoxFit.cover,
              ),
            ),

            title: Text(
              design.overlayAsset.split('/').last.replaceAll('.png', ''),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Text(
              "Tap to use this design",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),

            trailing: IconButton(
              icon: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.redAccent,
                size: 28,
              ),
              onPressed: () async {
                final isConfirmed = await _confirmDelete(context);
                if (isConfirmed) {
                  await _removeFavorite(design);
                }
              },
            ),

            onTap: () => Navigator.pop(context, design),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ Custom delete confirmation dialog
  // ---------------------------------------------------------------------------
  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          "Remove Favorite",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Are you sure you want to remove this item?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text("Delete"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ Shimmer loading effect
  // ---------------------------------------------------------------------------
  Widget _loadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ Empty state UI
  // ---------------------------------------------------------------------------
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_border_rounded,
            size: 80,
            color: Colors.grey.shade500,
          ),
          const SizedBox(height: 16),
          const Text(
            "No Favorites Yet",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Your saved designs will appear here.",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ Remove favorite + refresh UI
  // ---------------------------------------------------------------------------
  Future<void> _removeFavorite(FavoriteDesign design) async {
    await FavoritesService().removeFavorite(design);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Removed from Favorites"),
        behavior: SnackBarBehavior.floating,
      ),
    );

    setState(() {
      _future = FavoritesService().getFavorites();
    });
  }
}
