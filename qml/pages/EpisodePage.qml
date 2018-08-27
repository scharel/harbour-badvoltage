import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: episodePage
    property int index
    property var episode

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Visit the show's website")
                onClicked: Qt.openUrlExternally(episode.guid)
            }
            MenuItem {
                text: qsTr("Discuss in the community")
                onClicked: Qt.openUrlExternally("http://community.badvoltage.org")
            }
        }

        Column {
            anchors.fill: parent

            PageHeader {
                id: header
                title: episode.title.split(": ", 1)[0].trim()
                description: episode.title.split(": ", 2)[1].trim()
            }

            SilicaFlickable {
                id: contentFlickable
                width: parent.width
                height: Screen.height - header.height - separator.height - controlColumn.height
                contentHeight: contentText.height
                clip: true

                Text {
                    id: contentText
                    width: parent.width - 2*Theme.horizontalPageMargin
                    x: Theme.horizontalPageMargin
                    color: Theme.primaryColor
                    linkColor: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                    onLinkActivated: Qt.openUrlExternally(link)
                    text: episode.content_encoded
                }

                VerticalScrollDecorator { flickable: contentFlickable }
            }

            Separator {
                id: separator
                width: parent.width
                color: Theme.primaryColor
            }

            Column {
                id: controlColumn
                width: parent.width

                Item {
                    height: Theme.paddingLarge
                    width: parent.width
                }

                Row {
                    id: controlRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 2 * Theme.paddingLarge
                    IconButton {
                        icon.source: "image://theme/icon-m-left"
                        enabled: audioPlayer.seekable && audioPlaylist.currentIndex === index
                        Timer {
                            interval: 500; running: parent.down; repeat: true; triggeredOnStart: true
                            onTriggered: audioPlayer.seek(audioPlayer.position - 10000)
                        }
                    }
                    IconButton {
                        icon.source: audioPlayer.isPlaying && audioPlaylist.currentIndex === index ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
                        enabled: !audioPlayer.isLoading
                        onClicked: {
                            if (audioPlaylist.currentIndex !== index) {
                                audioPlayer.stop()
                                audioPlaylist.currentIndex = index
                            }
                            if (audioPlayer.isPlaying)
                                audioPlayer.pause()
                            else {
                                audioPlayer.play()
                            }
                        }
                        onPressAndHold: {
                            audioPlayer.stop()
                            audioPlaylist.currentIndex = -1
                        }
                    }
                    IconButton {
                        icon.source: "image://theme/icon-m-right"
                        enabled: audioPlayer.seekable && audioPlaylist.currentIndex === index
                        Timer {
                            interval: 500; running: parent.down; repeat: true; triggeredOnStart: true
                            onTriggered: audioPlayer.seek(audioPlayer.position + 10000)
                        }
                    }
                }

                Slider {
                    id: controlSlider
                    width: parent.width
                    label: audioPlaylist.currentIndex === index && audioPlayer.duration > 0 ? msec2timeString(audioPlayer.duration) : episode.duration
                    minimumValue: 0
                    maximumValue: audioPlaylist.currentIndex === index && audioPlayer.duration > 0 ? audioPlayer.duration : timeString2msec(episode.duration)
                    stepSize: 1000
                    value: audioPlaylist.currentIndex === index && audioPlayer.isPlaying ? audioPlayer.position : episodeAudioPositions.value(episode.title, 0)
                    valueText: msec2timeString(value)
                    enabled: audioPlayer.seekable && audioPlaylist.currentIndex === index && maximumValue > minimumValue
                    handleVisible: enabled
                    onReleased:
                        audioPlayer.seek(sliderValue)
                    Connections {
                        target: audioPlayer
                        onPositionChanged: {
                            if (audioPlaylist.currentIndex === index && !controlSlider.down)
                                controlSlider.value = audioPlayer.position
                        }
                    }
                }
            }
        }
    }
}
