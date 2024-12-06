from enum import Enum

class Role(Enum):
    KILLER = "killer"
    DOCTOR = "doctor"
    VILLAGER = "villager"

class GamePhase(Enum):
    DAY = "day"
    NIGHT = "night"