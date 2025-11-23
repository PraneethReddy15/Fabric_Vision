import 'dart:math';
import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final double height;
  final ValueChanged<Color> onColorChanged;
  final Color? currentColor;

  const ColorPicker({
    super.key,
    required this.height,
    required this.onColorChanged,
    this.currentColor,
  });

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final List<Color> _colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.lime,
    Colors.green,
    Colors.teal,
    Colors.cyan,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.deepOrange,
    Colors.grey,
  ];

  double _colorSliderPosition = 0;
  double _opacitySliderPosition = 0;
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.currentColor ?? _colors.first;
    _opacitySliderPosition = widget.currentColor != null
        ? widget.height * (_currentColor.alpha / 255.0)
        : widget.height;
    if (widget.currentColor != null) _setColor(widget.currentColor!);
  }

  @override
  void didUpdateWidget(ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentColor != oldWidget.currentColor && widget.currentColor != null) {
      _setColor(widget.currentColor!);
    }
  }

  void _setColor(Color color) {
    double bestPosition = 0;
    double minDiff = double.infinity;

    for (double p = 0; p <= widget.height; p += 1) {
      Color c = _calculateSelectedColor(p);
      double diff = sqrt(pow(c.red - color.red, 2) +
          pow(c.green - color.green, 2) +
          pow(c.blue - color.blue, 2));
      if (diff < minDiff) {
        minDiff = diff;
        bestPosition = p;
      }
    }

    setState(() {
      _colorSliderPosition = bestPosition;
      _opacitySliderPosition = widget.height * (color.alpha / 255.0);
      _currentColor = color;
    });
  }

  void _colorChangeHandler(double position) {
    position = position.clamp(0, widget.height);
    setState(() {
      _colorSliderPosition = position;
      _currentColor = _calculateSelectedColor(position);
      _updateColorWithOpacity();
    });
  }

  void _opacityChangeHandler(double position) {
    position = position.clamp(0, widget.height);
    setState(() {
      _opacitySliderPosition = position;
      _updateColorWithOpacity();
    });
  }

  Color _calculateSelectedColor(double position) {
    double index = position / widget.height * (_colors.length - 1);
    int lower = index.floor();
    int upper = index.ceil();
    if (upper >= _colors.length) upper = _colors.length - 1;
    Color lowerColor = _colors[lower];
    Color upperColor = _colors[upper];
    double t = index - lower;
    return Color.lerp(lowerColor, upperColor, t)!;
  }

  void _updateColorWithOpacity() {
    int alpha = (_opacitySliderPosition / widget.height * 255).round();
    _currentColor = _currentColor.withAlpha(alpha);
    widget.onColorChanged(_currentColor);
  }

  @override
  Widget build(BuildContext context) {
    final opacityGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        _currentColor.withAlpha(0),
        _currentColor.withAlpha(255),
      ],
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Color Slider
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragUpdate: (details) => _colorChangeHandler(details.localPosition.dy),
          onTapDown: (details) => _colorChangeHandler(details.localPosition.dy),
          child: Container(
            width: 30,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[800]!, width: 2),
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _colors,
              ),
            ),
            child: CustomPaint(painter: _SliderIndicatorPainter(_colorSliderPosition)),
          ),
        ),
        const SizedBox(width: 12),
        // Opacity Slider
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragUpdate: (details) => _opacityChangeHandler(details.localPosition.dy),
          onTapDown: (details) => _opacityChangeHandler(details.localPosition.dy),
          child: Container(
            width: 30,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[800]!, width: 2),
              borderRadius: BorderRadius.circular(15),
              gradient: opacityGradient,
            ),
            child: CustomPaint(painter: _SliderIndicatorPainter(_opacitySliderPosition)),
          ),
        ),
      ],
    );
  }
}

class _SliderIndicatorPainter extends CustomPainter {
  final double position;

  _SliderIndicatorPainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()..color = Colors.black;

    canvas.drawCircle(Offset(size.width / 2, position), 10, borderPaint);
    canvas.drawCircle(Offset(size.width / 2, position), 8, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _SliderIndicatorPainter oldDelegate) => true;
}
