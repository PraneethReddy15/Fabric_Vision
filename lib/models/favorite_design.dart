// import 'dart:ui';
//
// class FavoriteDesign {
//   final String fabricPath;
//   final String overlayAsset;
//   final String thumbnailPath;
//   final double tileScale;
//   final Color? tintColor;
//
//   FavoriteDesign({
//     required this.fabricPath,
//     required this.overlayAsset,
//     required this.thumbnailPath,
//     required this.tileScale,
//     this.tintColor,
//   });
//
//   Map<String, dynamic> toJson() => {
//     'fabricPath': fabricPath,
//     'overlayAsset': overlayAsset,
//     'thumbnailPath': thumbnailPath,
//     'tileScale': tileScale,
//     'tintColor': tintColor?.value,
//   };
//
//   factory FavoriteDesign.fromJson(Map<String, dynamic> json) {
//     return FavoriteDesign(
//       fabricPath: json['fabricPath'] as String,
//       overlayAsset: json['overlayAsset'] as String,
//       thumbnailPath: json['thumbnailPath'] as String? ?? '',
//       tileScale: json['tileScale'] as double? ?? 1.0,
//       tintColor: json['tintColor'] != null ? Color(json['tintColor'] as int) : null,
//     );
//   }
// }


import 'package:flutter/material.dart';

class FavoriteDesign {
  final String id; // Add a unique identifier
final String fabricPath;
final String overlayAsset;
final String thumbnailPath;
final double tileScale;
final Color? tintColor;

FavoriteDesign({
required this.id,
required this.fabricPath,
required this.overlayAsset,
required this.thumbnailPath,
required this.tileScale,
this.tintColor,
});

Map<String, dynamic> toJson() => {
'id': id,
'fabricPath': fabricPath,
'overlayAsset': overlayAsset,
'thumbnailPath': thumbnailPath,
'tileScale': tileScale,
'tintColor': tintColor?.value,
};

factory FavoriteDesign.fromJson(Map<String, dynamic> json) {
return FavoriteDesign(
id: json['id'],
fabricPath: json['fabricPath'] as String,
overlayAsset: json['overlayAsset'] as String,
thumbnailPath: json['thumbnailPath'] as String? ?? '',
tileScale: json['tileScale'] as double? ?? 1.0,
tintColor: json['tintColor'] != null ? Color(json['tintColor'] as int) : null,
);
}
}