import 'package:flutter/material.dart';

class TitleImage extends StatelessWidget {
  const TitleImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Center(
        child: Image.asset(
          'assets/images/title.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
