import 'package:flutter/material.dart';

class IconShimmer extends StatelessWidget {
  final IconData icon;
  final double size;
  const IconShimmer({
    super.key,
    required this.icon,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.white,
      size: size,
    );
  }
}
