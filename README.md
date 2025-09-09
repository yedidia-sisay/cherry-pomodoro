# Pomodoro Timer App

A modern, Pomodoro timer qml widget built with PySide6 (Python bindings for Qt) and Qt Quick (QML). 
It features a circular UI with progress rings, sector buttons, notifications via `notify-send`, and automatic session restarting.

<img width="1063" height="932" alt="image" src="https://github.com/user-attachments/assets/398ccc22-807c-43e5-afb1-d21a5193cf6a" />


## Current Features
- **Work/Rest Modes**: Default 25-min work and 5-min rest sessions, customizable via dialog.
- **Auto-Restart**: Seamlessly starts the next session without pausing.
- **Notifications**: Desktop notifications when a session ends (using `notify-send` on Linux).
- **Draggable UI**: Move the timer window around your screen.
- **Visual Feedback**: Color-coded progress ring (crimson for work, lightgreen for rest) and animated messages.
- **Pause/Reset/Set Controls**: Interactive sector buttons for easy control.


## Installation
Clone the repo:
```
git clone https://github.com/YOUR_USERNAME/pomodoro-timer-app.git
cd pomodoro-timer-app
```


Install dependencies:
```
pip install -r requirements.txt
```

For notifications: Install libnotify-bin on Linux (sudo apt install libnotify-bin) and ensure a daemon like dunst is running.

## Usage

Run the app:
python main.py

> in the future will create a small bash script to run things which you can add to path.

Click "Start" to begin.
Use "Pause", "Reset", or "Set" to adjust durations.
When a session ends, it auto-starts the next one and sends a notification.

## Screenshots

<img width="1063" height="932" alt="image" src="https://github.com/user-attachments/assets/398ccc22-807c-43e5-afb1-d21a5193cf6a" />

<img width="1044" height="857" alt="image" src="https://github.com/user-attachments/assets/8ac28fc5-ea3d-42f4-b1ee-44b60d2e087b" />

<img width="977" height="846" alt="image" src="https://github.com/user-attachments/assets/21e37007-fcda-4b6e-a642-234ebbf20a18" />







## Tech Stack
Python 3 with PySide6 for backend logic.
QML for the UI (Qt Quick).
Subprocess for notifications.



## Future Improvements
a load of things
I'm trying to build a widgets based digita world filled with digital objects that one can interact with eachother, and the user. So defining the API for that.
Add sound alerts.
Long breaks after 4 cycles.
Session logging for daily activity tracking.
