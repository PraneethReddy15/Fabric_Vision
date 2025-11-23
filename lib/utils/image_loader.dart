import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class ImageLoader {
  static Future<ui.Image> loadImageFromFile(File file) async {
    final Uint8List data = await file.readAsBytes();
    return await _decodeImageFromList(data);
  }

  static Future<ui.Image> loadImageFromAssets(String assetPath) async {
    final ByteData data = await rootBundle.load('assets/$assetPath');
    return await _decodeImageFromList(data.buffer.asUint8List());
  }

  static Future<ui.Image> _decodeImageFromList(Uint8List data) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(data, (ui.Image img) => completer.complete(img));
    return completer.future;
  }
}
