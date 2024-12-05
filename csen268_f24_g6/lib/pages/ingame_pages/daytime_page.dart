import 'package:csen268.f24.g6/pages/ingame_pages/overlays/win_lose_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_state.dart';
import 'daytime_game.dart';
import 'nighttime_page.dart';


class DaytimePage extends ConsumerWidget {
  final int numPlayers;
  final int numKillers;

  const DaytimePage({
    Key? key,
    required this.numPlayers,
    required this.numKillers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameNotifier = ref.read(gameStateProvider.notifier);
    final gameState = ref.watch(gameStateProvider);

    // Check for gameOver before initializing or transitioning
    if (gameState != null && gameState.gameOver) {
      bool didWin = gameState.winner == "villagers";
      String statType = didWin ? 'gamesWon' : 'gamesLost'; 
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WinLoseScreen(
              didWin: gameState.winner == "villagers",
              statType: statType,
              characters: gameState.characters,
            ),
          ),
        );
      });
      return const Center(child: CircularProgressIndicator());
    }

    // Initialize the game state if it's null
    _initializeGame(context, gameNotifier, gameState);

    // Function to navigate to NighttimePage
    void navigateToNighttime() {

      if (gameState != null) {
        print("Navigating to nighttime...");
        print(gameState.phase);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NighttimePage(
              gameId: gameState.gameId,
            ),
          ),
        ).then((_) {
          print("Returned to DaytimePage.");
        });
      } else {
        print("Error: gameState is null, cannot navigate to nighttime.");
        _showSnackbar(context, 'Game state is not available.');
      }
    }

    return Scaffold(
      body: gameState == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : DaytimeGame(
              onEliminationComplete: navigateToNighttime,
            ),
    );
  }

  /// Initializes the game state if it hasn't been initialized yet.
  void _initializeGame(
    BuildContext context,
    GameStateNotifier gameNotifier,
    GameState? gameState,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (gameState == null) {
        try {
          print("Initializing game...");
          await gameNotifier.initializeGame(numPlayers, numKillers);
          print("Game initialized successfully.");
        } catch (e) {
          print("Error initializing game: $e");
          _showSnackbar(context, 'Failed to initialize game: $e');
        }
      }
    });
  }

  /// Displays a snackbar with the given message.
  void _showSnackbar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
