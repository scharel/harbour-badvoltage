import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQml.Models 2.2
import FileDownloader 1.0

Page {
    id: feedPage

    SilicaListView {
        id: listView
        anchors.fill: parent

        PullDownMenu {
            busy: feedModel.busy
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Community")
                //onClicked: pageStack.push(Qt.resolvedUrl("CommunityPage.qml"))
                onClicked: Qt.openUrlExternally("http://community.badvoltage.org?mobile_view=1")
            }
            MenuItem {
                text: qsTr("Update")
                enabled: !feedModel.busy
                onClicked: feedModel.update()
            }
            MenuLabel {
                id: updateMenuLabel
                text: qsTr("Updated") + ": " + settings.updateTime
            }
        }

        header: PageHeader {
            //: Header of the feed page
            title: qsTr("Bad Voltage")
        }

        model: DelegateModel {
            model: feedModel

            delegate: ListItem {
                id: episode
                width: parent.width
                contentHeight: Theme.itemSizeMedium
                property bool isListened: listenedEpisodes.value(title, false, Boolean)
                Connections {
                    target: listenedEpisodes
                    onValueChanged: if (key === title) isListened = listenedEpisodes.value(title, false, Boolean)
                }
                onClicked: pageStack.push(Qt.resolvedUrl("EpisodePage.qml"), {episode: model, source: downloader.isDownloaded ? downloader.filePath + "/" + downloader.fileName : enclosure_url})

                FileDownloader {
                    id: downloader
                    url: enclosure_url
                    onIsDownloadingChanged: {
                        if (isDownloading)
                            episode.DelegateModel.inPersistedItems = 1
                        else
                            episode.DelegateModel.inPersistedItems = false
                    }
                }

                Rectangle {
                    id: progressRectangle
                    visible: downloader.isDownloading
                    height: parent.height
                    width: downloader.progress * parent.width
                    color: Theme.highlightColor
                    opacity: 0.2
                }

                Label {
                    id: numberLabel
                    x: Theme.horizontalPageMargin
                    anchors.bottom: parent.verticalCenter
                    text: title.split(": ", 1)[0].trim()
                    color: Theme.highlightColor
                }

                Label {
                    id: titleLabel
                    anchors.bottom: parent.verticalCenter
                    anchors.left: numberLabel.right
                    anchors.leftMargin: Theme.paddingSmall
                    width: parent.width - x
                    text: title.split(": ", 2)[1].trim()
                    truncationMode: TruncationMode.Fade
                    color: episode.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                Image {
                    id: isNewIcon
                    //opacity: isListened.value ? 0.2 : 1.0
                    visible: !isListened
                    anchors.top: parent.verticalCenter
                    x: Theme.horizontalPageMargin
                    width: Theme.iconSizeSmall
                    source: "image://theme/icon-s-new?"
                            + (episode.highlighted ? Theme.highlightColor : Theme.primaryColor)
                }

                Image {
                    id: downloadedIcon
                    //opacity: downloader.isDownloaded ? 1.0 : 0.2
                    visible: downloader.isDownloaded
                    anchors.top: parent.verticalCenter
                    anchors.left: isNewIcon.right
                    width: Theme.iconSizeSmall
                    source: "image://theme/icon-s-device-download?"
                            + (episode.highlighted ? Theme.highlightColor : Theme.primaryColor)
                }

                Label {
                    id: pubDateLabel
                    anchors.top: parent.verticalCenter
                    anchors.left: numberLabel.right
                    anchors.leftMargin: Theme.paddingSmall
                    width: parent.width - x
                    text: new Date(pubDate).toLocaleDateString()
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: episode.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                }

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Mark as listened")
                        visible: !isListened
                        onClicked: listenedEpisodes.setValue(title, true)
                    }
                    MenuItem {
                        text: qsTr("Mark as new")
                        visible: isListened
                        onClicked: listenedEpisodes.setValue(title, false)
                    }
                    MenuItem {
                        text: qsTr("Download" + " (" + (downloadSize / 1024 / 1024).toPrecision(3) + " MB)")
                        visible: !downloader.isDownloaded && !downloader.isDownloading
                        onClicked: downloader.startDownload()
                    }
                    MenuItem {
                        text: qsTr("Abort download" + " (" + (downloader.progress * 100).toPrecision(3) + " %)")
                        visible: downloader.isDownloading
                        onClicked: downloader.abortDownload()
                    }
                    MenuItem {
                        text: qsTr("Delete audio file" + " (" + (downloadSize / 1024 / 1024).toPrecision(3) + " MB)")
                        visible: downloader.isDownloaded
                        onClicked: downloader.deleteFile()
                    }
                    Text {
                        id: descriptionText
                        width: parent.width - 2*Theme.horizontalPageMargin
                        height: contentHeight + Theme.paddingMedium
                        x: Theme.horizontalPageMargin
                        wrapMode: Text.Wrap
                        textFormat: Text.RichText
                        color: Theme.highlightColor
                        font.pixelSize: Theme.fontSizeSmall
                        text: description
                    }
                }
            }
        }

        ViewPlaceholder {
            text: qsTr("No shows available")
            hintText: qsTr("Pull down to update")
            enabled: feedModel.count === 0 && !feedModel.busy
        }

        BusyIndicator {
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
            running: feedModel.count === 0 && feedModel.busy
        }

        VerticalScrollDecorator { flickable: listView }
    }
}
