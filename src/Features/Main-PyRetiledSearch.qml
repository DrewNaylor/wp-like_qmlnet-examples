import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4

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
            id: searchBox
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
            color: "black"

            // Changing the style for the textbox. Documentation:
            // https://doc.qt.io/qt-5/qml-qtquick-controls-styles-textfieldstyle.html
            // Apparently that doesn't work. See here:
            // https://stackoverflow.com/a/39052406
                background: Rectangle {
                    radius: 0
                    // Setting the background seems to work well enough,
                    // but I need to change the placeholder text here so
                    // it disappears when focused.
                    border.color: searchBox.focus ? "#0050ef" : "#CCCCCC"
                }

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

                // I think this is the way I'll rotate and shrink the button
                // when it's held down:
                // https://doc.qt.io/qt-5/qml-qtquick-animation.html#running-prop
                // Better stuff on animations:
                // https://doc.qt.io/qt-5/qtquick-statesanimations-animations.html
                // Actually, this is what I needed:
                // https://doc.qt.io/qt-5/qml-qtquick-scaleanimator.html
                // Wait, this looks better, but is older so I hope it works:
                // https://forum.qt.io/topic/2712/animating-button-press


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
                        // Avalonia used 0.98, and I thought it looked bad in QML,
                        // but I think it's fine.
                        // We can actually just scale the whole button down rather than
                        // the rectangle we're in. Didn't know that, so I decided to see if
                        // QML allows that because that seems to be what Avalonia does,
                        // and it works.
                        PropertyChanges {target: searchButton; scale: 0.98}
                        // Change the button background to Cobalt when pressed.
                        PropertyChanges {target: searchButtonBackgroundArea; color: "#0050ef"}
                    },
                    // There's supposed to be a comma there.
                    State {
                        name: "RELEASED"
                        PropertyChanges {target: searchButton; scale: 1.0}
                        PropertyChanges {target: searchButtonBackgroundArea; color: "black"}
                    }
                ]

                // Set up the transitions.
                transitions: [
                    Transition {
                        from: "PRESSED"
                        to: "RELEASED"
                        NumberAnimation { target: searchButton; duration: 60}
                        ColorAnimation { target: searchButtonBackgroundArea; duration: 60}
                    },

                    Transition {
                        from: "RELEASED"
                        to: "PRESSED"
                        NumberAnimation { target: searchButton; duration: 60}
                        ColorAnimation { target: searchButtonBackgroundArea; duration: 60}
                    }
                
                ]
           }

         }
    }

}
