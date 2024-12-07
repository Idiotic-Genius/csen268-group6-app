# csen268-group6-app | Flutter Game with Python Backend

Welcome to the **MAFIA - Murder Mystery in the Woods** repository!

A liitle bit about the game, it is a variant of the popular Mafia party/board game
with the one major difference being that the player plays with AI agent rather than
with other people. Thus, making it a single-player game.

The game takes place in a small town in the woods where murders have been plaguing the town,
you (the player) are an investigator who has been tasked to find and eliminate the killers.
You will need to converse with the townspeople to figure out whose lying or telling the truth
and determine based on their accounts who the killers are and save the town.

---

## 🚀 Features

- **Authenticated Signup/Login:** User authentication for login and signup, as well as user statistics management, are implemented using Firebase Authentication and Firebase Realtime Database.
- **Landscape Orientation Locking:** To avoid disruptions between in and out of game screens we have ensured that the orientation of the game is locked to Landscape.
- **Animated Splash Screen:** The animated splash screen was implmeneted using Lottie for the animations and a simple delay timer to showcase the animation before routing users to the Firebase Authencation Wrapper.
- **Animated Buttons:** Due the simplicity of these animations, we used Flutters in-built Animation class to implement these simple transform animations that simulate a button press.
- **Adjustable Game Settings:** We can set the number of villagers, number of killers, and the number of doctors in the game.
- **Profile Statistics Tracking:** We track the number of games played, won, and lost.
- **Dialogue System with AI integration:** We use the OpenAI API to generate dialogue for the agents based on their role. Each agent is given different instructions to follow which are also differentiated at player dialogue and action buttons.
- **Voting System:** At the end of each day, each agent will vote on who they think is a killer. You The agent with the most votes is eliminated.
- **Decision Making System:** Each agent maintains a suspicion score for each other agent. This is updated after each interaction and the context provided by us. 
- **Game State Tracking:** We are using the Riverpod state management system to manage the state of the game across the entire app. 
- **Win/Lose Conditions:** If the number of killers somehow equals the number of townspeople then the killers win, otherwise the villagers/investigators win.

---

## 🛠️ Tech Stack

### Frontend
- **Framework:** Flutter / Firebase / Firestore
- **Programming Language:** Dart

### Backend
- **Framework:** FastAPI / Llamaindex / OpenAI
- **Programming Language:** Python

---

## 📦 Installation

### Prerequisites
- Flutter SDK [Installation Guide](https://flutter.dev/docs/get-started/install)
- Python 3.10 [Installation Guide](https://www.python.org/downloads/)

### Backend Setup
1. Navigate to the `backend` folder and run the main.py:
   ```bash
   python -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   cd backend/src
   python main.py
   ```
2. Ensure that the backend server is running before launching the frontend flutter app.
3. The backend server will be hosted on `localhost` with default port `8000`.
4. Then go to http://localhost:8000/docs and check out end-points.
5. The agents are prompted with a set of character descriptions and a set of rules to follow. You can modify these in the `backend/src/agents/{role}_agent.py` file and `backend/src/llm/prompt_templates.py` file.

### Frontend Setup
1. Ensure that the backend server is running before launch the frontend flutter app.
(Note: If the server is not running properly then the game will not start upon pressing the play button on the Home Page.)
2. Navigate to the `frontend` folder and get all the required dependencies with:
    ```bash
    cd frontend
    flutter pub get
    flutter run
    ```
3. Run the Flutter app.
    ```bash
    flutter run
    ```
---

## 🎮 Gameplay Overview

### Day Phase
Make a statement to townspeople and listen to their responses to gather information.
Decide who the suspect may be based on the AI-generated dialogue.
### Voting Phase
Players and AI agents vote on the suspected killer.
The individual with the most votes is eliminated.
### Night Phase
AI agents perform their roles: killers choose a victim, doctors attempt to save lives, and townsfolk sleep.
Goes back to the Day Phase until a win/lose condition is met.
### Winning or Losing
Win: Eliminate all the killers before they outnumber the townspeople.
Lose: If killers equal or outnumber townspeople, the killers win.

---

## 🌟 Screenshots

![image](https://github.com/user-attachments/assets/6e1dc4ee-642b-4747-bdcb-31de3f31c388)
![image](https://github.com/user-attachments/assets/330510a1-cd37-41dc-a0b3-c0dcdfb66559)
![image](https://github.com/user-attachments/assets/56601136-b313-488e-8e6b-b22fc5535b1e)
![image](https://github.com/user-attachments/assets/d681dba5-1ac0-46c8-b3f3-a32ac0baa6f2)
![image](https://github.com/user-attachments/assets/3250a02d-3aa5-42f4-959d-539a17b609a9)
![image](https://github.com/user-attachments/assets/0a923953-d89e-4349-b40d-5fe4a14f3a41)
![image](https://github.com/user-attachments/assets/358e2f10-c542-4522-89c7-c15f3fe0fef3)
![image](https://github.com/user-attachments/assets/ecf8c814-ef78-4af9-b7fb-0ce3f512c0d6)

---

## 💡 Future Plans

### Tracking Wins and Losses on User Profiles
Adding functionality to record and display users' game outcomes (wins and losses) on their profile within the backend system.

### Game Settings Configuration
​Adjusting game settings and saving it to be reflected when the next game is started.

### Improving UI Elements 
​Some UI elements like the logout, dialogue buttons, and sliders aren't all uniform in style.

### Dialogue History 
​Give the ability for the users to look back on what all the characters have said in the past to better deduce whose who.

### Sound Effects / Music / VoiceOvers 
​Additional music and sound effects for button presses and or voice overs for the character dialogues would be bring the game to life.
