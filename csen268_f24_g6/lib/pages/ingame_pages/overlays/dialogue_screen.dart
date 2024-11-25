import 'package:csen268.f24.g6/pages/ingame_pages/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DialogueOverlay extends ConsumerWidget {
  final String characterId; // Use characterId instead of directly passing the name
  final String dialogue;

  const DialogueOverlay({
    Key? key,
    required this.characterId,
    required this.dialogue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the GameStateNotifier to fetch the character's name dynamically
    final gameState = ref.watch(gameStateProvider);
    final character = gameState.characters.firstWhere(
      (char) => char.id == characterId,
      orElse: () => Character(
        id: "unknown",
        name: "Unknown",
        role: "Unknown",
        spritePath: "",
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
            // Display the dynamically fetched character name
            Text(
              character.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dialogue,
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
