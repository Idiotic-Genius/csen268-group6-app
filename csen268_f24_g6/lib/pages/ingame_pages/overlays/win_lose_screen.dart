import 'package:csen268.f24.g6/pages/outgame_pages/home_page.dart';
import 'package:flutter/material.dart';

class WinLoseScreen extends StatelessWidget {
  final bool didWin; // true for win, false for lose

  const WinLoseScreen({
    Key? key,
    required this.didWin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Blurred Background
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6), // Overlay dark color
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/images/daytime_background.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // "You Win" or "You Lose" text
          Center(
            child: Image.asset(
              didWin
                  ? 'assets/images/you_win_text.png' // Win Asset
                  : 'assets/images/you_lose_text.png', // Lose Asset
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.8, // Responsive width
            ),
          ),
          // Exit Button
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to the Home Page
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(), // Replace with your HomePage
                    ),
                    (route) => false, // Remove all previous routes
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "Exit to Home",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
