import QtQuick 2.15
import QtQuick.Controls 2.15

Window {
    width: 1200
    height: 800
    visible: true
    title: "Vehicle"

    property bool engineOn: false
    property int currentSpeed: 0
    property int maxSpeed: 100
    property int minSpeed: 0
    property int accelerationRate: 1
    property int brakingRate: -1
    property bool accelerating: false
    property bool braking: false
    property bool engineTurningLeft: false
    property bool engineTurningRight: false
    property int volume: 50
    property var currentDate: new Date()
    property int fuelLevel: 100

    //Gear functionality
    function updateGear(speed) {
            if (speed === 0) {
                gearText.text = "N"; // Park when speed is zero
            } else if (speed < 20) {
                gearText.text = "1"; //Gear 1
            } else if (speed < 40) {
                gearText.text = "2"; //Gear 2
            }else if (speed < 60) {
                gearText.text = "3"; //Gear 3
            }else if (speed < 80) {
                gearText.text = "4"; //Gear 4
            }else if (speed < 260) {
                gearText.text = "5"; //Gear 5
            } else {
                gearText.text = "R"; // Reverse for high speeds
            }
        }


    Timer {
        id: fuelConsumptionTimer
        interval: 1000
        repeat: true
        running: engineOn // Only consume fuel when the engine is on
        onTriggered: {
            fuelLevel -= 1; // Simulate fuel consumption
            if (fuelLevel <= 0) {
                    fuelLevel = 0;
                    currentSpeed = 0; // Set speed to 0 when fuel level reaches 0
                    gearText.text = "N"; // Set gear to "N" when fuel level reaches 0
                    }
        }
    }

    Timer {
        id: accelerateTimer
        interval: 100
        repeat: true
        running: accelerating
        onTriggered: {
        if (fuelLevel > 0) {
            var previousSpeed = currentSpeed;
            currentSpeed = Math.min(currentSpeed + accelerationRate, maxSpeed);
            updateGear(currentSpeed, previousSpeed);
         }

        }
    }

    Timer {
        id: brakeTimer
        interval: 100
        repeat: true
        running: braking
        onTriggered: {
            currentSpeed = Math.max(currentSpeed + brakingRate, minSpeed);
            gearText.text = "N";
        }

    }
    Rectangle {
       anchors.fill: parent
        color: "#2a2b26"

        Rectangle {
            id: dashboard
            color: "#ffffff"
            anchors.fill: parent
            radius: width / 2

            property real initialAlpha: 0

            SequentialAnimation {
                    id: gradientAnimation
                    running: engineOn // Start animation when engine is turned on
                    loops: 1
                    PropertyAction { target: gradientAnimation; property: "running" } // Start/stop animation based on engine state
                    PropertyAction { target: dashboard; property: "initialAlpha"; value: 0 } // Reset initialAlpha property
                    NumberAnimation { target: dashboard; property: "initialAlpha"; to: 1; duration: 1000 } // Adjust duration as needed
                }
            // Bind the color of each gradient stop to the initial alpha value and engine state
            gradient: Gradient {
                GradientStop { position: 0.00; color: engineOn ? Qt.rgba(1, 1, 0, dashboard.initialAlpha) : "#008000" }
                GradientStop { position: 0.40; color: engineOn ? Qt.rgba(0.466, 0.694, 0.137, dashboard.initialAlpha) : "#23b278" }
                GradientStop { position: 0.60; color: engineOn ? Qt.rgba(0.569, 0.961, 0.012, dashboard.initialAlpha) : "#2f795b" }
                GradientStop { position: 0.80; color: engineOn ? Qt.rgba(0.278, 0.478, 0.192, dashboard.initialAlpha) : "#2a2727" }
                GradientStop { position: 0.90; color: engineOn ? Qt.rgba(0.192, 0.729, 0.392, dashboard.initialAlpha) : "#2a2727" }
            }



            Item {
                    id: mainScreen
                    anchors.fill: parent

                    // Title
                    Text {
                        text: "Car Dashboard"
                        font.pixelSize: 24
                        color: "black"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                    }
            }

        // Gare part
        Rectangle {
            width: 350
            height: 350
            radius: width / 2 // Make it a circle by setting the radius to half of the width
            color: "black"
            anchors {
                    top: parent.top
                    topMargin: 203
                    left: parent.left
                    leftMargin: 90
                }

            Text {
                    id: gearText
                    text: "N" // Default to Neutral gear
                    font.pixelSize: 24
                    font.family: "Impact"
                    color: engineOn ? "yellow" : "lightgreen"
                    anchors {
                                bottom: parent.bottom
                                bottomMargin: 60
                                horizontalCenter: parent.horizontalCenter
                            }
                }
            Image {
                source: "images/Gear.png"
                fillMode: Image.PreserveAspectFit // Preserve the aspect ratio of the image
                width: 150
                height: 150
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                        }
             }

            }


        // Fuel part

        function consumeFuel(amount) {
                if (engineOn) {
                    fuelLevel -= amount;
                    if (fuelLevel < 0){

                        fuelLevel = 0; // Ensure fuel level doesn't go below 0

                    }
                }
            }

        function refillFuel() {
            fuelLevel = 100; // Refill tank to full

        }

        Rectangle {
            width: 350
            height: 350
            radius: width / 2 // Make it a circle by setting the radius to half of the width
            color: "black"
            Image {
                source: "images/Fuel.png"
                fillMode: Image.PreserveAspectFit // Preserve the aspect ratio of the image
                width: 270
                height: 270
                anchors.centerIn: parent

                Rectangle {
                    width: 40
                    height: 20
                    color: "green"
                    anchors.centerIn: parent

                        }

                Text {
                    text: fuelLevel + "%"
                    color: "white"
                    font.pixelSize: 14
                    anchors.centerIn: parent
                }

                Text {
                    id: id_date
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin: 50
                    }
                    color: engineOn ? "yellow" : "lightgreen"
                    font.pixelSize: 24
                    font.family: "Impact"
                    text: currentDate.getDate() + "/" + (currentDate.getMonth() + 1) + "/" + currentDate.getFullYear()
                }

                Text {
                    id: id_clock
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin: 10
                    }
                    color: engineOn ? "yellow" : "lightgreen"
                    font.pixelSize: 24
                    font.family: "Impact"
                    text: currentDate.getHours() + ":" + currentDate.getMinutes() + ":" + currentDate.getSeconds()
                }

            }

            anchors {
                top: parent.top
                right: parent.right
                topMargin: 200
                rightMargin: 90
            }
        }

        Button {
                text: "Refill Fuel"
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    bottomMargin: 140
                    rightMargin: 20
                }
                onClicked: {
                    fuelLevel = 100; // Call the function to refill fuel
                }
                enabled: engineOn
            }

        // Speedometter

        Image {
            id: speedometer
            source: "images/speedo.png"
            width: 400
            height: 400
            anchors.centerIn: parent

            Image {
                id: needle
                source: "images/needlered.png"
                anchors.centerIn: parent
                height: 140
                anchors.verticalCenterOffset: -height / 2
                transformOrigin: Item.Bottom
                Behavior on rotation {
                    NumberAnimation {
                        duration: 4000 // Duration of rotation animation in milliseconds
                    }
                }
                rotation: -136 + currentSpeed * 2.72 // Adjust rotation based on speed
            }
        }


        // Turn Indicator
        Image {
            id: turnIndicator
            source: engineTurningLeft ? "images/Leftturn.png" : (engineTurningRight ? "images/Rightturn.png" : "")
            width: 50
            height: 50
            anchors.horizontalCenter: speedometer.horizontalCenter
            anchors.top: speedometer.bottom
            anchors.topMargin: 10
            visible: engineTurningLeft || engineTurningRight // Show only when turning
        }

        // Left turn button
        Button {
            id: leftTurnButton
            text: "Toggle Left Turn"
            anchors {
                left: parent.left
                bottom: parent.bottom
                bottomMargin: 80
                leftMargin: 20
            }
            onClicked: {
                if (engineOn) {
                        engineTurningLeft = !engineTurningLeft; // Toggle left turn indicator
                        engineTurningRight = false; // Ensure right turn indicator is off
                    }
                }
                enabled: engineOn // Only enabled when engine is on
        }

        // Right turn button
        Button {
            id: rightTurnButton
            text: "Toggle Right Turn"
            anchors {
                right: parent.right
                bottom: parent.bottom
                bottomMargin: 80
                rightMargin: 20
            }
            onClicked: {
                if (engineOn) {
                    engineTurningRight = !engineTurningRight; // Toggle right turn indicator
                    engineTurningLeft = false; // Ensure left turn indicator is off
                }
            }
            enabled: engineOn // Only enabled when engine is on
        }


        Button {
            id: engineButton
            text: engineOn ? "Turn Engine Off" : "Turn Engine On"
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 40
            }
            onClicked: {
                engineOn = !engineOn;
                if (!engineOn) {
                    currentSpeed = 0;
                    gearText.text = "N";
                }
            }
        }

        Button {
            id: accelerateButton
            text: "Accelerate"
            anchors {
                left: parent.left
                bottom: parent.bottom
                bottomMargin: 20
                leftMargin: 20
            }
            onPressedChanged: {
                accelerating = pressed;
                if (pressed) accelerateTimer.start();
                else accelerateTimer.stop();
            }
            enabled: engineOn
        }

        Button {
            id: brakeButton
            text: "Brake"
            anchors {
                right: parent.right
                bottom: parent.bottom
                bottomMargin: 20
                rightMargin: 20
            }
            onPressedChanged: {
                braking = pressed;
                if (pressed) brakeTimer.start();
                else brakeTimer.stop();
            }
            enabled: engineOn
        }

        states: [
            State {
                name: "EngineOff"
                PropertyChanges {
                    target: needle
                    rotation: -136 // Rotate needle to minimum speed when engine is off
                }
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "EngineOff"
                NumberAnimation {
                    target: needle
                    property: "rotation"
                    duration: 1000 // Duration of needle rotation animation
                    easing.type: Easing.InOutQuad // Optional easing function
                }
            }
        ]

    }
}
    Button {
        text: " Volume Controls"
        onClicked: {
            dashboard.visible = false;
            controlsScreen.visible = engineOn;
        }
        enabled: engineOn // Enable the button only when the engine is on
        anchors {
                horizontalCenter: parent.horizontalCenter // Center the button horizontally
                top: parent.top // Align the top of the button with the top of its parent
                topMargin: 60 // Add a margin of 20 pixels from the top
            }
    }

    // Controls screen
    Rectangle {
        id: controlsScreen
        visible: false
        width: parent.width
        height: parent.height
        radius: width / 2
        color: "#99b739"

        // Title
        Text {
            id:cartext
            text: "Volume Controls"
            font.pixelSize: 24
            color: "black"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20
        }

        // Volume slider
        Slider {
            width: 200
            height: 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            orientation: Qt.Horizontal
            from: 0
            to: 100
            value: volume
            onValueChanged: volume = value; // Update volume value
        }

        // Back button
        Button {
            text: "Back"
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 20
            }
            onClicked: {
                dashboard.visible = true;
                controlsScreen.visible = false;
            }
        }
    }
 }
