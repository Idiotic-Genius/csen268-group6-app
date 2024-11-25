import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_state.dart';

class NighttimePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStateNotifier = ref.read(gameStateProvider.notifier);
    final gameState = ref.watch(gameStateProvider);

    // Random number generator
    final Random random = Random();

    // Determine the killers' target
    Character? getKillersTarget() {
      final killers = gameState.characters.where((c) => c.role == 'Killer').toList();
      final potentialTargets = gameState.characters
          .where((c) => !killers.contains(c)) // Exclude killers from targets
          .toList();

      if (potentialTargets.isEmpty) return null;
      return potentialTargets[random.nextInt(potentialTargets.length)];
    }

    // Determine the doctor's save
    Character? getDoctorsSave() {
      final doctors = gameState.characters.where((c) => c.role == 'Doctor').toList();
      if (doctors.isEmpty) return null;

      return gameState.characters[random.nextInt(gameState.characters.length)];
    }

    // Resolve nighttime actions and return outcome message
    void resolveNighttimeActions(BuildContext context) {
      final killersTarget = getKillersTarget();
      final doctorsSave = getDoctorsSave();
      String outcome;

      if (killersTarget == null) {
        outcome = "No one left to target.";
      } else if (doctorsSave != null && doctorsSave == killersTarget) {
        outcome = "The killer tried to kill ${killersTarget.name}, but they were saved by the doctor!";
      } else {
        gameStateNotifier.eliminateCharacter(killersTarget!);
        outcome = "The killer successfully eliminated ${killersTarget.name}!";
      }

      // Show dialog with the outcome
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Nighttime Outcome"),
            content: Text(outcome),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to daytime phase
                },
                child: Text("Back to Daytime"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Stack(
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
                  "Nighttime Actions",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => resolveNighttimeActions(context),
                  child: Text("Resolve Actions"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
