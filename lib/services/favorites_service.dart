import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import '../models/favorite_design.dart';
//
// class FavoritesService {
//   static const String _key = 'favorites';
//
//   Future<void> saveFavorite(FavoriteDesign design) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> favorites = prefs.getStringList(_key) ?? [];
//     favorites.add(jsonEncode(design.toJson()));
//     await prefs.setStringList(_key, favorites);
//   }
//
//   Future<List<FavoriteDesign>> getFavorites() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> favorites = prefs.getStringList(_key) ?? [];
//     return favorites.map((e) => FavoriteDesign.fromJson(jsonDecode(e))).toList();
//   }
//
//   Future<void> removeFavorite(FavoriteDesign design) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> favorites = prefs.getStringList(_key) ?? [];
//     favorites.removeWhere((e) => jsonDecode(e)['fabricPath'] == design.fabricPath);
//     await prefs.setStringList(_key, favorites);
//
//     if (design.thumbnailPath.isNotEmpty) {
//       final thumbnailFile = File(design.thumbnailPath);
//       if (await thumbnailFile.exists()) {
//         await thumbnailFile.delete();
//       }
//     }
//   }
// }
class FavoritesService {
  static const String _key = 'favorites';

  Future<void> saveFavorite(FavoriteDesign design) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_key) ?? [];
    favorites.add(jsonEncode(design.toJson()));
    await prefs.setStringList(_key, favorites);
  }

  Future<List<FavoriteDesign>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_key) ?? [];
    return favorites.map((e) => FavoriteDesign.fromJson(jsonDecode(e))).toList();
  }

  Future<void> removeFavorite(FavoriteDesign design) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_key) ?? [];

    // Remove based on the unique ID
    favorites.removeWhere((e) => jsonDecode(e)['id'] == design.id);

    await prefs.setStringList(_key, favorites);

    if (design.thumbnailPath.isNotEmpty) {
      final thumbnailFile = File(design.thumbnailPath);
      if (await thumbnailFile.exists()) {
        await thumbnailFile.delete();
      }
    }
  }
}
