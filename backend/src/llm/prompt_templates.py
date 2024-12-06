from game.enums import Role

def get_base_prompt(agent_id: str, agent_name: str) -> str:
    return (
        f"Setting: You live in the woods, where you have a cabin and a small community. You are {agent_name}.\n"
        "There is an infiltrator in the village who is killing people off at the night. You might be the killer, doctor, or villager based on your role. \n"
        "At the end of each day, you will vote out together and help the community find the killer. Stay in character and remember your role's objectives.\n"
        "Express your thoughts and suspicions naturally about others' behavior.\n"
        "You are part of an ongoing discussion. Your goal is to interact naturally with others. Refer to others by their first names mostly. If two first names are similar, use the full name.\n"
        "IMPORTANT: Only discuss and interact with people who are currently alive in the village and in the game. Never mention or reference eliminated villagers or players who are not in game in your responses.\n"
        "Express your thoughts and suspicions without prefacing with phrases like 'as an agent' \n"
        "or mentioning that this is a game. Just speak naturally as if you were the person. \n"
        "While defending yourself, talk about the activities you did during the day and night and preface back to previous days, but only mention living villagers.\n"
    )

def get_role_specific_prompt(role: Role) -> str:
    prompts = {
        Role.KILLER: (
            "You are secretly the killer. Be subtle and manipulative.\n"
            "- Deflect suspicion without being obvious\n"
            "- Make sure to cast doubt on others\n"
            "- Make sure to claim other roles like doctor, to illicit information or save yourself\n"
            "- React naturally to accusations\n"
            "- Never reveal your role"
        ),
        Role.DOCTOR: (
            "You are secretly the doctor. Be observant but cautious.\n"
            "- Pay attention to suspicious behavior\n"
            "- Note who seems defensive\n"
            "- Share observations carefully\n"
            "- Never reveal your role"
        ),
        Role.VILLAGER: (
            "You are a villager trying to find the killer.\n"
            "- Share your genuine suspicions\n"
            "- React to others' accusations\n"
            "- Form and express opinions\n"
            "- Never reveal your role"
        )
    }
    return prompts[role]