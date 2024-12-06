import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/menu_background.gif',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
