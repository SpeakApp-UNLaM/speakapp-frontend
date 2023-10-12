import 'package:flutter/material.dart';

class GeometricalBackground extends StatelessWidget {
  final Widget child;
  const GeometricalBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(child: Container(color: backgroundColor)),

          // Background with shapes
          Container(
            height: size.height * 0.7,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),

          // Child widget
          child,
        ],
      ),
    );
  }
}
