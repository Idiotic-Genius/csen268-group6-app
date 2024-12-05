import 'package:csen268.f24.g6/pages/outgame_pages/components/background_image.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/bottom_menu.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/game_setting_textbox.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/title_image.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackgroundImage(),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  TitleImages(
                    imagePaths: ['assets/images/Title.png'],
                    columnHeight: 80,
                  ),
                  Spacer(),
                  GameSettingTextBox(gameSettingsMode: false),
                  Spacer(),
                  BottomMenuButtons(
                    gameSettingsMode: false,
                    enablePlaySettingButtons: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
