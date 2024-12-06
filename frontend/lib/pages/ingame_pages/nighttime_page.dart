import 'package:csen268.f24.g6/pages/ingame_pages/overlays/win_lose_screen.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/components/text_styles.dart';
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
    final Nightcount = (gameState?.day ?? 1) - 1;

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
              builder: (context) => WinLoseScreen(
                didWin: didWin,
                statType: statType,
                characters: gameState.characters,
              ),
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
      body: Stack(
        children: [
          gameState == null || gameState.phase == "night"
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/nighttime_background.gif',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Night Actions",
                            style: customTextStyle(28),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            gameState.nightMessage ??
                                "No actions occurred during the night.",
                            style: customTextStyle(18),
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
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Continue",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          // Top-left display for night number
          if (gameState != null)
            Positioned(
              top: 16.0,
              left: 16.0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  "Night ${Nightcount}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
