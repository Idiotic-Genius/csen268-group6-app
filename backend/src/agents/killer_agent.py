# src/agents/killer_agent.py

from typing import Dict, List
from .base_agent import BaseAgent
from game.enums import Role
from llm.prompt_templates import get_base_prompt, get_role_specific_prompt

class KillerAgent(BaseAgent):
    def __init__(self, agent_id: str, total_players: int):
        super().__init__(agent_id, Role.KILLER, total_players)

    def generate_response(self, context: str) -> str:
        """
        Generate killer-specific responses
        Tries to deflect suspicion and blend in
        """
        base_prompt = get_base_prompt(self.agent_id, self.name)
        role_prompt = get_role_specific_prompt(self.role)
        
        response_prompt = (
            f"{base_prompt}\n{role_prompt}\n"
            f"Current conversation:\n{context}\n"
            "Remember to:\n"
            "- Deflect suspicion subtly\n"
            "- Sometimes cast doubt on others\n"
            "- Maintain innocent appearance\n"
            "- NEVER include own agent_id in the response\n"
            "Respond naturally in 1-2 sentences:"
        )

        # print(f"Response prompt here starts: {response_prompt}")
        return self.llm.complete(response_prompt)

    def take_night_action(self, alive_players: List[str]) -> Dict:
        """
        Choose a player to eliminate based on relevance scores
        Returns action details
        """
        target = self.get_most_suspicious(alive_players)
        
        if target:
            return {
                "action": "kill",
                "actor": self.agent_id,
                "target": target,
                "success": True
            }
        
        return {
            "action": "kill",
            "actor": self.agent_id,
            "target": None,
            "success": False
        }