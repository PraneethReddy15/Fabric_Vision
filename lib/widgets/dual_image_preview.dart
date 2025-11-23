import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/image_loader.dart';

class DualImagePreview extends StatefulWidget {
  final File fabricFile;
  final String overlayAsset;
  final double tileScale;
  final Color? tintColor;

  const DualImagePreview({
    super.key,
    required this.fabricFile,
    required this.overlayAsset,
    required this.tileScale,
    this.tintColor,
  });

  @override
  DualImagePreviewState createState() => DualImagePreviewState();
}

class DualImagePreviewState extends State<DualImagePreview> {
  ui.Image? _fabricImage;
  ui.Image? _overlayImage;
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  void didUpdateWidget(DualImagePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fabricFile != widget.fabricFile ||
        oldWidget.overlayAsset != widget.overlayAsset ||
        oldWidget.tileScale != widget.tileScale ||
        oldWidget.tintColor != widget.tintColor) {
      _loadImages();
    }
  }

  Future<void> _loadImages() async {
    _fabricImage = await ImageLoader.loadImageFromFile(widget.fabricFile);
    _overlayImage = await ImageLoader.loadImageFromAssets(widget.overlayAsset);
    setState(() {});
  }

  Future<File?> captureImage() async {
    try {
      RenderRepaintBoundary boundary =
          _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Use safe pixelRatio to avoid GPU issues
      ui.Image image = await boundary.toImage(pixelRatio: 1.5);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final buffer = byteData.buffer.asUint8List();
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/fabric_preview_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(buffer);

      return file;
    } catch (e) {
      print('Error capturing image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: RepaintBoundary(
        key: _repaintBoundaryKey,
        child: CustomPaint(
          painter: _DualImagePainter(
            fabricImage: _fabricImage,
            overlayImage: _overlayImage,
            tileScale: widget.tileScale,
            tintColor: widget.tintColor,
          ),
          size: const Size(300, 500),
        ),
      ),
    );
  }
}

class _DualImagePainter extends CustomPainter {
  final ui.Image? fabricImage;
  final ui.Image? overlayImage;
  final double tileScale;
  final Color? tintColor;

  _DualImagePainter({
    required this.fabricImage,
    required this.overlayImage,
    required this.tileScale,
    this.tintColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (fabricImage == null) return;

    final fabricPaint = Paint();
    if (tintColor != null && tintColor!.alpha > 0) {
      fabricPaint.colorFilter = ColorFilter.mode(tintColor!, BlendMode.multiply);
    }

    final double baseTileWidth = fabricImage!.width.toDouble();
    final double baseTileHeight = fabricImage!.height.toDouble();

    final double tileWidth = (baseTileWidth * tileScale).clamp(10.0, baseTileWidth * 5);
    final double tileHeight = (baseTileHeight * tileScale).clamp(10.0, baseTileHeight * 5);

    // Limit max tiles to prevent GPU overload
    final int maxXTiles = 50;
    final int maxYTiles = 50;
    final int xTiles = (size.width / tileWidth).ceil().clamp(1, maxXTiles);
    final int yTiles = (size.height / tileHeight).ceil().clamp(1, maxYTiles);

    for (int i = 0; i < xTiles; i++) {
      for (int j = 0; j < yTiles; j++) {
        canvas.drawImageRect(
          fabricImage!,
          Rect.fromLTWH(0, 0, baseTileWidth, baseTileHeight),
          Rect.fromLTWH(i * tileWidth, j * tileHeight, tileWidth, tileHeight),
          fabricPaint,
        );
      }
    }

    if (overlayImage != null) {
      final overlayPaint = Paint();
      canvas.drawImageRect(
        overlayImage!,
        Rect.fromLTWH(0, 0, overlayImage!.width.toDouble(), overlayImage!.height.toDouble()),
        Rect.fromLTWH(0, 0, size.width, size.height),
        overlayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
