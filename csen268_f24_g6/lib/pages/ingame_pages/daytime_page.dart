import 'package:csen268.f24.g6/pages/ingame_pages/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'daytime_game.dart';
import 'nighttime_page.dart';

class DaytimePage extends ConsumerWidget {
  final int killers;
  final int doctors;
  final int innocents;

  const DaytimePage({
    Key? key,
    required this.killers,
    required this.doctors,
    required this.innocents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameNotifier = ref.read(gameStateProvider.notifier);

    // Initialize the game state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gameNotifier.initializeGame(killers, doctors, innocents);
    });

    // Navigate to NighttimePage after an elimination
    void navigateToNighttime() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NighttimePage(),
        ),
      );
    }

    return Scaffold(
      body: DaytimeGame(
        onEliminationComplete: navigateToNighttime, // Trigger nighttime transition
      ),
    );
  }
}
