import 'package:flutter/material.dart';

class OverlayButton extends StatelessWidget {
  final String asset;
  final String label;
  final Function(String) onPressed;

  const OverlayButton({
    super.key,
    required this.asset,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(asset),
      child: Text(label),
    );
  }
}
