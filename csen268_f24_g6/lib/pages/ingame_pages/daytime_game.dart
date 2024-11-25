import 'package:csen268.f24.g6/pages/ingame_pages/overlays/dialogue_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_state.dart';


final selectedCharacterProvider = StateProvider<String>((ref) => ""); // Tracks the selected character's ID
final highlightedCharacterProvider = StateProvider<String>((ref) => ""); // Tracks the highlighted character's ID
final currentCharacterIndexProvider = StateProvider<int>((ref) => 0); // Tracks the index of the highlighted character
final hasFinishedCyclingProvider = StateProvider<bool>((ref) => false); // Tracks if the current cycle is complete

class DaytimeGame extends ConsumerWidget {
  final VoidCallback onEliminationComplete; // Callback for nighttime transition

  const DaytimeGame({
    Key? key,
    required this.onEliminationComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final gameNotifier = ref.read(gameStateProvider.notifier);

    // Listen to the highlighted character and the current index
    final highlightedCharacterId = ref.watch(highlightedCharacterProvider);
    final currentCharacterIndex = ref.watch(currentCharacterIndexProvider);
    final hasFinishedCycling = ref.watch(hasFinishedCyclingProvider);

    // Advance to the next character in the cycle
    void cycleToNextCharacter() {
      if (gameState.characters.isNotEmpty) {
        if (currentCharacterIndex < gameState.characters.length) {
          final character = gameState.characters[currentCharacterIndex];
          ref.read(highlightedCharacterProvider.notifier).state = character.id;

          ref.read(currentCharacterIndexProvider.notifier).state += 1;
        }

        // Mark the cycle as complete after the last character
        if (currentCharacterIndex + 1 >= gameState.characters.length) {
          ref.read(hasFinishedCyclingProvider.notifier).state = true;
        }
      }
    }

    // Show elimination dialog when a cycle is complete
    void showEliminationDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Eliminate a Character"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: gameState.characters.map((character) {
                return ListTile(
                  title: Text(character.name), // Show character name
                  onTap: () {
                    // Eliminate the selected character
                    gameNotifier.eliminateCharacter(character);
                    ref.read(currentCharacterIndexProvider.notifier).state = 0; // Reset index
                    ref.read(hasFinishedCyclingProvider.notifier).state = false; // Reset cycle
                    Navigator.of(context).pop(); // Close dialog

                    // Trigger nighttime transition after elimination
                    onEliminationComplete();
                  },
                );
              }).toList(),
            ),
          );
        },
      );
    }

    // Start the highlighting cycle on tap
    return GestureDetector(
      onTap: () {
        if (hasFinishedCycling) {
          showEliminationDialog();
        } else {
          cycleToNextCharacter();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Define the base resolution for the background
          const double baseWidth = 1920.0;
          const double baseHeight = 1080.0;

          // Calculate the scaling factors
          final double scaleX = constraints.maxWidth / baseWidth;
          final double scaleY = constraints.maxHeight / baseHeight;

          // Apply a multiplier to make characters larger
          const double characterSizeMultiplier = 1.2;

          return Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/daytime_background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              // Characters row
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: gameState.characters.map((character) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0 * scaleX),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              character.spritePath,
                              height:
                                  350 * scaleY * characterSizeMultiplier,
                            ),
                            SizedBox(height: 8 * scaleY),
                            Text(
                              character.name, // Show character name
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14 * scaleY * characterSizeMultiplier,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              // Dialogue Overlay
              DialogueOverlay(
                characterId: highlightedCharacterId.isNotEmpty ? highlightedCharacterId : "unknown",
                dialogue: gameState.currentDialogue,
              ),

            ],
          );
        },
      ),
    );
  }
}
