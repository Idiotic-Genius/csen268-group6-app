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

    // Process nighttime actions and update the state
    Future<void> handleNighttime() async {
      try {
        await gameStateNotifier.processNight(gameId);

        // If the game is over, show the winner
        if (gameState != null && gameState.gameOver) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text("Game Over"),
              content: Text(
                "The winner is ${gameState.winner ?? "unknown"}!",
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text("Exit"),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error processing nighttime: $e")),
        );
      }
    }

    // Trigger nighttime logic after page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (gameState != null && gameState.phase == "night") {
        handleNighttime();
      }
    });

    return Scaffold(
      body: gameState == null || gameState.phase == "night"
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                // Background image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/daytime_background.jpg',
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
                        onPressed: () async {
                          try {
                            await handleNighttime();
                            // Redirect to DaytimePage
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
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Error transitioning to daytime: $e")),
                            );
                          }
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
