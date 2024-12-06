# src/api/routes.py
import uuid
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Dict, Optional
from game.game_controller import GameController

app = FastAPI()

class GameConfig(BaseModel):
    num_players: int
    num_killers: int

class GameState(BaseModel):
    phase: str
    day: int
    players: Dict[str, Dict]

class DiscussionInput(BaseModel):
    message: str

class VoteInput(BaseModel):
    target_id: str


active_games: Dict[str, GameController] = {}

@app.post("/game/start")
async def start_game(config: GameConfig):
    """Initialize a new game"""
    try:
        game = GameController(config.num_players, config.num_killers)
        game_id = str(uuid.uuid4())
        active_games[game_id] = game
        return {
            "game_id": game_id,
            "state": game.game_state.get_game_status_with_roles()
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/game/{game_id}/discuss")
async def process_discussion(game_id: str, input: DiscussionInput):
    """Process a discussion round"""
    if game_id not in active_games:
        raise HTTPException(status_code=404, detail="Game not found")
    
    
    game = active_games[game_id]
    try:
        responses = game.conversation.process_day_discussion(input.message)
        return {
            "responses": responses,
            "state": game.game_state.get_game_status_with_roles()
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/game/{game_id}/vote")
async def handle_day_vote(game_id: str, vote: Optional[VoteInput] = None):
    """Trigger day voting phase"""
    if game_id not in active_games:
        raise HTTPException(status_code=404, detail="Game not found")
    
    game = active_games[game_id]
    try:
        voting_results, eliminated_name = game._handle_day_voting(manual_target_id=vote.target_id if vote else None)
        game_over, winner = game.game_state.check_game_over()
        if not game_over:
            # Only advance phase if game isn't over
            game.game_state.advance_phase()
        return {
            "state": game.game_state.get_game_status_with_roles(),
            "game_over": game_over,
            "winner": winner if game_over else None,
            "voting_results": voting_results,
            "eliminated_player": eliminated_name
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/game/{game_id}/night")
async def process_night(game_id: str):
    """Process night phase"""
    if game_id not in active_games:
        raise HTTPException(status_code=404, detail="Game not found")
    
    game = active_games[game_id]
    try:
        # First collect and resolve night actions
        game.action_resolver.collect_night_actions()
        night_results = game.action_resolver.resolve_night_actions()
        
        eliminated_name = None
        if night_results and night_results.get("killed"):
            eliminated_name = game.game_state.agents[night_results["killed"]].name

        game_over, winner = game.game_state.check_game_over()
        if not game_over:
            game.game_state.advance_phase()
        
        return {
            "state": game.game_state.get_game_status_with_roles(),
            "game_over": game_over,
            "winner": winner if game_over else None,
            "eliminated_player": eliminated_name,
            "night_message": night_results.get("message", "No one was eliminated during the night.") if night_results else "No night actions occurred."
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/game/{game_id}/state")
async def get_game_state(game_id: str):
    """Get current game state"""
    if game_id not in active_games:
        raise HTTPException(status_code=404, detail="Game not found")
    
    game = active_games[game_id]
    game_over, winner = game.game_state.check_game_over()
    
    return {
        "state": game.game_state.get_game_status_with_roles(),
        "game_over": game_over,
        "winner": winner if game_over else None
    }