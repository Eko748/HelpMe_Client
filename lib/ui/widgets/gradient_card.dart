import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.width,
    required this.height,
    required this.cardColor,
    this.decoration,
    required this.child,
  });

  final double width;
  final double height;
  final Color cardColor;
  final Widget child;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Stack(
          children: [
            _cardContainer(),
            _cardGradient(65, 60),
            _cardGradient(35, 80),
          ],
        ),
      ),
    );
  }

  Container _cardContainer() {
    return Container(
      width: width,
      height: height,
      decoration: decoration ??
          BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 5),
                blurRadius: 10,
              ),
            ],
          ),
      child: Center(
        child: child,
      ),
    );
  }

  Positioned _cardGradient(double widht, double height) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        width: widht,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
          ),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(0.2),
            ],
          ),
        ),
      ),
    );
  }
}
