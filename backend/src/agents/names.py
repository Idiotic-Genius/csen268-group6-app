import random

FIRST_NAMES = [
    "Alex", "Blair", "Casey", "Drew", "Eden", 
    "Finn", "Gray", "Harper", "Indigo", "Jordan",
    "Kelly", "Logan", "Morgan", "Noah", "Parker",
    "Quinn", "Riley", "Sage", "Taylor", "Val"
]

LAST_NAMES = [
    "Woods", "River", "Stone", "Field", "Hill",
    "Lake", "Storm", "Frost", "Rain", "Snow",
    "Brook", "Dale", "Grove", "Vale", "Glen",
    "Marsh", "Peak", "Ridge", "Shore", "Mist"
]

def get_random_name() -> str:
    first = random.choice(FIRST_NAMES)
    last = random.choice(LAST_NAMES)
    return f"{first} {last}" 