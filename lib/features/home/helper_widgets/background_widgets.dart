import 'package:flutter/material.dart';

class NetworkBackground extends StatelessWidget {
  const NetworkBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Solid fallback — prevents checkerboard on web
        Container(color: const Color.fromARGB(255, 23, 23, 61)),

        // 2. Gradient on top of solid color
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x8A12152E), Color(0x7A0B0E22)],
            ),
          ),
        ),

        // 3. Network PNG — transparent areas now blend into dark bg
        Opacity(
          opacity: 0.24,
          child: Image.asset('assets/bg_network.png', fit: BoxFit.cover),
        ),

        // 4. Dark scrim so text stays readable
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 24, 40, 92).withOpacity(0.55), // was 0.35
                Color.fromARGB(255, 24, 40, 92).withOpacity(0.72), // was 0.55
              ],
            ),
          ),
        ),
      ],
    );
  }
}
