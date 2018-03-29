import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: communityPage

    SilicaWebView {
        id: webView
        anchors.fill: parent

        PullDownMenu {
            busy: webView.loading
            MenuItem {
                text: qsTr("Back")
                onClicked: webView.goBack()
                enabled: webView.canGoBack
            }
        }

        header: PageHeader {
            //: Header of the Community page
            title: qsTr("Community")
        }

        url: "http://community.badvoltage.org?mobile_view=1"
    }

    BusyIndicator {
        id: busyIndicator
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: webView.loading
    }

    allowedOrientations: Orientation.All
}
