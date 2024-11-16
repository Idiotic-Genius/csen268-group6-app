import 'package:flutter/material.dart';

class GameSettingTextBox extends StatelessWidget {
  const GameSettingTextBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 350,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontFamily: 'IrishGrover',
              height: 1.5,
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.white,
                  offset: Offset(1.0, 1.0),
                ),
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.white,
                  offset: Offset(-1.0, -1.0),
                ),
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.white,
                  offset: Offset(1.0, -1.0),
                ),
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.white,
                  offset: Offset(-1.0, 1.0),
                ),
              ],
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Game Settings\n',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
              TextSpan(
                text: 'Killers: <number>\n',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              TextSpan(
                text: 'Doctors: <number>\n',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              TextSpan(
                text: 'Innocents: <number>\n',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              TextSpan(
                text: 'Time Per Round: <number>\n',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
