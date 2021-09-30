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
        Layout.leftMargin: 24
        Layout.topMargin: 10
        Layout.rightMargin: 24
        Layout.bottomMargin: 0

         TextField {
            implicitWidth: 300
            implicitHeight: 40
            placeholderText: qsTr("enter a search term here")
            Layout.leftMargin: 24
        Layout.topMargin: 10
        Layout.rightMargin: 24
        Layout.bottomMargin: 0

         }
         Button {
            implicitWidth: 90
            implicitHeight: 40
            Layout.leftMargin: 24
         }
    }

}
