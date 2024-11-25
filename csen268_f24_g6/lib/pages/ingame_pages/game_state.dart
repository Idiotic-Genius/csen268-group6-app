import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>(
  (ref) => GameStateNotifier(),
);

const characters = {
  "character_1": "Jamie",
  "character_2": "Elliot",
  "character_3": "Amina",
  "character_4": "Sophia",
  "character_5": "Lila",
  "character_6": "Noah",
  "character_7": "Harper",
  "character_8": "Marcus",
  "character_9": "Ethan",
};

class GameState {
  final List<Character> characters;
  final String currentDialogue;

  GameState({
    required this.characters,
    required this.currentDialogue,
  });

  GameState.initial()
      : characters = [],
        currentDialogue = "Welcome to the game!";
}

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier() : super(GameState.initial());

  final Random random = Random();

  /// Initialize the game with the given number of killers, doctors, and innocents.
  void initializeGame(int killers, int doctors, int innocents) {
    final totalRoles = killers + doctors + innocents;
    final totalCharacters = characters.length;

    // Validation: Ensure the roles do not exceed the available characters
    if (totalRoles > totalCharacters) {
      throw Exception(
          "Too many roles specified ($totalRoles) for the available characters ($totalCharacters).");
    }

    final roles = [
      ...List.filled(killers, 'Killer'),
      ...List.filled(doctors, 'Doctor'),
      ...List.filled(innocents, 'Innocent'),
    ];
    roles.shuffle(random);

    // Assign roles to characters from the given dataset
    final characterList = characters.entries.toList();
    final characterRoles = List.generate(
      totalRoles,
      (index) => Character(
        id: characterList[index].key,
        name: characterList[index].value,
        role: roles[index],
        spritePath: 'assets/images/${characterList[index].key}.png',
      ),
    );

    state = GameState(
      characters: characterRoles,
      currentDialogue: "Game initialized! Tap a character to interact.",
    );

    print("Characters and their assigned roles:");
    for (final character in characterRoles) {
      print("Name: ${character.name}, Role: ${character.role}");
    }
  }

  /// Update the current dialogue with a new message.
  void updateDialogue(String newDialogue) {
    state = GameState(
      characters: state.characters,
      currentDialogue: newDialogue,
    );
  }

  /// Eliminate a character from the game.
  void eliminateCharacter(Character character) {
    state = GameState(
      characters: state.characters.where((c) => c != character).toList(),
      currentDialogue: "${character.name} has been eliminated!",
    );
  }

  /// Get a character's name by ID.
  String getCharacterName(String characterId) {
    return characters[characterId] ?? "Unknown";
  }
}

class Character {
  final String id;
  final String name;
  final String role; // Internal role (hidden from user)
  final String spritePath;

  Character({
    required this.id,
    required this.name,
    required this.role,
    required this.spritePath,
  });
}
