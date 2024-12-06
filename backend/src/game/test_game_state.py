# src/test_game_flow.py
import os
from game.game_state import GameState
from llm.conversation import AgentConversation

def print_relevance_scores(game_state, round_num):
    print(f"\n=== Relevance Scores after Round {round_num} ===")
    for player_id, player in game_state.players.items():
        if player.is_alive:
            print(f"\n{player_id}'s suspicions:")
            for target_id, score in player.relevance_scores.items():
                if target_id != player_id:
                    print(f"  {target_id}: {score:.2f}")

def test_game_flow():
    try:
        # Initialize game
        print("=== Initializing Game ===")
        game = GameState(num_players=4, num_killers=1)
        conversation = AgentConversation(game)

        # Print initial roles (for debugging)
        print("\nRole Distribution (DEBUG):")
        for player_id, player in game.players.items():
            print(f"{player_id}: {player.role.value}")

        # Several rounds of conversation with different triggers
        conversation_rounds = [
            # Round 1: Initial suspicion
            "Agent_1 has been very quiet. What do you all think?",
            
            # Round 2: Deflection attempt
            "Agent_3 seems to be deflecting attention to others. Suspicious?",
            
            # Round 3: Defense
            "Agent_2 hasn't contributed much to finding the killer.",
            
            # Round 4: Alliance forming
            "I agree with Agent_4's observations about Agent_1.",
            
            # Round 5: Pressure mounting
            "The evidence against Agent_1 is mounting. How do you defend yourself?"
        ]

        # Process each round
        for round_num, investigator_input in enumerate(conversation_rounds, 1):
            print(f"\n\n=== Round {round_num} ===")
            print(f"\nInvestigator: {investigator_input}")
            
            # Get responses
            responses = conversation.process_day_conversation(investigator_input)
            
            # Print responses
            print("\nResponses:")
            for response in responses:
                print(f"{response['role']}: {response['content']}")
            
            # Print updated relevance scores
            print_relevance_scores(game, round_num)
            
            print("\n" + "="*50)

    except Exception as e:
        print(f"Error during game flow: {e}")
        import traceback
        print(traceback.format_exc())

if __name__ == "__main__":
    test_game_flow()