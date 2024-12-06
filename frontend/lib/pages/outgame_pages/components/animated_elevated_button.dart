import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedElevatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String buttonText;

  const AnimatedElevatedButton({
    Key? key,
    required this.onPressed,
    required this.isLoading,
    required this.buttonText,
  }) : super(key: key);

  @override
  _AnimatedElevatedButtonState createState() => _AnimatedElevatedButtonState();
}

class _AnimatedElevatedButtonState extends State<AnimatedElevatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading
          ? null
          : () async {
              await _controller.forward(from: 0.0);
              Future.delayed(Duration(milliseconds: 200), () {
                if (widget.onPressed != null) {
                  widget.onPressed!();
                }
              });
              await _controller.reverse();
            },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ElevatedButton(
              onPressed: widget.isLoading
                  ? null
                  : () async {
                      await _controller.forward(from: 0.0);
                      Future.delayed(Duration(milliseconds: 200), () {
                        widget.onPressed?.call();
                      });
                      await _controller.reverse();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      widget.buttonText,
                      style: GoogleFonts.irishGrover(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
