import 'package:csen268.f24.g6/pages/outgame_pages/components/text_styles.dart';
import 'package:flutter/material.dart';

class PlayerStatsTextBox extends StatelessWidget {
  final String playerName;
  final int gamesWon;
  final int gamesLost;

  const PlayerStatsTextBox({
    Key? key,
    required this.playerName,
    required this.gamesWon,
    required this.gamesLost
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Container(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                playerName,
                style: customTextStyle(30),
              ),
              const SizedBox(height: 10),
              _buildStatRow('Games Won', gamesWon),
              _buildStatRow('Games Lost', gamesLost),
            ]
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: customTextStyle(16),
          ),
          Text(
            '$value',
            style: customTextStyle(16),
          ),
        ],
      ),
    );
  }
}
