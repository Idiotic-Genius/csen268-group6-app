import 'package:csen268.f24.g6/pages/ingame_pages/nighttime_page.dart';
import 'package:csen268.f24.g6/pages/ingame_pages/overlays/dialogue_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_state.dart';

final selectedCharacterProvider =
    StateProvider<String>((ref) => ""); // Tracks the selected character's ID
final highlightedCharacterProvider =
    StateProvider<String>((ref) => ""); // Tracks the highlighted character's ID
final currentCharacterIndexProvider = StateProvider<int>(
    (ref) => 0); // Tracks the index of the highlighted character
final hasFinishedCyclingProvider = StateProvider<bool>(
    (ref) => false); // Tracks if the current cycle is complete

final isVotingProvider = StateProvider<bool>((ref) => false);

class DaytimeGame extends ConsumerWidget {
  final VoidCallback onEliminationComplete; // Callback for nighttime transition

  const DaytimeGame({
    Key? key,
    required this.onEliminationComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    if (gameState == null) {
      return const Center(child: CircularProgressIndicator());
    }

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

    // Show voting dialog when a cycle is complete
    void showVotingDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return Consumer(
            builder: (context, ref, _) {
              final isVoting = ref.watch(isVotingProvider);

              return AlertDialog(
                title: const Text("Vote for a Character"),
                content: isVoting
                    ? const SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: gameState.characters
                              .where((character) => character.isAlive)
                              .map((character) {
                            return ListTile(
                              title: Text(character.name),
                              onTap: () async {
                                if (!isVoting) {
                                  ref.read(isVotingProvider.notifier).state =
                                      true;

                                  // Submit the vote
                                  final updatedState = await gameNotifier.vote(
                                    gameState.gameId,
                                    character,
                                  );

                                  if (updatedState != null &&
                                      dialogContext.mounted) {
                                    // Close the dialog
                                    Navigator.of(dialogContext).pop();

                                    // Clean up state and trigger transition
                                    Future.microtask(() {
                                      ref
                                          .read(currentCharacterIndexProvider
                                              .notifier)
                                          .state = 0;
                                      ref
                                          .read(hasFinishedCyclingProvider
                                              .notifier)
                                          .state = false;
                                      ref
                                          .read(isVotingProvider.notifier)
                                          .state = false;

                                      // Navigate to NighttimePage
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NighttimePage(
                                            gameId: gameState.gameId,
                                          ),
                                        ),
                                      );
                                    });
                                  } else if (dialogContext.mounted) {
                                    // Reset state and show error if vote fails
                                    ref.read(isVotingProvider.notifier).state =
                                        false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Failed to process vote. Please try again.',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ),
              );
            },
          );
        },
      );
    }

    // Start the highlighting cycle on tap
    return GestureDetector(
      onTap: () {
        if (hasFinishedCycling) {
          showVotingDialog();
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

          // Check if the keyboard is open
          final bool isKeyboardVisible =
              MediaQuery.of(context).viewInsets.bottom > 0;

          // Apply a multiplier to make characters larger
          const double characterSizeMultiplier = 1.2;

          return Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/daytime_background_1.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              // Characters row (prevent scaling when the keyboard is visible)
              if (!isKeyboardVisible)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: gameState.characters
                          .where((character) => character.isAlive)
                          .map((character) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20.0 * scaleX),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                character.spritePath,
                                height: 550 * scaleY * characterSizeMultiplier,
                              ),
                              SizedBox(height: 40 * scaleY),
                              Text(
                                character.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      16 * scaleY * characterSizeMultiplier,
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
                gameId: gameState.gameId,
              ),
            ],
          );
        },
      ),
    );
  }
}
