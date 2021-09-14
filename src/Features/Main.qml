// Modifications to this file are Copyright (c) 2021 Drew Naylor and
// are available under the MIT License, just like the original code.
// See the LICENSE file for more details.




import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Universal 2.12

ApplicationWindow {
    id: window
    width: 360
    height: 720
    visible: true
    title: "Qml.Net - WP-like Modified Example App"

    Universal.theme: Universal.Dark
    Universal.accent: '#0050ef'
	Universal.foreground: 'white'
	Universal.background: 'black'

    Shortcut {
        sequences: ["Esc", "Back"]
        enabled: stackView.depth > 1
        onActivated: {
            stackView.pop()
            listView.currentIndex = -1
        }
    }

    Shortcut {
    // The Menu key is the context menu key on the keyboard.
    // I've hooked it up to the app bar drawer so that it's
    // easier to open with the keyboard.
        sequence: "Menu"
        // TODO: It would be useful to have a way to open
        // and close the app bar drawer using the same
        // key. However, this would require a boolean
        // to be set when the drawer is opened and closed,
        // and I don't know enough about QML booleans right
        // now and I need to go to bed.
        onActivated: drawer.open()
    }

    header: ToolBar {
    
    // Didn't know this is how you set background colors for
    // controls in QML.
    // Based on this info here:
    // https://stackoverflow.com/a/27619649
    background: Rectangle {
        color: 'black'
    }

    RowLayout{
    anchors.left: parent.left

                Item {
                // Adding an empty Item to space the header from the left.
                // TODO: Get this empty item's spacing to be closer to WP's
                // spacing for a given app that uses large headers, like
                // pages in the Settings app.
                height: 50
                width: 30
                }

                Label {
                id: titleLabel
                // TODO: Figure out a way to keep the current page's
                // title so that previous pages are shown again when pressing the Back button.
                text: listView.currentItem ? listView.currentItem.text : "Gallery"
                // Not sure if this is the right font size, but it's closer.
                font.pixelSize: 50
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            }

    }

    footer: ToolBar {

                id: appBar

        transform: Translate {
        // Move the menu to make it look like WP's ellipsis menu opening.
        y: drawer.position * appBar.height * -5
         }

        RowLayout {
            spacing: 20
            anchors.fill: parent


            ToolButton {
            // TODO: Hide the back button until it's needed.
                icon.source: "images/back.png"
                onClicked: {
                    if (stackView.depth > 1) {
                        stackView.pop()
                        listView.currentIndex = -1
                        }
                }
            }

            Item {
            // This empty label is necessary to take up space
            // and push the back button and ellipsis button to both edges.
            // I guess I could've just tweaked things a bit.
                Layout.fillWidth: true
            }

            ToolButton {
            
                icon.source: "images/menu.png"
                onClicked: {
                        drawer.open()
                }
            }


        }
    }

    Drawer {
    // TODO: Figure out a way to allow the drawer to be closed from any
    // page and not just from clicking inside the main page or clicking
    // on any of the items in the drawer.
    // TODO 2: Figure out how to let the user drag the app bar back down
    // on both the right and the left side to close the
    // drawer, like on Windows Phone.
    // TODO 3: Change the app bar icons so they're closer to WP, especially
    // the app bar drawer opening button, as that's more like Windows 10
    // Mobile.
        id: drawer
        width: window.width
        // Set height to 240 so that the app bar always moves out of the way,
        // even when the window is taller or shorter.
        height: 240
        interactive: stackView.depth === 1
        // Setting edge to Qt.BottomEdge makes the menu
        // kinda look like WP's ellipsis menu, except it
        // doesn't yet move the bar up. Maybe a translation
        // thing will help with that.
        // Edge documentation:
        // https://doc.qt.io/qt-5/qml-qtquick-controls2-drawer.html#edge-prop
        edge: Qt.BottomEdge


        // Removing the shadow from the drawer:
        // https://stackoverflow.com/a/63411102
        Overlay.modal: Rectangle {
                  color: "transparent"
              }

       Rectangle {
       // You have to set this rectangle's color
       // or else it'll be white.
            anchors.fill: parent
            color: "transparent"
        

        ListView {
            id: listView
            anchors.fill: parent
            clip: true
            focus: true
            currentIndex: -1

            delegate: ItemDelegate {
                width: parent.width
                text: model.title
                highlighted: ListView.isCurrentItem
                onClicked: {
                    listView.currentIndex = index
                    stackView.push(model.source)
                    drawer.close()
                }
            }

            model: ListModel {
                ListElement { title: "Signals"; source: "pages/Signals.qml" }
                ListElement { title: "Notify signals"; source: "pages/NotifySignals.qml" }
                ListElement { title: "Async/await"; source: "pages/AsyncAwait.qml" }
                ListElement { title: ".NET objects"; source: "pages/NetObjects.qml" }
                ListElement { title: "Dynamics"; source: "pages/Dynamics.qml" }
                ListElement { title: "Simple calculator"; source: "pages/Calculator.qml" }
                ListElement { title: "Collections"; source: "pages/Collections.qml" }
				ListElement { title: "About"; source: "pages/About.qml" }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: Pane {
            id: pane

            Image {
                id: logo
                width: pane.availableWidth / 2
                height: pane.availableHeight / 2
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -50
                fillMode: Image.PreserveAspectFit
                source: "images/qt-logo.png"
            }

            Label {
                text: "Qml.Net is a bridge between .NET and Qml, allowing you to build powerful user-interfaces driven by the .NET Framework."
                anchors.margins: 20
                anchors.top: logo.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: arrow.top
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                wrapMode: Label.Wrap
            }

            Image {
                id: arrow
                source: "images/arrow.png"
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }
        }
    }
    
    // I'm keeping the original dialog here but commented-out
    // because it may be useful eventually and I'd like
    // to figure out how a dialog that looks like Windows
    // Phone's pop-ups would look like in QML.
  //  Dialog {
    //    id: aboutDialog
    //    modal: true
    //    focus: true
    //    title: "About"
    //    x: (window.width - width) / 2
    //    y: window.height / 6
    //    width: Math.min(window.width, window.height) / 3 * 2

    //    Label {
    //        width: aboutDialog.availableWidth
    //        text: "Qml.Net is a bridge between .NET and Qml, allowing you to build powerfull user-interfaces driven by the .NET Framework."
    //        wrapMode: Label.Wrap
    //        font.pixelSize: 12
    //    }
    //}
}
