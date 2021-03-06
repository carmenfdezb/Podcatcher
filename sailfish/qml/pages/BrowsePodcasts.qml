/**
 * This file is part of Podcatcher for Sailfish OS.
 * Authors: Johan Paul (johan.paul@gmail.com)
 *          Moritz Carmesin (carolus@carmesinus.de)
 *
 * Podcatcher for Sailfish OS is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Podcatcher for Sailfish OS is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Podcatcher for Sailfish OS.  If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0

Page {
    id: browsePage
    //orientationLock: PageOrientation.LockPortrait

    function openFile(file) {
        var component = Qt.createComponent(file)

        if (component.status == Component.Ready)
            pageStack.push(component);
        else
            console.log("Error loading component:", component.errorString());
    }

    SilicaFlickable{
        anchors.fill: parent

        PullDownMenu {


            MenuItem {
                text: qsTr("Import podcasts from gPodder")
                onClicked: {
                    pageStack.push(importFromGPodderComponent)

                }
            }

            MenuItem {
                text: qsTr("Add URL manually")
                onClicked: {
                    pageStack.push(addNewPodcastComponent)
                }
            }

            MenuItem {
                text: qsTr("Search")
                onClicked: {
                    myMenu.close();
                    openFile("SearchPodcasts.qml");
                }

            }

        }


        SilicaGridView {
            id: popularPodcastsGrid
            anchors.fill: parent
            anchors.bottomMargin: Theme.paddingMedium


            model: popularPodcastsModel
            cellWidth: (Screen.width)/3;
            cellHeight: cellWidth + 2*Theme.paddingMedium + 2*Theme.paddingSmall + 3*Theme.fontSizeTiny

            clip: true

            header:             PageHeader{
                id: queryPageTitle
                title: qsTr("Popular podcasts")
            }


            VerticalScrollDecorator{}


            delegate:
                Item {
                id: popularItem
                state: "notLoaded"

                Item {
                    id: loadedItem
                    width: popularPodcastsGrid.cellWidth
                    height: popularPodcastsGrid.cellHeight


                    Rectangle {
                        id: popularItemId
                        border.width: 1
                        border.color: "black"
                        color: "black"
                        smooth: true
                        width: parent.width-2
                        height: parent.height /*- subscribeButton.height*/-3*Theme.paddingSmall
                        //anchors.centerIn: loadedItem
                        anchors.top: parent.top
                        anchors.topMargin: Theme.paddingMedium
                        anchors.horizontalCenter: parent.Center
                        opacity: 0.2

                        BusyIndicator {
                            id: loadingIndicatorEpisode
                            anchors.centerIn: parent
                            visible: (popularItem.state == "notLoaded");
                            running: (popularItem.state == "notLoaded");
                            opacity: 1.0
                        }

                        Image {
                            id: popularLogoId;
                            source: logo;
                            anchors.top: popularItemId.top
                            anchors.left: popularItemId.left
                            anchors.margins: 1
                            width: parent.width-1
                            height: parent.width-1
                            visible: (popularItem.state != "notLoaded");
                        }

                        Label {
                            id: browseTitle
                            text: title
                            anchors.top: popularLogoId.bottom;
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: Theme.paddingSmall
                            height: 3*Theme.fontSizeTiny


                            font.pixelSize: Theme.fontSizeTiny
                            color: "black"
                            width: popularItemId.width - 2*Theme.paddingSmall
                            elide:  TruncationMode.Elide
                            wrapMode: Text.WordWrap
                        }


                        Rectangle{
                            anchors.fill: popularLogoId
                            color: "black"
                            opacity: .3
                        }

                        IconButton{

                            id: subscribeButton
                            anchors.centerIn: popularLogoId

                            icon.source: "image://theme/icon-l-add"

                            opacity: 0.0

                            onClicked: {
                                console.log("Subscribe to podcast with url: " + url)
                                mainPage.addPodcast(url, logoUrl);
                                pageStack.pop(mainPage);
                            }
                        }


                    }

                }

                states: [
                    State {
                        name: 'loaded'; when: popularLogoId.status == Image.Ready
                        PropertyChanges {
                            target: popularItemId
                            color: "white"
                            opacity: 1.0
                        }
                        PropertyChanges {
                            target: subscribeButton
                            opacity: 1.0
                        }
                    }
                ]


                transitions: Transition {
                    ParallelAnimation {
                        PropertyAnimation { property: "width"; duration: 500 }
                        PropertyAnimation { property: "height"; duration: 500 }
                        PropertyAnimation { property: "opacity"; duration: 500 }
                        PropertyAnimation { property: "color"; duration: 500 }
                    }
                }
            }

            ViewPlaceholder{
                enabled: (popularPodcastsModel.status == XmlListModel.Error);
                text:  qsTr("I am sorry!<BR><BR>")
                hintText: qsTr("Cannot get popular podcasts at this time.")
            }



        }

        XmlListModel {
            id: popularPodcastsModel
            source: "http://gpodder.net/toplist/15.xml"
            query: "/podcasts/podcast"

            XmlRole { name: "logo"; query: "logo_url/string()" }
            XmlRole { name: "title"; query: "title/string()" }
            XmlRole { name: "url"; query: "url/string()" }
            XmlRole { name: "logoUrl"; query: "logo_url/string()" }

            onStatusChanged: {
                console.log("XML loading status changed: " + status);
                console.log("XML error: " + popularPodcastsModel.errorString());
            }
        }

        Component{
            id: importFromGPodderComponent
            ImportFromGPodder{

            }
        }

        Component{
            id: addNewPodcastComponent
            Dialog {
                id: addNewPodcastSheet


                Column {
                    id: col
                    anchors.fill: parent
                    spacing: Theme.paddingMedium

                    DialogHeader{
                        title: qsTr("Add new podcast")
                        acceptText: qsTr("Add")
                    }

                    TextField {
                        id: podcastUrl
                        placeholderText: qsTr("Podcast RSS URL")
                        width: parent.width

                        Keys.onReturnPressed: {
                            parent.focus = true;
                        }
                    }
                }

                onStatusChanged: {
                    if (status == DialogStatus.Opening) {
                        podcastUrl.text = ""
                    }

                }

                onAccepted: {
                    mainPage.addPodcast(podcastUrl.text, "");
                    pageStack.pop(mainPage);
                }
            }
        }

        BusyIndicator {
            id: loadingIndicator
            anchors.centerIn: parent
            visible: (popularPodcastsModel.status == XmlListModel.Loading );
            running: (popularPodcastsModel.status == XmlListModel.Loading );
            opacity: 1.0
            size: BusyIndicatorSize.Large
        }
    }
}



