import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 700
    height: 700
    title: "Circular Layout UI"


    FontLoader {
        id: digitalFont
        source: "fonts/TickingTimebombBb-RB0l.ttf"
    }

    Item {
        id: pomodoro_timer
        anchors.centerIn: parent
        property real size: Math.min(parent.width, parent.height) * 0.5
        width: size
        height: size
        // Ring of circular buttons

        // Progress ring as a proper ring segment
        Canvas {
            id: progressRing
            anchors.centerIn: parent
            
            property real lineWidth:  40  // just outside the center circle
            property real innerRadius: timer_area.width / 2    // just outside the center circle
            readonly property real outerRadius: innerRadius + lineWidth           // thickness of the ring
            property real progress: pomodoroController.remainingTime / (pomodoroController.isWorkMode ? 25*60 : 5*60)
            

            width: outerRadius * 2
            height: outerRadius * 2

            onProgressChanged: requestPaint()
            Behavior on progress { NumberAnimation { duration: 1000 } }


            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.clearRect(0, 0, width, height);

                var cx = width / 2;
                var cy = height / 2;

                var startAngle = -Math.PI / 2;
                var endAngle = startAngle + 2 * Math.PI * progress;

                // Draw the progress ring as a sector between inner and outer radius
                ctx.beginPath();
                ctx.moveTo(cx + innerRadius * Math.cos(startAngle),
                           cy + innerRadius * Math.sin(startAngle));
                ctx.arc(cx, cy, outerRadius, startAngle, endAngle, false);
                ctx.lineTo(cx + innerRadius * Math.cos(endAngle),
                           cy + innerRadius * Math.sin(endAngle));
                ctx.arc(cx, cy, innerRadius, endAngle, startAngle, true);
                ctx.closePath();

                ctx.fillStyle = "crimson";
                ctx.fill();
                ctx.strokeStyle = "crimson";
                ctx.lineWidth = 2;
                ctx.stroke();
            }
        }



        
        // Ring of sector buttons
        Item {
            id: sectorRing
            anchors.centerIn: parent
            property int count: 4
            property real size: 150 // just outside the center circle
            property real innerRadius: progressRing.width/2
            readonly property real outerRadius: innerRadius + size

            property var buttonLabels: ["Start", "Pause", "Reset", "Set"]

            width: outerRadius * 2
            height: outerRadius * 2


            Repeater {
                model: sectorRing.count
                delegate: Item {
                    id: buttonItem
                    width: sectorRing.width
                    height: sectorRing.height
                    property real startAngle: (index / sectorRing.count) * 2 * Math.PI
                    property real endAngle: ((index + 1) / sectorRing.count) * 2 * Math.PI


                    Canvas {
                        id: buttonCanvas
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.reset();
                            ctx.clearRect(0, 0, width, height);

                            var cx = width / 2;
                            var cy = height / 2;

                            ctx.beginPath();
                            ctx.moveTo(
                                cx + sectorRing.innerRadius * Math.cos(startAngle),
                                cy + sectorRing.innerRadius * Math.sin(startAngle)
                            );
                            ctx.arc(cx, cy, sectorRing.outerRadius, startAngle, endAngle, false);
                            ctx.lineTo(
                                cx + sectorRing.innerRadius * Math.cos(endAngle),
                                cy + sectorRing.innerRadius * Math.sin(endAngle)
                            );
                            ctx.arc(cx, cy, sectorRing.innerRadius, endAngle, startAngle, true);
                            ctx.closePath();

                            ctx.fillStyle = "lightblue";
                            ctx.fill();
                            ctx.strokeStyle = "blue";
                            ctx.stroke();
                        }
                        
                    }

                    Text {
                        anchors.centerIn: parent
                        text: sectorRing.buttonLabels[index]
                        font.pixelSize: 20
                        font.family: digitalFont.name
                        color: "white"
                        rotation: -((startAngle + endAngle) / 2 * 180 / Math.PI + 180)
                        transform: Translate {
                            x: (sectorRing.innerRadius + sectorRing.size / 2) * Math.cos((startAngle + endAngle) / 2)
                            y: (sectorRing.innerRadius + sectorRing.size / 2) * Math.sin((startAngle + endAngle) / 2)
                        }
                    }

                MouseArea {
                    id: buttonMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        let px = mouse.x;
                        let py = mouse.y;
                        let cx = width / 2;
                        let cy = height / 2;
                        let dx = px - cx;
                        let dy = py - cy;
                        let angle = Math.atan2(dy, dx);
                        if (angle < 0) angle += 2 * Math.PI;
                        let radius = Math.sqrt(dx * dx + dy * dy);
                        if (radius >= sectorRing.innerRadius && radius <= sectorRing.outerRadius) {
                            let sectorIndex = Math.floor((angle / (2 * Math.PI)) * sectorRing.count);
                            console.log("Clicked sector:", sectorIndex, "at angle:", angle * 180 / Math.PI);
                            if (sectorIndex === 0) pomodoroController.startTimer();
                            else if (sectorIndex === 1) pomodoroController.pauseTimer();
                            else if (sectorIndex === 2) pomodoroController.resetTimer();
                            else if (sectorIndex === 3) console.log("Set button clicked");
                        } else {
                            console.log("Click outside sector ring");
                        }
                    }
                    onPositionChanged: {
                        let px = mouse.x;
                        let py = mouse.y;
                        let cx = width / 2;
                        let cy = height / 2;
                        let dx = px - cx;
                        let dy = py - cy;
                        let angle = Math.atan2(dy, dx);
                        if (angle < 0) angle += 2 * Math.PI;
                        let radius = Math.sqrt(dx * dx + dy * dy);
                        let isHovering = (radius >= sectorRing.innerRadius && radius <= sectorRing.outerRadius &&
                                         angle >= startAngle && angle < endAngle);
                        buttonItem.scale = isHovering ? 1.1 : 1.0;
                    }
                    onExited: buttonItem.scale = 1.0
                    Behavior on scale { NumberAnimation { duration: 200 } }
                    }




                }
            }
        }


        

        // Center circle
        Rectangle {

            id: timer_area
            property real size: Math.min(parent.width, parent.height) * 0.5
            width: size
            height: size
            radius: width / 2
            color: "black"
            anchors.centerIn: parent

            Text {
                id: timerDisplay
                anchors.centerIn: parent
                text: pomodoroController.timeDisplay
                font.pixelSize: timer_area.size * 0.4
                font.family: digitalFont.name  // change to whatever digital font you have installed
                color: "white"
                layer.enabled: true
            }

            Text {
                id: messageDisplay
                anchors {
                    top: timerDisplay.bottom
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
                text: pomodoroController.message
                font.pixelSize: 20
                font.family: "Comic Sans MS"
                color: "yellow"
                opacity: 0
                Behavior on opacity { NumberAnimation { duration: 500 } }
                Connections {
                    target: pomodoroController
                    function onModeChanged() {
                        messageDisplay.opacity = 1
                        messageFade.start()
                    }
                }
                Timer {
                    id: messageFade
                    interval: 3000
                    onTriggered: messageDisplay.opacity = 0
                }
            }
        }



    }
}




