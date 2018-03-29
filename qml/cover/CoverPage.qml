import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    CoverPlaceholder {
        id: placeHolder
        icon.source: "BV.png"
        //text: qsTr("Bad Voltage")
    }

    Label {
        id: newEpisodesLabel
        anchors.centerIn: parent
        text: (numNewEpisodes === 0 ? qsTr("No") : numNewEpisodes) + " " + (numNewEpisodes !== 1 ? qsTr("new episodes") : qsTr("new episode"))
    }
    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: newEpisodesLabel.bottom
        color: Theme.highlightColor
        visible: feedModel.busy
        text: qsTr("Udating...")
    }

    CoverActionList {
        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: feedModel.update()
        }
    }

    /*
    Timer {
        id: updatingTimer
        interval: 1500
    }

    Connections {
        target: updatingLabel
        onVisibleChanged: if (updatingLabel.visible === false) updatingTimer.restart()
    }

    Column {
        y: 175
        x: Theme.paddingSmall
        width: parent.width - 2 * Theme.paddingSmall
        spacing: Theme.paddingSmall

        Label {
            id: updatingLabel
            visible: feedModel.progress !== 1
            width: parent.width
            truncationMode: TruncationMode.Fade
            horizontalAlignment: contentWidth < width ? Text.AlignHCenter : Text.AlignLeft
            //: While updating feed
            text: qsTr("Updating...")
        }

        Label {
            id: playingLabel
            visible: !updatingLabel.visible && !player.stopped && !updatingTimer.running
            width: parent.width
            truncationMode: TruncationMode.Fade
            horizontalAlignment: contentWidth < width ? Text.AlignHCenter : Text.AlignLeft
            text: getPrettyNumber(player.season, player.episode) + ": " + settings.value("content/" + player.season + "/" + player.episode + "/title")
        }

        Label {
            id: newEpisodesLabel
            visible: !updatingLabel.visible && !playingLabel.visible
            width: parent.width
            truncationMode: TruncationMode.Fade
            horizontalAlignment: wrapMode === Text.Wrap ? Text.AlignHCenter : Text.AlignLeft
            maximumLineCount: 2
            wrapMode: player.stopped ? Text.Wrap : Text.NoWrap
            //: Number of unseen episodes
            text: (nUnSeen === 0 ? qsTr("No") : nUnSeen) + " " + qsTr("Unseen Episode") + (nUnSeen > 1 ? qsTr("s") : qsTr(""))
        }

        Label {
            id: audioPositionLabel
            visible: !player.stopped
            width: parent.width
            truncationMode: TruncationMode.Fade
            horizontalAlignment: contentWidth < width ? Text.AlignHCenter : Text.AlignLeft
            text: getTimeFromMs(player.position) + "/" + getTimeFromMs(player.duration)
        }
    }

    CoverActionList {
        enabled: player.stopped
        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: {
                //console.log("Cover Refresh")
                feedModel.reloadData()
            }
        }
    }

    CoverActionList {
        enabled: player.paused && !player.stopped
        CoverAction {
            iconSource: "image://theme/icon-cover-play"
            onTriggered: {
                //console.log("Cover Play")
                player.play()
            }
        }
        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: {
                //console.log("Cover Refresh")
                feedModel.reloadData()
            }
        }
    }

    CoverActionList {
        enabled: !player.paused && !player.stopped
        CoverAction {
            iconSource: "image://theme/icon-cover-pause"
            onTriggered: {
                //console.log("Cover Pause")
                player.pause()
            }
        }
        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: {
                //console.log("Cover Refresh")
                feedModel.reloadData()
            }
        }
    }
    */
}


