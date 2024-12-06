from typing import Dict, Optional
from enum import Enum
from agents.agent_factory import AgentFactory
from agents.base_agent import BaseAgent
from .enums import GamePhase, Role
from agents.agent_factory import AgentFactory

class GameState:
    def __init__(self, num_players: int, num_killers: int):
        self.num_players = num_players
        self.num_killers = num_killers
        self.current_phase = GamePhase.DAY
        self.day_number = 1
        self.agents: Dict[str, BaseAgent] = {}
        self.initialize_game()

    def initialize_game(self) -> None:
        """Initialize game with agents"""
        try:
            self.agents = AgentFactory.create_agents(self.num_players, self.num_killers)
        except ValueError as e:
            raise ValueError(f"Failed to initialize game: {str(e)}")

    def get_alive_players(self) -> list[str]:
        """Get list of alive player IDs"""
        return [agent_id for agent_id, agent in self.agents.items() 
                if agent.is_alive]

    def eliminate_player(self, player_id: str) -> None:
        """Mark a player as eliminated and update other agents"""
        if player_id in self.agents:
            self.agents[player_id].is_alive = False
            # Update relevance scores for all remaining agents
            for agent in self.agents.values():
                if agent.is_alive:
                    agent.remove_player(player_id)

    def advance_phase(self) -> None:
        """Advance to next game phase"""
        if self.current_phase == GamePhase.DAY:
            self.current_phase = GamePhase.NIGHT
        else:
            self.current_phase = GamePhase.DAY
            self.day_number += 1

    def check_game_over(self) -> tuple[bool, Optional[str]]:
        """
        Check if game is over
        Returns: (is_game_over, winner)
        """
        alive_players = self.get_alive_players()
        alive_killers = [pid for pid in alive_players 
                        if self.agents[pid].role == Role.KILLER]
        
        # Killers win if they equal or outnumber others
        if len(alive_killers) >= len(alive_players) - len(alive_killers):
            return True, "killers"
        # Villagers win if all killers are eliminated
        elif not alive_killers:
            return True, "villagers"
        # Game continues
        return False, None

    def get_game_status(self) -> Dict:
        """Get public game state (without revealing roles)"""
        return {
            "phase": self.current_phase.value,
            "day": self.day_number,
            "players": {
                pid: {
                    "is_alive": agent.is_alive,
                    "name": agent.name
                } for pid, agent in self.agents.items()
            }
        }
    
    def get_game_status_with_roles(self) -> Dict:
        """Get public game state including roles (for API/debugging only)"""
        return {
            "phase": self.current_phase.value,
            "day": self.day_number,
            "players": {
                pid: {
                    "is_alive": agent.is_alive,
                    "role": agent.role.value,
                    "name": agent.name
                } for pid, agent in self.agents.items()
            }
        }