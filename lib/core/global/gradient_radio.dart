
import 'package:flutter/material.dart';
class GradientRadio extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Gradient gradient;

  const GradientRadio({
    required this.selected,
    required this.onTap,
    required this.gradient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: selected
            ? Center(
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
            ),
          ),
        )
            : SizedBox.shrink(),
      ),
    );
  }
}