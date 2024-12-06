from typing import Dict, List
import random
from .base_agent import BaseAgent
from .killer_agent import KillerAgent
from .doctor_agent import DoctorAgent
from .villager_agent import VillagerAgent
from game.enums import Role  # Changed from game_state

class AgentFactory:
    @staticmethod
    def create_agents(num_players: int, num_killers: int) -> Dict[str, BaseAgent]:
        """
        Create and initialize all agents for the game
        """
        if not AgentFactory.validate_game_config(num_players, num_killers):
            raise ValueError("Invalid game configuration")

        # Create role distribution
        roles = [Role.KILLER] * num_killers
        roles.append(Role.DOCTOR)  # Always one doctor
        roles.extend([Role.VILLAGER] * (num_players - num_killers - 1))
        random.shuffle(roles)

        # Create agents
        agents = {}
        for i in range(num_players):
            agent_id = f"agent_{i+1}"
            role = roles[i]

            if role == Role.KILLER:
                agent = KillerAgent(agent_id, num_players)
            elif role == Role.DOCTOR:
                agent = DoctorAgent(agent_id, num_players)
            else:
                agent = VillagerAgent(agent_id, num_players)

            agents[agent_id] = agent

        return agents

    @staticmethod
    def validate_game_config(num_players: int, num_killers: int) -> bool:
        """
        Validate game configuration
        - Minimum 4 players
        - At least 1 killer
        - Maximum killers is less than half of players
        - Must have room for 1 doctor and at least 1 villager
        """
        if num_players < 4:
            return False
        if num_killers < 1:
            return False
        if num_killers >= num_players / 2:
            return False
        if (num_killers + 2) > num_players:  # +2 for doctor and at least one villager
            return False
        return True