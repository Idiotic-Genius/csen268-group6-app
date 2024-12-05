import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState?>(
  (ref) => GameStateNotifier(),
);

class GameState {
  final String gameId;
  final String phase;
  final int day;
  final List<Character> characters;
  final bool gameOver;
  final String? winner;
  final String? eliminatedPlayer; // Add this field
  final String? nightMessage; // Add this field
  final List<DialogueResponse> discussions;

  GameState({
    required this.gameId,
    required this.phase,
    required this.day,
    required this.characters,
    required this.gameOver,
    this.winner,
    this.eliminatedPlayer, // Initialize
    this.nightMessage, // Initialize
    this.discussions = const [],
  });

  factory GameState.fromJson(Map<String, dynamic> json) {
    final players = (json['state']['players'] as Map<String, dynamic>)
        .entries
        .map((entry) => Character.fromJson(entry.key, entry.value))
        .toList();

    return GameState(
      gameId: json['game_id'] ?? "unknown",
      phase: json['state']['phase'] ?? "unknown",
      day: json['state']['day'] ?? 0,
      characters: players,
      gameOver: json['game_over'] ?? false,
      winner: json['winner'],
      eliminatedPlayer: json['eliminated_player'], // Parse eliminated player
      nightMessage: json['night_message'], // Parse night message
      discussions: [],
    );
  }
}

class DialogueResponse {
  final String role;
  final String content;
  final int day;

  DialogueResponse({
    required this.role,
    required this.content,
    required this.day,
  });

  factory DialogueResponse.fromJson(Map<String, dynamic> json) {
    return DialogueResponse(
      role: json['role'],
      content: json['content'],
      day: json['day'],
    );
  }
}

class Character {
  final String id;
  final String name;
  final String role;
  final bool isAlive;
  final String spritePath;

  Character({
    required this.id,
    required this.name,
    required this.role,
    required this.isAlive,
    required this.spritePath,
  });

  factory Character.fromJson(String id, Map<String, dynamic> json) {
    return Character(
      id: id,
      name: json['name'],
      role: json['role'],
      isAlive: json['is_alive'],
      spritePath: '', // To be assigned separately
    );
  }
}

class GameStateNotifier extends StateNotifier<GameState?> {
  String get baseUrl {
    // return 'http://127.0.0.1:8000';

    return 'http://10.0.0.251:8000';
  }

  GameStateNotifier() : super(null);

  /// Start a new game by interacting with the API and assign sprites.
  Future<void> initializeGame(int numPlayers, int numKillers) async {
    try {
      print("Starting simple API call to initialize game...");

      // Make the API call
      final response = await http.post(
        Uri.parse('$baseUrl/game/start'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Accept',
        },
        body: jsonEncode({
          'num_players': numPlayers,
          'num_killers': numKillers,
        }),
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        // Parse the GameState from the API response
        final gameState = GameState.fromJson(json);

        // Ensure only `numPlayers` characters are initialized
        final List<String> spritePaths = List.generate(
          gameState
              .characters.length, // Generate sprites for characters in state
          (index) => 'assets/images/character_${index + 1}.png',
        )..shuffle();

        // Assign sprites to characters
        final List<Character> updatedCharacters =
            gameState.characters.map((character) {
          final spritePath =
              spritePaths.isNotEmpty ? spritePaths.removeLast() : '';
          return Character(
            id: character.id,
            name: character.name,
            role: character.role,
            isAlive: character.isAlive,
            spritePath: spritePath, // Assign sprite
          );
        }).toList();

        // Update the game state with updated characters
        state = GameState(
          gameId: gameState.gameId,
          phase: gameState.phase,
          day: gameState.day,
          characters: updatedCharacters,
          gameOver: gameState.gameOver,
          winner: gameState.winner,
        );

        print("Game initialized successfully with $numPlayers players.");
      } else {
        print(
            "Error: Failed to initialize game. Status Code: ${response.statusCode}");
        print("Error Body: ${response.body}");
        throw Exception('Failed to initialize game: ${response.body}');
      }
    } catch (e) {
      print("Error during initialization: $e");
      throw Exception('Failed to initialize game: $e');
    }
  }

