import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root

    property int lazer: 0
    property int stable: 0

    Layout.minimumWidth: row.implicitWidth
    Layout.preferredWidth: row.implicitWidth

    function updateData() {
        var xhr = new XMLHttpRequest();

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        var data = JSON.parse(xhr.responseText);

                        stable = data.stable
                        lazer = data.lazer
                    } catch (e) {
                        console.log("JSON parse error:", e);
                    }
                }
            }
        }

        xhr.open("GET", "https://arewelazeryet.chiffa.lol/api/bars/current");
        xhr.send();
    }

    Timer {
        interval: 30000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: updateData()
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 12

        Text {
            text: lazer
            color: "#f6a"
            font.pixelSize: 12
        }

        Text {
            text: (lazer / (stable + lazer) * 100).toFixed(2) + "%"
            color: "#f6a"
            font.bold: true
            font.pixelSize: 16
        }

        Text {
            text: stable - lazer
            color: "#fff"
            font.bold: true
            font.pixelSize: 16
        }

        Text {
            text: (stable / (stable + lazer) * 100).toFixed(2) + "%"
            color: "#6cf"
            font.bold: true
            font.pixelSize: 16
        }

        Text {
            text: stable
            color: "#6cf"
            font.pixelSize: 12
        }
    }
}
