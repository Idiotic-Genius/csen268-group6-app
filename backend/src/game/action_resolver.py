# src/game/action_resolver.py

from typing import Dict, List, Optional
from agents.base_agent import BaseAgent
from .game_state import GameState, Role

class ActionResolver:
    def __init__(self, game_state: GameState):
        self.game_state = game_state
        self.night_actions: List[Dict] = []

    def collect_night_actions(self) -> None:
        """Collect night actions from all living agents"""
        self.night_actions = []
        alive_players = self.game_state.get_alive_players()
        
        for agent_id, agent in self.game_state.agents.items():
            if agent.is_alive:
                action = agent.take_night_action(alive_players)
                if action["success"]:
                    self.night_actions.append(action)

    def resolve_night_actions(self) -> Dict:
        """
        Resolve all night actions and return results
        Order: Doctor saves -> Killer kills
        """
        killed_player = None
        saved_player = None
        resolution_message = ""

        # Process doctor's save action first
        for action in self.night_actions:
            if action["action"] == "save":
                saved_player = action["target"]
                break

        # Process killer's action
        for action in self.night_actions:
            if action["action"] == "kill":
                target = action["target"]
                if target != saved_player:
                    killed_player = target
                    target_name = self.game_state.agents[target].name
                    self.game_state.eliminate_player(target)
                    resolution_message = f"{target_name} was eliminated during the night."
                else:
                    resolution_message = "The doctor successfully saved their target!"
                break

        return {
            "killed": killed_player,
            "saved": saved_player,
            "message": resolution_message
        }