  /// Fetch the current game state from the API.
  Future<void> fetchGameState(String gameId) async {
    final response = await http.get(Uri.parse('$baseUrl/game/$gameId/state'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      state = GameState.fromJson(json);
    } else {
      throw Exception('Failed to fetch game state: ${response.body}');
    }
  }

  /// Fetch discussions from the API and update the state.
  Future<void> fetchDiscussion(String gameId, String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/game/$gameId/discuss'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final responses = (json['responses'] as List<dynamic>)
            .map((response) => DialogueResponse.fromJson(response))
            .toList();

        // Update state with new discussions
        if (state != null) {
          state = GameState(
            gameId: state!.gameId,
            phase: state!.phase,
            day: state!.day,
            characters: state!.characters,
            gameOver: state!.gameOver,
            winner: state!.winner,
            discussions: responses,
          );
        }
      } else {
        throw Exception('Failed to fetch discussion: ${response.body}');
      }
    } catch (e) {
      print("Error fetching discussion: $e");
    }
  }

  /// Handle the voting phase.
  Future<GameState?> vote(String gameId, Character target) async {
    try {
      print("Submitting vote for ${target.name}...");

      final response = await http.post(
        Uri.parse('$baseUrl/game/$gameId/vote'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'target_id': target.id,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final newState = GameState.fromJson(json);

        final updatedCharacters = newState.characters.map((newChar) {
          final oldChar = state?.characters.firstWhere(
            (oldChar) => oldChar.id == newChar.id,
            orElse: () => newChar,
          );

          return Character(
            id: newChar.id,
            name: newChar.name,
            role: newChar.role,
            isAlive: newChar.isAlive,
            spritePath: oldChar!.spritePath,
          );
        }).toList();

        // Debug print to check updatedCharacters
        print("Updated Characters Data:");
        updatedCharacters.forEach((character) {
          print(
              "ID: ${character.id}, Name: ${character.name}, Role: ${character.role}, IsAlive: ${character.isAlive}, SpritePath: ${character.spritePath}");
        });

        // Update the state
        state = GameState(
          gameId: state!.gameId,
          phase: newState.phase,
          day: newState.day,
          characters: updatedCharacters,
          gameOver: newState.gameOver,
          winner: newState.winner,
          eliminatedPlayer: newState.eliminatedPlayer,
          nightMessage: newState.nightMessage,
          discussions: [],
        );

        // Debug print to check updated GameState
        print("Updated GameState:");
        print("Game ID: ${state?.gameId}");
        print("Phase: ${state?.phase}");
        print("Day: ${state?.day}");
        print("Game Over: ${state?.gameOver}");
        print("Winner: ${state?.winner}");
        print("Eliminated Player: ${state?.eliminatedPlayer}");
        print("Night Message: ${state?.nightMessage}");
        print("Characters:");
        state?.characters.forEach((character) {
          print(
              "ID: ${character.id}, Name: ${character.name}, Role: ${character.role}, IsAlive: ${character.isAlive}, SpritePath: ${character.spritePath}");
        });

        return state; // Return the updated state
      } else {
        throw Exception('Failed to submit vote: ${response.body}');
      }
    } catch (e) {
      print("Error during voting: $e");
      return null;
    }
  }

  /// Process the nighttime phase.
  /// Process the nighttime phase and update the game state.
  Future<void> processNight(String gameId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/game/$gameId/night'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        // Parse and update the game state
        final newState = GameState.fromJson(json);

        // Update character sprites from the existing state
        final updatedCharacters = newState.characters.map((newChar) {
          final oldChar = state?.characters.firstWhere(
            (oldChar) => oldChar.id == newChar.id,
            orElse: () => newChar,
          );

          return Character(
            id: newChar.id,
            name: newChar.name,
            role: newChar.role,
            isAlive: newChar.isAlive,
            spritePath:
                oldChar?.spritePath ?? '', // Retain spritePath if available
          );
        }).toList();

        // Update the state
        state = GameState(
          gameId: state!.gameId,
          phase: newState.phase,
          day: newState.day,
          characters: updatedCharacters,
          gameOver: newState.gameOver,
          winner: newState.winner,
          eliminatedPlayer: newState.eliminatedPlayer,
          nightMessage: newState.nightMessage,
          discussions: state?.discussions ?? [],
        );

        // Debug print to verify updated game state
        print("Updated GameState After Night:");
        print("Game ID: ${state?.gameId}");
        print("Phase: ${state?.phase}");
        print("Day: ${state?.day}");
        print("Game Over: ${state?.gameOver}");
        print("Winner: ${state?.winner}");
        print("Eliminated Player: ${state?.eliminatedPlayer}");
        print("Night Message: ${state?.nightMessage}");
        print("Characters:");
        state?.characters.forEach((character) {
          print(
              "ID: ${character.id}, Name: ${character.name}, Role: ${character.role}, IsAlive: ${character.isAlive}, SpritePath: ${character.spritePath}");
        });
      } else {
        throw Exception('Failed to process nighttime: ${response.body}');
      }
    } catch (e) {
      print("Error during nighttime processing: $e");
    }
  }
}
