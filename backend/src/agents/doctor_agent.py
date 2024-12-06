# src/agents/doctor_agent.py

from typing import Dict, List, Optional
from .base_agent import BaseAgent
from game.enums import Role
from llm.prompt_templates import get_base_prompt, get_role_specific_prompt

class DoctorAgent(BaseAgent):
    def __init__(self, agent_id: str, total_players: int):
        super().__init__(agent_id, Role.DOCTOR, total_players)
        self.last_saved: Optional[str] = None  # Track last saved player

    def generate_response(self, context: str) -> str:
        """
        Generate doctor-specific responses
        Tries to identify threats while staying under radar
        """
        base_prompt = get_base_prompt(self.agent_id, self.name)
        role_prompt = get_role_specific_prompt(self.role)
        
        response_prompt = (
            f"{base_prompt}\n{role_prompt}\n"
            f"Current conversation:\n{context}\n"
            "Remember to:\n"
            "- Watch for suspicious patterns\n"
            "- Show concern for safety\n"
            "- Stay alert but subtle\n"
            "- NEVER include own agent_id in the response\n"
            "Respond naturally in 1-2 sentences:"
        )

        # print(f"Response prompt here starts: {response_prompt}")
        return self.llm.complete(response_prompt)

    def take_night_action(self, alive_players: List[str]) -> Dict:
        """
        Choose a player to save based on threat assessment
        Cannot save the same player twice in a row
        """
        # Get player with highest suspicion level who isn't last saved
        """Choose a player to save based on suspicion levels"""
        # Updated to pass alive_players
        target = self.get_most_suspicious(alive_players)
        
        # Don't save the same player twice in a row
        if target and target != self.last_saved:
            self.last_saved = target
            return {
                "action": "save",
                "actor": self.agent_id,
                "target": target,
                "success": True
            }
        
        return {
            "action": "save",
            "actor": self.agent_id,
            "target": None,
            "success": False
        }