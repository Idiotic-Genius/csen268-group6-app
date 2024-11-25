import 'package:flutter/material.dart';

class TitleImages extends StatelessWidget {
  final List<String> imagePaths;
  final double columnHeight;

  const TitleImages({
    super.key,
    required this.imagePaths,
    required this.columnHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: columnHeight,
      child: Column(
        children: imagePaths.map((path) {
          double childHeight = columnHeight / imagePaths.length;
          return SizedBox(
            height: childHeight,
            child: Center(
              child: Image.asset(
                path,
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

