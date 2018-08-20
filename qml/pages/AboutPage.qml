/*******************************************************************************
  * AboutPage.qml
  *
  * Autor: Scharel Clemens <scharelc@gmail.com>
  * Copyright: 2014 Scharel Clemens
  *
  * This file is part of BadVoltage.
  *
  * BadVoltage is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 3 of the License, or
  * (at your option) any later version.
  *
  * BadVoltage is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with BadVoltage.  If not, see <http://www.gnu.org/licenses/>.
  *
  *****************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutPage

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        Column {
            id: column

            x: Theme.horizontalPageMargin
            width: parent.width - 2*Theme.horizontalPageMargin
            spacing: Theme.paddingMedium

            PageHeader {
                //: Header of the About page
                title: qsTr("About")
            }

            Text {
                width: parent.width
                color: Theme.highlightColor
                wrapMode: Text.Wrap
                textFormat: Text.StyledText
                linkColor: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                onLinkActivated: Qt.openUrlExternally(link)
                text: "<strong>Bad Voltage</strong> is a podcast with Jono Bacon, Jeremy Garcia, and Stuart Langridge (and formerly Bryan Lunduke in series 1), in which they talk about anything that interests them. Technology, Open Source, Politics, Music…anything and everything is up for grabs, complete with reviews and interviews.<br />
                    <br />
                    The show very community driven and we encourage you to share your feedback on the show as well as ideas and other topics of discussion over on <a href=\"http://community.badvoltage.org/\">our community forum</a>.<br />
                    <br />
                    <strong>Colophon / Licensing</strong><br />
                    The shows are released under the <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">Creative Commons Attribution Share-Alike</a> license and as are free to listen to and share with others. <a href=\"http://ccmixter.org/files/FreeInstrumentalMusic/43270\">This music</a> is used for the theme music."
            }

            Separator {
                width: parent.width
                color: Theme.primaryColor
            }

            Text {
                width: parent.width
                color: Theme.highlightColor
                wrapMode: Text.Wrap
                textFormat: Text.StyledText
                linkColor: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                onLinkActivated: Qt.openUrlExternally(link)
                text: "<strong>This program</strong> is free software: you can redistribute it and/or modify
                    it under the terms of the GNU General Public License as published by
                    the Free Software Foundation, either version 3 of the License, or
                    (at your option) any later version.<br />
                    <br />
                    This program is distributed in the hope that it will be useful,
                    but WITHOUT ANY WARRANTY; without even the implied warranty of
                    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                    GNU General Public License for more details.<br />
                    <br />
                    You should have received a copy of the GNU General Public License
                    along with this program.  If not, see<br />
                    <a href=\"https://www.gnu.org/licenses/\">www.gnu.org/licenses</a>.<br />
                    <br />
                    The source code is available on <a href=\"https://github.com/badvoltage/sailfish-app/wiki\">GitHub</a>."
            }

            Button {
                //: Button to page showing the license
                text: qsTr("License")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: pageStack.push(Qt.resolvedUrl("LicensePage.qml"))
            }
        }

        ScrollDecorator { }
    }
}
