# src/agents/base_agent.py

from abc import ABC, abstractmethod
from typing import Dict, Optional, List
from llama_index.llms.openai import OpenAI
from enum import Enum
from game.enums import Role  # Changed from game_state
from game.score_manager import ScoreManager
from agents.names import get_random_name

from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()
os.environ["OPENAI_API_KEY"] = os.getenv("OPENAI_API_KEY")

class BaseAgent(ABC):
    def __init__(self, agent_id: str, role: Role, total_players: int):
        self.agent_id = agent_id
        self.name = get_random_name()
        self.role = role
        self.is_alive = True
        self.score_manager = ScoreManager()
        self.relevance_scores = self.score_manager.initialize_scores(total_players)
        self.llm = OpenAI(
            model="gpt-3.5-turbo",
            temperature=0.7
        )

    def _initialize_scores(self, total_players: int) -> None:
        """Initialize relevance scores for other players"""
        base_score = 1.0 / (total_players - 1)
        for i in range(1, total_players + 1):
            other_id = f"agent_{i}"
            if other_id != self.agent_id:
                self.relevance_scores[other_id] = base_score

    def generate_response(self, context: str) -> str:
        """Generate response based on role and context"""
        raise NotImplementedError("Subclasses must implement generate_response")

    def take_night_action(self, alive_players: List[str]) -> Dict:
        """Execute night action based on role"""
        pass

    def update_relevance_scores(self, messages: List[Dict], alive_players: List[str]) -> None:
        """Update relevance scores based on conversation"""
        self.relevance_scores = self.score_manager.update_scores_from_conversation(
            self.agent_id,
            self.relevance_scores,
            messages,
            alive_players
        )

    def _normalize_scores(self) -> None:
        """Normalize relevance scores to sum to 1"""
        total = sum(self.relevance_scores.values())
        if total > 0:
            for agent_id in self.relevance_scores:
                self.relevance_scores[agent_id] /= total

    def get_most_suspicious(self, alive_players: List[str]) -> str:
        """Get the most suspicious player"""
        return self.score_manager.get_most_suspicious(
            self.relevance_scores,
            self.agent_id,
            alive_players
        )


    def remove_player(self, eliminated_player: str) -> None:
        """Handle player elimination"""
        self.relevance_scores = self.score_manager.remove_player(
            self.relevance_scores,
            self.agent_id,
            eliminated_player
        )
