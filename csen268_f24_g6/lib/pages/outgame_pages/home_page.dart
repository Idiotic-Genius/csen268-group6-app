import 'package:csen268.f24.g6/pages/outgame_pages/components/background_image.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/bottom_menu.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/game_setting_textbox.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/title_image.dart';
import 'package:flutter/material.dart';

import '../ingame_pages/musicController.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ValueNotifier<bool> isMuted = ValueNotifier<bool>(false); // Tracks mute state

  void toggleMusic() {
    MusicController().stopMusic();
    print("toggle value");
    isMuted.value = !isMuted.value; // Toggle mute state

    if (isMuted.value) {
      MusicController().stopMusic(); // Stop music when muted
    } else {
      MusicController().playInitialMusic(); // Play initial music when unmuted
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundImage(),
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
                  Spacer()
                ],
              ),
            ),
          ),
          // Mute/Unmute Button Positioned at Top-Left Corner
          Positioned(
            top: 20,
            left: 20,
            child: ValueListenableBuilder<bool>(
              valueListenable: isMuted,
              builder: (context, value, child) {
                return GestureDetector(
                  onTap: toggleMusic, // Call toggleMusic on image tap
                  child: Image.asset(
                    value
                        ? 'assets/images/volume-mute.png' // Mute image
                        : 'assets/images/volume.png', // Unmute image
                    width: 50,
                    height: 50,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
