import 'package:csen268.f24.g6/pages/outgame_pages/components/text_styles.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class NarratorScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const NarratorScreen({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<NarratorScreen> createState() => _NarratorScreenState();
}

class _NarratorScreenState extends State<NarratorScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final String narratorText = """
In a remote village shrouded in mystery, darkness lurks among the innocent.
As night falls, killers walk among us, their identities concealed behind masks of normalcy.
You, as the investigator, must lead the villagers to uncover the truth before it's too late.

Let the investigation begin...
""";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    // Add mounted check before executing callback
    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Blurred Background
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.8),
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/images/daytime_background.gif',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Narrator Text Container
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white24,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      narratorText,
                      style: customTextStyle(16),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: widget.onComplete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}