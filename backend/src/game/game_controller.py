# src/game/game_controller.py

import asyncio
from typing import Dict, Optional
from .enums import GamePhase  
from .game_state import GameState
from .action_resolver import ActionResolver
from llm.conversation import AgentConversation

class GameController:
    def __init__(self, num_players: int, num_killers: int):
        self.game_state = GameState(num_players, num_killers)
        self.action_resolver = ActionResolver(self.game_state)
        self.conversation = AgentConversation(self.game_state)
        self.votes = {}
        self.voting_open = False

    def run_game_loop(self):
        """Main game loop"""
        game_over = False
        winner = None

        print("\n=== Game Started ===")
        print(f"Players: {self.game_state.get_alive_players()}")

        while not game_over:
            # Day Phase
            if self.game_state.current_phase == GamePhase.DAY:
                self.run_day_phase()
            # Night Phase
            else:
                self.run_night_phase()

            # Check game end condition
            game_over, winner = self.game_state.check_game_over()
            if not game_over:
                self.game_state.advance_phase()

        print(f"\n=== Game Over ===")
        print(f"Winner: {winner}")
        return winner

    def run_day_phase(self):
        """Handle day phase"""
        print(f"\n=== Day {self.game_state.day_number} ===")
        
        discussion_prompts = [
            "This is really a sad situation. Who do you think is acting suspicious?",
            f"I noticed agent_{self.game_state.day_number} being very defensive, but I don't know what to make of it it.",
            "Does anyone want to defend themselves or saying anything before the day ends and we vote out the killer?"
        ]

        for round_num, prompt in enumerate(discussion_prompts, 1):
            print(f"\n--- Discussion Round {round_num} ---")
            print(f"Investigator: {prompt}")
            
            responses = self.conversation.process_day_discussion(prompt)
            # for response in responses:
            #     print(f"\n{response['role']}: {response['content']}")
            
            # Print updated relevance scores after each round
            print("\nCurrent Suspicion Levels:")
            for agent_id, agent in self.game_state.agents.items():
                if agent.is_alive:
                    print(f"\n{agent_id}'s suspicions:")
                    for target_id, score in sorted(
                        agent.relevance_scores.items(), 
                        key=lambda x: x[1], 
                        reverse=True
                    ):
                        if target_id != agent_id:
                            print(f"  {target_id}: {score:.2f}")
            
            print("\n" + "="*50)
        
        self._handle_day_voting()

    def _handle_day_voting(self, manual_target_id: Optional[str] = None):
        """Handle voting at the end of day phase"""
        print("\n=== Day Voting ===")
        votes = {}
        voting_results = []

        if manual_target_id:
            votes["investigator"] = manual_target_id
            target_name = self.game_state.agents[manual_target_id].name
            voting_results.append({
                "voter": "Investigator",
                "target": target_name
            })

        print(f"Investigator voted for: {manual_target_id}")
        
        # Each living agent votes based on their suspicion levels
        for agent_id, agent in self.game_state.agents.items():
            if agent.is_alive:
                # Vote for most suspicious player
                vote_target = max(agent.relevance_scores.items(), 
                                key=lambda x: x[1] if x[0] != agent_id else -1)[0]
                votes[agent_id] = vote_target
                print(f"{agent_id} votes for {vote_target}")
                voter_name = agent.name
                target_name = self.game_state.agents[vote_target].name
                voting_results.append({
                    "voter": voter_name,
                    "target": target_name
                })

        # Count votes
        vote_counts = {}
        for voted in votes.values():
            vote_counts[voted] = vote_counts.get(voted, 0) + 1

        # Eliminate player with most votes
        if vote_counts:
            eliminated = max(vote_counts.items(), key=lambda x: x[1])[0]
            self.game_state.eliminate_player(eliminated)
            eliminated_name = self.game_state.agents[eliminated].name
            print(f"\n{eliminated} was eliminated by voting!")
        
        return voting_results, eliminated_name

    def run_night_phase(self):
        """Handle night phase"""
        print(f"\n=== Night {self.game_state.day_number} ===")
        
        # Collect and resolve night actions
        self.action_resolver.collect_night_actions()
        night_results = self.action_resolver.resolve_night_actions()
        
        print(night_results['message'])
        print(f"Remaining players: {self.game_state.get_alive_players()}")
        return night_results