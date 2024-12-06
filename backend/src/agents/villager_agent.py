# src/agents/villager_agent.py

from typing import Dict, List
from .base_agent import BaseAgent
from game.enums import Role
from llm.prompt_templates import get_base_prompt, get_role_specific_prompt

class VillagerAgent(BaseAgent):
    def __init__(self, agent_id: str, total_players: int):
        super().__init__(agent_id, Role.VILLAGER, total_players)

    def generate_response(self, context: str) -> str:
        """
        Generate villager-specific responses
        Focus on analyzing behavior and identifying suspicious patterns
        """
        base_prompt = get_base_prompt(self.agent_id, self.name)
        role_prompt = get_role_specific_prompt(self.role)
        
        response_prompt = (
            f"{base_prompt}\n{role_prompt}\n"
            f"Current conversation:\n{context}\n"
            "Remember to:\n"
            "- Share honest observations\n"
            "- Express real concerns\n"
            "- Help find the truth\n"
            "- NEVER include own agent_id in the response\n"
            "Respond naturally in 1-2 sentences:"
        )

        # print(f"Response prompt here starts: {response_prompt}")
        return self.llm.complete(response_prompt)


    def take_night_action(self, alive_players: List[str]) -> Dict:
        """
        Villagers don't have night actions, but must implement the method
        """
        return {
            "action": "observe",
            "actor": self.agent_id,
            "target": None,
            "success": True
        }

    def update_suspicion_based_on_discussion(self, discussion_context: str) -> None:
        """
        Special method for villagers to analyze discussion and update suspicions
        """
        # This will be implemented with more sophisticated analysis
        pass