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
    final gameNotifier = ref.read(gameStateProvider.notifier);
    final highlightedCharacterId = ref.watch(highlightedCharacterProvider);
    final TextEditingController messageController = TextEditingController();

    if (gameState == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filter discussions for the highlighted character
    final highlightedDialogues = gameState.discussions
        .where((dialogue) => dialogue.role == highlightedCharacterId)
        .toList();

    // Get the character's name or fallback to ID
    final characterName = gameState.characters
        .firstWhere(
          (character) => character.id == highlightedCharacterId,
          orElse: () => Character(
            id: highlightedCharacterId,
            name: "You (Investigator)",
            role: "",
            isAlive: true,
            spritePath: "",
          ),
        )
        .name;

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
            // Input Field (Visible only if no dialogues are available)
            if (gameState.discussions.isEmpty)
              Column(
                children: [
                  TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Enter your observations...",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final message = messageController.text.trim();
                      if (message.isNotEmpty) {
                        await gameNotifier.fetchDiscussion(gameId, message);
                        messageController.clear();
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              )
            else ...[
              // Display Character's Name
              Text(
                characterName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              // Display Dialogue Content
              if (highlightedDialogues.isNotEmpty)
                Text(
                  highlightedDialogues.first.content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )
              else
                const Text(
                  "No dialogue available for this character.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
