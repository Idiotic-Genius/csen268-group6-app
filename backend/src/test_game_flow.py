# # src/test_game_flow.py
# import os
# from game.game_state import GameState
# from llm.conversation import AgentConversation

# def print_relevance_scores(game_state):
#     print("\n=== Current Suspicion Levels ===")
#     for player_id, player in game_state.players.items():
#         if player.is_alive:
#             print(f"\n{player_id} suspects:")
#             for target_id, score in sorted(player.relevance_scores.items(), key=lambda x: x[1], reverse=True):
#                 if target_id != player_id:
#                     suspicion = "High" if score > 0.4 else "Medium" if score > 0.25 else "Low"
#                     print(f"  {target_id}: {score:.2f} ({suspicion} suspicion)")

# def test_game_flow():
#     try:
#         # Initialize game
#         print("=== Game Start ===")
#         game = GameState(num_players=4, num_killers=1)
#         conversation = AgentConversation(game)

#         print("\nRole Distribution (DEBUG):")
#         for player_id, player in game.players.items():
#             print(f"{player_id}: {player.role.value}")

#         # Initial scores
#         print("\n=== Initial Suspicion Levels ===")
#         print_relevance_scores(game)

#         # Conversation rounds with context
#         conversation_rounds = [
#             "Agent_1 has been very quiet so far. Seems suspicious.",
#             "Interesting how Agent_3 jumped to defend Agent_1...",
#             "Agent_2's arguments don't add up. They keep deflecting.",
#             "I've been watching Agent_4 - they're trying to stay under the radar."
#         ]

#         for round_num, investigator_input in enumerate(conversation_rounds, 1):
#             print(f"\n\n=== Round {round_num} ===")
#             print(f"Investigator: {investigator_input}")
            
#             responses = conversation.process_day_conversation(investigator_input)
            
#             # Print responses
#             for response in responses:
#                 print(f"\n{response['role']}: {response['content']}")
            
#             # Show updated suspicion levels after each round
#             print_relevance_scores(game)
#             print("\n" + "="*50)

#     except Exception as e:
#         print(f"Error during game flow: {e}")

# if __name__ == "__main__":
#     test_game_flow()

# src/test_game_loop.py

import asyncio
from game.game_controller import GameController

def test_full_game():
    try:
        # Initialize game with 4 players, 1 killer
        controller = GameController(num_players=6, num_killers=1)
        
        # Print initial roles for debugging
        print("\nRole Distribution (DEBUG):")
        for agent_id, agent in controller.game_state.agents.items():
            print(f"{agent_id}: {agent.role.value}")

        # Run the game
        winner = controller.run_game_loop()
        
        print("\nGame Summary:")
        print(f"Winner: {winner}")
        print("Final game state:", controller.game_state.get_game_status())

    except Exception as e:
        print(f"Error during game: {e}")
        import traceback
        print(traceback.format_exc())

if __name__ == "__main__":
    test_full_game()