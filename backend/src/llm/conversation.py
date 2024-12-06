# src/llm/conversation.py

from typing import Dict, List
from llama_index.core.agent import ReActAgent
from llama_index.llms.openai import OpenAI
from game.game_state import GameState
from .prompt_templates import get_base_prompt, get_role_specific_prompt
from agents.base_agent import BaseAgent
from threading import Lock

from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()
os.environ["OPENAI_API_KEY"] = os.getenv("OPENAI_API_KEY")

conversation_lock = Lock()

class AgentConversation:
    def __init__(self, game_state: GameState):
        self.game_state = game_state
        self.context = []
        self.llm = OpenAI(
            model="gpt-3.5-turbo",
            temperature=0.2,
        )
        self.initialize_llm_agents()

    def initialize_llm_agents(self):
        """Initialize LLM agents for each game agent"""
        self.llm_agents: Dict[str, ReActAgent] = {}
        
        for agent_id, agent in self.game_state.agents.items():
            system_prompt = self._create_agent_prompt(agent)
            self.llm_agents[agent_id] = ReActAgent.from_tools(
                tools=[],
                llm=self.llm,
                system_prompt=system_prompt,
                verbose=False
            )

    def _create_agent_prompt(self, agent: BaseAgent) -> str:
        """Create role-specific prompt for each agent"""
        base = get_base_prompt(agent.agent_id, agent.name)
        role_specific = get_role_specific_prompt(agent.role)
        
        # Add current suspicions more naturally
        suspicion_context = "\nCurrent suspicions:"
        for pid, score in sorted(agent.relevance_scores.items(), 
                            key=lambda x: x[1], 
                            reverse=True):
            if pid != agent.agent_id:
                level = "highly" if score > 0.4 else "moderately" if score > 0.25 else "slightly"
                suspicion_context += f"\n- You find {pid} {level} suspicious"
        
        return (
            f"{base}\n{role_specific}\n{suspicion_context}\n"
            "Respond naturally to the conversation in 1-2 sentences. "
            "Don't mention tools or analysis directly."
        )

    def process_day_discussion(self, investigator_input: str = None) -> List[Dict]:
        responses = []
        alive_players = self.game_state.get_alive_players()
        
        if investigator_input:
            self.context.append({
                "role": "investigator",
                "content": investigator_input,
                "day": self.game_state.day_number
            })

        for agent_id, agent in self.game_state.agents.items():
            if not agent.is_alive:
                continue

            prompt = self._prepare_discussion_context(agent_id)
            response = agent.generate_response(prompt)
            print(f"Response here starts: {agent_id}: {response}")
            
            response_data = {
                "role": agent_id,
                "content": str(response).strip(),
                "day": self.game_state.day_number
            }
            
            self.context.append(response_data)
            responses.append(response_data)
            
            # Update scores with current context and alive players
            agent.update_relevance_scores(self.context, alive_players)

        return responses

    def _prepare_discussion_context(self, current_agent_id: str) -> str:
        agent = self.game_state.agents[current_agent_id]
        alive_players = self.game_state.get_alive_players()
        
        # Get names of alive players
        alive_names = [self.game_state.agents[pid].name for pid in alive_players]
        
        context = (
            "Respond naturally to this ongoing discussion. "
            "Share your thoughts about others' behavior and defend yourself if needed. "
            f"Currently alive villagers: {', '.join(alive_names)}. "
            "Only reference these people in your response.\n\n"
            "Recent conversation:\n"
        )
        
        # Add today's conversation
        day_messages = [msg for msg in self.context 
                    if msg["day"] == self.game_state.day_number]
        for msg in day_messages:
            agent_name = self.game_state.agents[msg["role"]].name if msg["role"] != "investigator" else "Investigator"
            context += f"{agent_name}: {msg['content']}\n"

        return context

    def _analyze_and_update_scores(self, agent_id: str, context: List[Dict]) -> None:
        """Analyze conversation and update relevance scores"""
        agent = self.game_state.agents[agent_id]
        agent.update_relevance_scores(self.context)


    def _normalize_scores(self, agent: BaseAgent) -> None:
        """Ensure all relevance scores sum to 1"""
        total = sum(score for pid, score in agent.relevance_scores.items() 
                    if pid != agent.agent_id)
        
        if total > 0:
            for pid in agent.relevance_scores:
                if pid != agent.agent_id:
                    agent.relevance_scores[pid] /= total

    def clear_context(self) -> None:
        """Clear conversation context"""
        self.context = []