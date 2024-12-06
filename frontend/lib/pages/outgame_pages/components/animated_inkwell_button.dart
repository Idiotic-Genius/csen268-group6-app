import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final String imageAsset;
  final VoidCallback onTap;
  final double scaleFactor;
  final Duration animationDuration;
  final bool isCircleAvatar;

  const AnimatedButton({
    Key? key,
    required this.imageAsset,
    required this.onTap,
    this.scaleFactor = 0.9,
    this.animationDuration = const Duration(milliseconds: 100),
    this.isCircleAvatar = true,
  }) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleFactor).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await _controller.forward(from: 0.0);
        widget.onTap();
        await _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.isCircleAvatar
                ? CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(widget.imageAsset),
                  )
                : SizedBox(
                    height: 30,
                    child: Center(
                      child: Image.asset(
                        widget.imageAsset,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
