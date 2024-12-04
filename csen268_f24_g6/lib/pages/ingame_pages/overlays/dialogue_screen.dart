import 'package:csen268.f24.g6/pages/ingame_pages/daytime_game.dart';
import 'package:csen268.f24.g6/pages/ingame_pages/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DialogueOverlay extends ConsumerWidget {
  final String gameId;

  const DialogueOverlay({
    Key? key,
    required this.gameId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final highlightedCharacterId = ref.watch(highlightedCharacterProvider); // Watch the highlighted character
    final gameNotifier = ref.read(gameStateProvider.notifier);

    if (gameState == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Fetch discussions if not already fetched
    if (gameState.discussions.isEmpty) {
      gameNotifier.fetchDiscussion(gameId);
      return const Center(child: CircularProgressIndicator());
    }

    // Find the dialogue for the currently highlighted character
    final currentDialogue = gameState.discussions.firstWhere(
      (dialogue) => dialogue.role == highlightedCharacterId,
      orElse: () => DialogueResponse(
        role: highlightedCharacterId,
        content: "No dialogue available for this character.",
        day: gameState.day,
      ),
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        color: Colors.black.withOpacity(0.7),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display character's name (if available) or their ID
            Text(
              gameState.characters
                      .firstWhere(
                        (character) => character.id == highlightedCharacterId,
                        orElse: () => Character(
                          id: highlightedCharacterId,
                          name: "Unknown",
                          role: "Unknown",
                          isAlive: true,
                          spritePath: "",
                        ),
                      )
                      .name ??
                  "Unknown Character",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            // Display the dialogue content
            Text(
              currentDialogue.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
