/*--------------------------------------------------------
* Module Name : Helium Mobile Browser
* Version : 1.0
*
* Software Name : Helium Mobile Browser
* Version : 1.0
*
* Copyright (c) 2010 - 2011 France Telecom
* This software is distributed under the LGPL v2.1 license,
* the text of which is available at http://www.gnu.org/licenses/lgpl-2.1.html
* or see the "LICENSE.txt" file for more details.
*
*--------------------------------------------------------
* File Name   : Header.qml
*
* Created     : 15 June 2011
*
*--------------------------------------------------------
* 1.0 - First open source release
*
*/

import QtQuick 1.1

import "common"

Item {
   id: header
   property alias loading: fieldText.loading

   height: 100
   z: 1

   signal urlChanged(string urlString)
   function changeUrl(urlString) {
      fieldText.text = urlString;
   }

   function abortEdit() {
      fieldText.abortEdit();
   }

   function setDefaultFavIcon() {
      fieldText.setDefaultFavIcon();
   }

   function updateFavIcon() {
      fieldText.updateFavIcon();
   }

   BorderImage {
      id: headerSkeleton
      source: "qrc:/qmls/pics/bar-bg-10x80.png"
      border.top: 1
      border.bottom: 1
      width: parent.width
      height: parent.height

      //in case zoom is active don't move the header along panning
      x: webView.zoomActive?0 : webView.contentX < 0 ? -webView.contentX : webView.contentX > webView.contentWidth-webView.width
      ? -webView.contentX+webView.contentWidth-webView.width : 0
      y: webView.contentY < 0 ? webView.zoomActive ? 0: -webView.contentY : progressOff*
            (webView.contentY>height?-height:-webView.contentY)

      // Busy Loading Icon
      Image {
         id : busyLoadingIcon
         source: "qrc:/qmls/pics/busy-loading-26x26.png"
         height: headerText.height-4
         width: height
         smooth: true
         anchors.verticalCenter: headerText.verticalCenter
         anchors.left: headerSkeleton.left
         anchors.leftMargin: 2
         states: [
            State {
               name: "hidden"; when: !header.loading;
               PropertyChanges { target: busyLoadingIcon; source: ""; rotation:0 }
               PropertyChanges { target: rotationAnimation; running: false; }
            },
            State {
               name: "visible"; when: header.loading;
               PropertyChanges { target: busyLoadingIcon; source: "qrc:/qmls/pics/busy-loading-26x26.png"}
               PropertyChanges { target: rotationAnimation; running: true; }
            }
         ]

         NumberAnimation {
            id: rotationAnimation
            target: busyLoadingIcon; property: "rotation";
            from: 360; to: 0; loops: Animation.Infinite; easing.type: "Linear"; duration: 5000;
         }
      }

      // Header Text: Holds the Page Title
      Text {
         id: headerText

         text: (webView.title != '' || !webView.loading) ? webView.title : 'Loading...';
         elide: Text.ElideMiddle

         color: "white"
         styleColor: "black"
         style: Text.Sunken

         font.family: "Helvetica"
         //font.pointSize: 20
         font.pixelSize: 20
         font.bold: true

         anchors.left: busyLoadingIcon.right
         anchors.right: headerSkeleton.right
         anchors.leftMargin: 4
         anchors.rightMargin: 4
         anchors.top: headerSkeleton.top
         anchors.topMargin: 2
         horizontalAlignment: Text.AlignHCenter
      }


      FieldText {
         id: fieldText

         onEditFinished: { header.urlChanged(fieldText.text); }
         onReloadRequested: { webView.reload.trigger(); }
         onStopRequested: { webView.stop.trigger(); }

         anchors.top: headerText.bottom
         anchors.topMargin: 4
         anchors.bottom: parent.bottom
         anchors.bottomMargin: UiConstants.DefaultMargin
         anchors.left: parent.left
         anchors.right: parent.right
         anchors.leftMargin: UiConstants.DefaultMargin
         anchors.rightMargin: UiConstants.DefaultMargin

         BorderImage {
            source: "qrc:/qmls/pics/progressbar.png"
            border.bottom: 17
            border.top: 17
            border.left: 13
            border.right: 0
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: (fieldText.width-24) * webView.progress

            verticalTileMode: BorderImage.Stretch
            horizontalTileMode: BorderImage.Stretch

            opacity: 0.8-headerSkeleton.progressOff
            clip: true
            z:4
         }
      }

      property real progressOff : 1
      states: [
          State {
              name: "ProgressShown"
              when: webView.progress < 1.0
              PropertyChanges { target: headerSkeleton; progressOff: 0; }
          }
      ]
      transitions: [
          Transition {
              PropertyAnimation {
                  target: headerSkeleton
                  property: "progressOff"
                  easing.type: "InOutQuad"
                  duration: 300
              }
          }
      ]
   }
}
