import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: episodePage
    property var episode
    property var source
    property bool audioHasSameSource: audioPlayer.isSameSource(source)
    Connections {
        target: audioPlayer
        onSourceChanged: audioHasSameSource = audioPlayer.isSameSource(source)
    }

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
                        enabled: audioPlayer.seekable && audioHasSameSource
                        Timer {
                            interval: 500; running: parent.down; repeat: true; triggeredOnStart: true
                            onTriggered: audioPlayer.seek(audioPlayer.position - 10000)
                        }
                    }
                    IconButton {
                        icon.source: audioPlayer.isPlaying && audioHasSameSource ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
                        enabled: !audioPlayer.isLoading
                        onClicked: {
                            if (!audioHasSameSource) {
                                audioPlayer.stop()
                                audioPlayer.source = source
                                audioHasSameSource = true
                            }
                            audioPlayer.isPlaying ? audioPlayer.pause() : audioPlayer.play()
                        }
                        onPressAndHold: {
                            audioPlayer.stop()
                            audioPlayer.source = ""
                            audioHasSameSource = false
                            controlSlider.value = 0
                        }
                    }
                    IconButton {
                        icon.source: "image://theme/icon-m-right"
                        enabled: audioPlayer.seekable && audioHasSameSource
                        Timer {
                            interval: 500; running: parent.down; repeat: true; triggeredOnStart: true
                            onTriggered: audioPlayer.seek(audioPlayer.position + 10000)
                        }
                    }
                }

                Slider {
                    id: controlSlider
                    width: parent.width
                    label: audioHasSameSource ? msec2timeString(audioPlayer.duration) : episode.duration
                    minimumValue: 0
                    maximumValue: audioHasSameSource ? (audioPlayer.duration > 0 ? audioPlayer.duration : 1) : 1
                    stepSize: 1000
                    value: audioHasSameSource ? audioPlayer.position : 0
                    valueText: msec2timeString(value) //audioHasSameSource ? msec2timeString(value) : " "
                    enabled: audioPlayer.seekable && audioHasSameSource && maximumValue > minimumValue
                    handleVisible: enabled
                    onReleased:
                        audioPlayer.seek(sliderValue)
                    Connections {
                        target: audioPlayer
                        onPositionChanged: {
                            if (audioHasSameSource)
                                controlSlider.value = audioPlayer.position
                        }
                    }
                }
            }
        }
    }
}
