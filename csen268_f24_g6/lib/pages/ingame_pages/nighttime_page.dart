import 'package:csen268.f24.g6/pages/ingame_pages/overlays/win_lose_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_state.dart';
import 'daytime_page.dart';

class NighttimePage extends ConsumerWidget {
  final String gameId;

  const NighttimePage({Key? key, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStateNotifier = ref.read(gameStateProvider.notifier);
    final gameState = ref.watch(gameStateProvider);

    // Handle nighttime logic
    Future<void> handleNighttime() async {
      try {
        await gameStateNotifier.processNight(gameId);

        // If the game is over, navigate to the WinLoseScreen
        if (gameState != null && gameState.gameOver) {

          bool didWin = gameState.winner == "villagers";
          String statType = didWin ? 'gamesWon' : 'gamesLost';
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WinLoseScreen(didWin: didWin,),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error processing nighttime: $e")),
        );
      }
    }

    // Automatically trigger nighttime logic when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (gameState != null && gameState.phase == "night") {
        handleNighttime();
      }
    });

    return Scaffold(
      body: gameState == null || gameState.phase == "night"
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Background image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/nighttime_background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                // Nighttime content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Night Actions",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        gameState.nightMessage ??
                            "No actions occurred during the night.",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DaytimePage(
                                numPlayers: gameState.characters.length,
                                numKillers: gameState.characters
                                    .where((char) => char.role == "killer")
                                    .length,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Continue"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
