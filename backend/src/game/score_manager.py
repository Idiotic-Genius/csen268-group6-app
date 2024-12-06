from typing import Dict, List
from llama_index.llms.openai import OpenAI
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()
os.environ["OPENAI_API_KEY"] = os.getenv("OPENAI_API_KEY")

class ScoreManager:
    def __init__(self):
        self.llm = OpenAI(
            model="gpt-3.5-turbo",
            temperature=0.3
        )

    def initialize_scores(self, num_players: int) -> Dict[str, float]:
        """Initialize relevance scores for a new player"""
        base_score = 1.0 / (num_players - 1)
        return {f"agent_{i+1}": base_score for i in range(num_players)}

    def update_scores_from_conversation(self, 
                                     agent_id: str,
                                     agent_scores: Dict[str, float],
                                     messages: List[Dict],
                                     alive_players: List[str]) -> Dict[str, float]:
        """Update relevance scores based on conversation analysis"""
        updated_scores = agent_scores.copy()

        # Only analyze messages about alive players
        for msg in messages:
            if msg["role"] != agent_id and msg["role"] != "investigator":
                if msg["role"] in alive_players:
                    # Analyze message content
                    suspicion_level = self._analyze_message(msg["content"], alive_players)
                    if suspicion_level is not None:
                        current_score = updated_scores.get(msg["role"], 0.0)
                        updated_scores[msg["role"]] = (0.7 * current_score) + (0.3 * suspicion_level)

        # Set scores for eliminated players to 0
        for player_id in list(updated_scores.keys()):
            if player_id not in alive_players:
                del updated_scores[player_id]

        return self._normalize_scores(updated_scores, agent_id)

    def _analyze_message(self, content: str, alive_players: List[str]) -> float:
        """Analyze message content for suspicious behavior"""
        try:
            # Replace 'player_X' with 'agent_X' in content for consistency
            modified_content = content
            for agent_id in alive_players:
                player_version = agent_id.replace('agent_', 'player_')
                modified_content = modified_content.replace(player_version, agent_id)

            analysis_prompt = (
                "On a scale of 0.0 to 1.0, analyze how suspicious this message is: "
                f"{modified_content}\n"
                "Consider mentions of specific agents (agent_1, agent_2, etc.).\n"
                "Return only a number between 0 and 1."
            )
            
            response = self.llm.complete(analysis_prompt)
            suspicion_level = float(str(response).strip())
            return max(0.0, min(1.0, suspicion_level))
            
        except (ValueError, TypeError):
            return None

    def _normalize_scores(self, scores: Dict[str, float], agent_id: str) -> Dict[str, float]:
        """Normalize scores to ensure they sum to 1"""
        normalized = scores.copy()
        total = sum(score for pid, score in normalized.items() if pid != agent_id)
        
        if total > 0:
            for pid in normalized:
                if pid != agent_id:
                    normalized[pid] = normalized[pid] / total

        return normalized

    def get_most_suspicious(self, scores: Dict[str, float], 
                          agent_id: str,
                          alive_players: List[str]) -> str:
        """Get the most suspicious player from current scores"""
        valid_scores = {
            pid: score for pid, score in scores.items()
            if pid != agent_id and pid in alive_players
        }
        
        if valid_scores:
            return max(valid_scores.items(), key=lambda x: x[1])[0]
        return None

    def remove_player(self, scores: Dict[str, float], 
                     agent_id: str, 
                     eliminated_player: str) -> Dict[str, float]:
        """Update scores when a player is eliminated"""
        updated_scores = scores.copy()
        if eliminated_player in updated_scores:
            # Remove eliminated player's score
            del updated_scores[eliminated_player]
            # Normalize remaining scores
            return self._normalize_scores(updated_scores, agent_id)
        return updated_scores