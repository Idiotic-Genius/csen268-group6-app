import 'package:flutter/material.dart';


TextStyle customTextStyle(double fontSize) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    fontFamily: 'IrishGrover',
    color: Colors.black,
    shadows: const [
      Shadow(
        blurRadius: 1.0,
        color: Colors.white,
        offset: Offset(1.0, 1.0),
      ),
      Shadow(
        blurRadius: 1.0,
        color: Colors.white,
        offset: Offset(-1.0, -1.0),
      ),
      Shadow(
        blurRadius: 1.0,
        color: Colors.white,
        offset: Offset(1.0, -1.0),
      ),
      Shadow(
        blurRadius: 1.0,
        color: Colors.white,
        offset: Offset(-1.0, 1.0),
      ),
    ],
  );
}