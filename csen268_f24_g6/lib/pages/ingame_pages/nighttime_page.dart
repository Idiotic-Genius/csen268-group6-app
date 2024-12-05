import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_state.dart';

class NighttimePage extends ConsumerWidget {
  final String gameId;

  const NighttimePage({Key? key, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStateNotifier = ref.read(gameStateProvider.notifier);
    final gameState = ref.watch(gameStateProvider);

    // Trigger the nighttime process when the page loads
    Future<void> handleNighttime() async {
      try {
        await gameStateNotifier.processNight(gameId);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error processing nighttime: $e")),
        );
      }
    }

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
                    'assets/images/nighttime_background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                // Nighttime content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Night Actions",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (gameState.eliminatedPlayer != null)
                        Text(
                          "${gameState.nightMessage}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      else
                        const Text(
                          "No one was eliminated tonight.",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Navigate to the next phase
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
