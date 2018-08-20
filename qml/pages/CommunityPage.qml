import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: communityPage
    property string communityUrl: "https://community.badvoltage.org?mobile_view=1"

    SilicaWebView {
        id: webView
        anchors.fill: parent

        PullDownMenu {
            busy: webView.loading
            MenuItem {
                text: qsTr("Home")
                onClicked: webView.url = communityUrl
                visible: webView.url !== communityUrl
            }
            MenuItem {
                text: qsTr("Reload")
                onClicked: webView.reload()
            }
            MenuItem {
                text: qsTr("Back")
                onClicked: webView.goBack()
                visible: webView.canGoBack
            }
        }

        /*header: PageHeader {
            id: webViewHeader
            //: Header of the Community page
            title: qsTr("Community")
            //description: webView.url
            description: webView.title
        }*/

        url: communityUrl
    }

    BusyIndicator {
        id: busyIndicator
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: webView.loading
    }

    allowedOrientations: Orientation.All
}
