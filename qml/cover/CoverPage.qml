import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Image {
        source: "BadVoltage.png"
        fillMode: Image.PreserveAspectFit
        x: Theme.paddingLarge; y: x
        width: parent.width - 2 * Theme.horizontalPageMargin
        opacity: 0.5
    }
    Label {
        id: playingEpisodeLabel
        anchors.centerIn: parent
        text: audioPlayer.playlist.currentIndex
        x: Theme.paddingLarge
        width: parent.width - 2*x
        truncationMode: TruncationMode.Elide
        visible: audioPlayer.playlist.currentIndex >= 0 ? (feedModel.get(audioPlayer.playlist.currentIndex).title !== "" ? true : false) : false
    }
    Label {
        id: playingEpisodeProgress
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: playingEpisodeLabel.bottom
        color: Theme.highlightColor
        visible: playingEpisodeLabel.visible
        text: msec2timeString(audioPlayer.position) + " / " + msec2timeString(audioPlayer.duration)
    }
    CoverActionList {
        id: playingEpisodeActions
        enabled: playingEpisodeLabel.visible
        CoverAction {
            iconSource: audioPlayer.isPlaying ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: audioPlayer.isPlaying ? audioPlayer.pause() : audioPlayer.play()
        }
        /*CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: audioPlayer.seek(audioPlayer.position + 10000)
        }*/
    }

    Label {
        id: newEpisodesLabel
        anchors.verticalCenter: parent.verticalCenter
        x: Theme.paddingMedium
        width: parent.width - 2*x
        horizontalAlignment: contentWidth > width ? Text.AlignLeft : Text.AlignHCenter
        truncationMode: TruncationMode.Fade
        text: (numNewEpisodes === 0 ? qsTr("No") : numNewEpisodes) + " " + (numNewEpisodes !== 1 ? qsTr("new episodes") : qsTr("new episode"))
        visible: !playingEpisodeLabel.visible
    }
    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: newEpisodesLabel.bottom
        color: Theme.highlightColor
        visible: !playingEpisodeProgress.visible && feedModel.busy
        text: qsTr("Udating...")
    }
    CoverActionList {
        enabled: !playingEpisodeActions.enabled
        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: feedModel.update()
        }
    }
}


