import 'package:flutter/material.dart';
import 'package:kimsong_ui_testing/pages/outgame_pages/components/background_image.dart';
import 'package:kimsong_ui_testing/pages/outgame_pages/components/bottom_menu.dart';
import 'package:kimsong_ui_testing/pages/outgame_pages/components/game_setting_textbox.dart';
import 'package:kimsong_ui_testing/pages/outgame_pages/components/title_image.dart';

class GameSettingsPage extends StatelessWidget {
  const GameSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackgroundImage(),
          Padding(
            padding: EdgeInsets.only(top: 25, bottom: 25),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleImages(
                    imagePaths: [
                      'assets/images/game_text.png',
                      'assets/images/game_settings_button.png',
                    ],
                    columnHeight: 100,
                  ),
                  SizedBox(height: 25),
                  Expanded(
                    child: GameSettingTextBox(gameSettingsMode: true),
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BottomMenuButtons(gameSettingsMode: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
