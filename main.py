from os import wait
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QTimer, QObject, Signal, Slot, Property, QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
import sys
import subprocess

    
class PomodoroController(QObject):
    timeUpdated = Signal()
    modeChanged = Signal()

    def __init__(self):
        super().__init__()
        self._remainingTime = 25 * 60  # Default 25 minutes (work)
        self._workDuration = 25 * 60   # Default work duration in seconds
        self._restDuration = 5 * 60    # Default rest duration in seconds
        self._isWorkMode = True
        self._isRunning = False
        self._autoStart = True
        self._message = "Let's get crunchin'!"
        self.timer = QTimer()
        self.timer.setInterval(1000)  # 1 second
        self.timer.timeout.connect(self.updateTimer)


    @Property(bool, notify=modeChanged)
    def autoStart(self):
        return self._autoStart

    @autoStart.setter
    def autoStart(self, value):
        self._autoStart = value
        self.modeChanged.emit()

    @Property(int, notify=timeUpdated)
    def remainingTime(self):
        return self._remainingTime

    @Property(bool, notify=modeChanged)
    def isWorkMode(self):
        return self._isWorkMode

    @Property(str, notify=timeUpdated)
    def timeDisplay(self):
        minutes = self._remainingTime // 60
        seconds = self._remainingTime % 60
        return f"{minutes:02d}:{seconds:02d}"

    @Property(str, notify=modeChanged)
    def message(self):
        return self._message

    @Property(str, notify=modeChanged)
    def ringColor(self):
        return "crimson" if self._isWorkMode else "lightgreen"

    @Slot()
    def startTimer(self):
        if not self._isRunning:
            self._isRunning = True
            self.timer.start()
            self._message = "Let's get crunchin'!" if self._isWorkMode else "Time to munch on some rest!"
            self.modeChanged.emit()

    @Slot()
    def pauseTimer(self):
        if self._isRunning:
            self._isRunning = False
            self.timer.stop()
            self._message = "Paused - catch your breath!"
            self.modeChanged.emit()
    @Slot()
    def resetTimer(self):
        self.timer.stop()
        self._isRunning = False
        self._isWorkMode = not self._isWorkMode  # Switch to next mode
        self._remainingTime = self._workDuration if self._isWorkMode else self._restDuration
        self._message = "Switched to next mode - ready to start!"
        self.timeUpdated.emit()
        self.modeChanged.emit()

    @Slot(int, int)
    def setTimer(self, workMinutes, restMinutes):
        self._workDuration = max(1, workMinutes) * 60  # Convert to seconds, minimum 1 minute
        self._restDuration = max(1, restMinutes) * 60  # Convert to seconds, minimum 1 minute
        self._remainingTime = self._workDuration if self._isWorkMode else self._restDuration
        self._message = f"Set to {workMinutes} min work, {restMinutes} min rest!"
        self.timeUpdated.emit()
        self.modeChanged.emit()


    def updateTimer(self):
        if self._remainingTime > 0:
            self._remainingTime -= 1
            self.timeUpdated.emit()
        else:
            self._isWorkMode = not self._isWorkMode
            self._remainingTime = self._workDuration if self._isWorkMode else self._restDuration
            self._message = "Crushed it! Time to chill!" if not self._isWorkMode else "Back to work, cereal winner!"
            self.send_notification("Pomodoro Session Complete",
                                  f"{'Work' if not self._isWorkMode else 'Rest'} session ended!")
            if self._autoStart:
                self._isRunning = True
                self.timer.start()
            else:
                self._isRunning = False
                self.timer.stop()
            self.timeUpdated.emit()
            self.modeChanged.emit()

    def send_notification(self, title, message):
        """Send a desktop notification using notify-send."""
        try:
            subprocess.run(['notify-send', title, message], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Failed to send notification: {e}")
        except FileNotFoundError:
            print("notify-send not found. Please ensure it is installed or use a notification daemon like dunst.")


def main():
    # Initialize the Qt application
    app = QApplication(sys.argv)
    
    # Set up the QML engine and link the canvas object
    engine = QQmlApplicationEngine()
    
    controller = PomodoroController()
    engine.rootContext().setContextProperty("pomodoroController", controller)
    # Load the QML file
    engine.load(QUrl.fromLocalFile("main.qml"))
    
    # Check if the QML loaded successfully
    if not engine.rootObjects():
        sys.exit(-1)
    
    # Start the Qt event loop
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
