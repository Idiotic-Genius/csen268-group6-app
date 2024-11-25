import 'package:csen268.f24.g6/pages/outgame_pages/components/text_styles.dart';
import 'package:flutter/material.dart';

class PlayerStatsTextBox extends StatelessWidget {
  final String playerName;
  final int gamesWon;
  final int gamesPlayed;
  final int arrestedKillers;
  final int escapedKillers;
  final int innocentsSaved;
  final int innocentsDead;

  const PlayerStatsTextBox({
    Key? key,
    required this.playerName,
    required this.gamesWon,
    required this.gamesPlayed,
    required this.arrestedKillers,
    required this.escapedKillers,
    required this.innocentsSaved,
    required this.innocentsDead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 400,
      padding: const EdgeInsets.all(16.0),
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
          const SizedBox(height: 12),
          _buildStatRow('Games Won', gamesWon),
          _buildStatRow('Games Played', gamesPlayed),
          _buildStatRow('Arrested Killers', arrestedKillers),
          _buildStatRow('Escaped Killers', escapedKillers),
          _buildStatRow('Innocents Saved', innocentsSaved),
          _buildStatRow('Innocents Dead', innocentsDead),
        ],
      ),
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
