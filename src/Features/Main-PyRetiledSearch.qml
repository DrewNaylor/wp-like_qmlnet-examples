import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Universal 2.12

ApplicationWindow {
    id: window
    width: 360
    height: 720
    visible: true
    title: qsTr("RetiledSearch")

    Universal.theme: Universal.Dark
    Universal.accent: '#0050ef'
	Universal.foreground: 'white'
	Universal.background: 'black'

    // I'm basically just using this project to
    // figure out how to port Retiled to QML, then I'll bring in Python
    // so it doesn't need QML.NET, which doesn't have ARM builds for
    // the unmanaged library.
    ColumnLayout {
        spacing: 4
        Layout.fillWidth: true

         TextField {
            Layout.fillWidth: true
            // I don't know how to get the width to change when the window
            // is resized, so it's hardcoded at 312 for now.
            implicitWidth: 312
            implicitHeight: 40
            placeholderText: qsTr("enter a search term here")
            Layout.leftMargin: 24
            Layout.topMargin: 10
            Layout.rightMargin: 24
            Layout.bottomMargin: 0
            // I don't know if pixelSize is the right property
            // to change for DPI scaling.
            font.pixelSize: 18

         }
         Button {
            id: searchButton
            
            Layout.leftMargin: 24
            font.pixelSize: 18
            text: qsTr("search")
            // Had to use the contentItem Text thing to change stuff from the "customizing button"
            // page in the QML docs here:
            // https://doc.qt.io/qt-5/qtquickcontrols2-customize.html#customizing-button
            contentItem: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 18
                text: qsTr("search")
                color: "white"
            }
           // Also need to change the background and border.
           background: Rectangle {
                id: searchButtonBackgroundArea
                implicitWidth: 90
                implicitHeight: 40
                // Set the default state.
                state: "RELEASED"
                border.color: "white"
                border.width: 2
                radius: 0
                // Change the button background to Cobalt when pressed.
                color: searchButton.down ? "#0050ef" : "black"

                // I think this is the way I'll rotate and shrink the button
                // when it's held down:
                // https://doc.qt.io/qt-5/qml-qtquick-animation.html#running-prop
                // Better stuff on animations:
                // https://doc.qt.io/qt-5/qtquick-statesanimations-animations.html

                ButtonPressAnimation on x {
                    running: searchButton.down
                    from: 0; to 60
                }

                // We're using MultiPointTouchArea to ensure this'll work with touch.
                MultiPointTouchArea {
                    anchors.fill: parent
                    onPressed: searchButtonBackgroundArea.state = "PRESSED"
                    onReleased: searchButtonBackgroundArea.state = "RELEASED"
                }

                // Set up the states.
                states: [
                    State {
                        name: "PRESSED"
                        PropertyChanges {target: searchButtonBackgroundArea; width: 85}
                        PropertyChanges {target: searchButtonBackgroundArea; height: 35}
                    }
                    State {
                        name: "RELEASED"
                        PropertyChanges {target: searchButtonBackgroundArea; width: 90}
                        PropertyChanges {target: searchButtonBackgroundArea; height: 40}
                    }
                ]
           }

         }
    }

}
