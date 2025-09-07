import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 700
    height: 700
    title: "Circular Layout UI"



     Item {
        anchors.centerIn: parent
        property real size: Math.min(parent.width, parent.height) * 0.5
        width: size
        height: size

        // Center circle
        Rectangle {
            id: timer_area
            property real size: Math.min(parent.width, parent.height) * 0.5
            width: size
            height: size
            radius: width / 2
            color: "black"
            anchors.centerIn: parent
        }


        // Ring of circular buttons

        // Progress ring as a proper ring segment
        Canvas {
            id: progressRing
            anchors.centerIn: parent
            
            property real lineWidth:  40  // just outside the center circle
            property real innerRadius: timer_area.width / 2    // just outside the center circle
            readonly property real outerRadius: innerRadius + lineWidth           // thickness of the ring
            property real progress: 0.75                           // 0.0 → 1.0 progress

            width: outerRadius * 2
            height: outerRadius * 2

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
            property int count: 5
            property real size: 150 // just outside the center circle
            property real innerRadius: progressRing.width/2
            readonly property real outerRadius: innerRadius + size

            width: outerRadius * 2
            height: outerRadius * 2

            Repeater {
                model: sectorRing.count
                delegate: Canvas {
                    width: sectorRing.width
                    height: sectorRing.height
                    property real startAngle: (index / sectorRing.count) * 2 * Math.PI
                    property real endAngle: ((index + 1) / sectorRing.count) * 2 * Math.PI

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

                    MouseArea {
                        anchors.fill: parent
                        onClicked: console.log("Sector", index, "clicked")
                    }
                }
            }
        }
    }
}



