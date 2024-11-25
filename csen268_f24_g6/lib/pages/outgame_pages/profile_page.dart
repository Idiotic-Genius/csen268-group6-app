import 'package:csen268.f24.g6/pages/outgame_pages/components/background_image.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/bottom_menu.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/profile_stats.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/title_image.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                      'assets/images/player_text.png',
                      'assets/images/profile_text.png'
                    ],
                    columnHeight: 100,
                  ),
                  SizedBox(height: 25),
                  Expanded(
                    child: PlayerStatsTextBox(
                      playerName: 'Player Name',
                      gamesWon: 1,
                      gamesPlayed: 2,
                      arrestedKillers: 2,
                      escapedKillers: 2,
                      innocentsSaved: 2,
                      innocentsDead: 2,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BottomMenuButtons(
                  gameSettingsMode: false,
                  enablePlaySettingButtons: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
