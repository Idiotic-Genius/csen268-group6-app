# csen268-group6-app
# Flutter Game with Python Backend

Welcome to the **MAFIA - Murder Mystery in the Woods** repository!

A liitle bit about the game, it is a variant of the popular Mafia party/board game
with the one major difference being that the player plays with AI agent rather than
with other people. Thus, making it a single-player game.

The game takes place in a small town in the woods where murders have been plaguing the town,
you (the player) are an investigator who has been tasked to find and eliminate the killers.
You will need to converse with the townspeople to figure out whose lying or telling the truth
and determine based on their accounts who the killers are and save the town.

---

## 🗂️ Project Structure


---

## 🚀 Features

- **Authenticated Signup/Login:** ...
- **Landscape Orientation Locking:** To avoid disruptions between in and out of game screens we have ensured that the orientation of the game is locked to Landscape.
- **Animated Splash Screen:** The animated splash screen was implmeneted using Lottie for the animations and a simple delay timer to showcase the animation before routing users to the Firebase Authencation Wrapper.
- **Animated Buttons:** Due the simplicity of these animations, we used Flutters in-built Animation class to implement these simple transform animations that simulate a button press.
- **Background Music:** ...
- **Adjustable Game Settings:** ...
- **Profile Statistics Tracking:** ...
- **Dialogue System with AI integration:** ...
- **Voting System:** ...
- **Decision Making System:** ...
- **Game State Tracking:** ...
- **Win/Lose Conditions:** ...

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
   cd backend/src
   python main.py
   ```

### Frontend Setup
1. Ensure that the backend server is running before launch the frontend flutter app.
(Note: If the server is not running properly then the game will not start upon pressing the play button on the Home Page.)
2. Navigate to the `frontend` folder and get all the required dependencies with:
    ```bash
    cd frontend
    flutter pub get
    ```
3. Navigate to the `main.dart` file in the `frontend` folder and run the flutter app.

