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
* File Name   : FlickableWebView.qml
*
* Created     : 15 June 2011
*
*--------------------------------------------------------
* 1.0 - First open source release
*
*/

import QtQuick 1.1
import QtWebKit 1.0

Flickable {
   id: flickable

   // Properties
   property alias title: webView.title
   property alias progress: webView.progress
   property alias url: webView.url
   property alias back: webView.back
   property alias reload: webView.reload
   property alias stop: webView.stop
   property alias forward: webView.forward
   property alias icon: webView.icon
   property bool loading: webView.progress != 1.0
   property bool zoomActive: false

   // Signals
   signal gotFocus
   signal lostFocus
   signal urlChanged(string urlString)
   signal iconChanged()

   // Functions
   function changeUrl(urlString) {
       if(urlString)
           webView.setUrl(urlString);
   }

   width: parent.width
   contentWidth: Math.max(parent.width,webView.width)
   contentHeight: Math.max(parent.height,webView.height)
   onWidthChanged: {
      // Expand (but not above 1:1) if otherwise would be smaller that available width.
      if (width > webView.width*webView.contentsScale && webView.contentsScale < 1.0)
         webView.contentsScale = width / webView.width * webView.contentsScale;
   }


   pressDelay: 200
//   interactive: webView.focus // If the "webView" has focus, then it's flickable
   onFocusChanged: { if ( focus ) webView.focus = true; } // Force focus on "webView" when received

   onMovementStarted: webView.renderingEnabled = false;

   onMovementEnded: webView.renderingEnabled = true;
   PinchArea {
      id: pinchArea
      anchors.fill: parent
      property bool pinchDragged:false

      onPinchStarted: {
         webView.renderingEnabled=false
         flickable.zoomActive=true
      }

      onPinchUpdated: {
         webView.doPinchZoom(pinch.scale/pinch.previousScale,pinch.center,pinch.previousCenter)
      }

      onPinchFinished: {

         if(contentX<0 || contentY<0){
            var sc = webView.contentsScale
            if(webView.contentsScale*webView.width<flickable.width){
               sc=flickable.width/(webView.width/webView.contentsScale)
            }
            var vx=Math.max(0,contentX)+(flickable.width/2)
            var vy=Math.max(0,contentY)+(flickable.height/2)
            // doZoom will reset zoomActive to false and renderingEnabled to true
            webView.doZoom(sc,vx,vy);
         }else{
            webView.renderingEnabled=true;
            flickable.zoomActive=false;
         }

      }

      WebView {
         id: webView
         objectName: "webView"
         transformOrigin: Item.TopLeft

         // Set the URL for this WebView
         function setUrl(urlString) { this.url = appcore.fixUrl(urlString); }

         // Execute the Zooming
         function doZoom(zoom,centerX,centerY)
         {
            if (centerX) {
               var sc = zoom/contentsScale;
               scaleAnim.to = zoom;
               flickVX.from = flickable.contentX
               flickVX.to = Math.max(0,Math.min(centerX-flickable.width/2,webView.width*sc-flickable.width))
               finalX.value = flickVX.to
               flickVY.from = flickable.contentY
               flickVY.to = Math.max(0,Math.min(centerY-flickable.height/2,webView.height*sc-flickable.height))
               finalY.value = flickVY.to
               quickZoom.start()
            }
         }
         // Calculates new contentX and contentY for flickable and contentsScale for webview
         function doPinchZoom(zoom,center,centerPrev)
         {
            var sc=zoom*contentsScale
            if(sc<=10 ){
               //calculate contentX and contentY so webview moves along with the pinch
               flickable.contentX=(center.x*zoom)-(center.x-flickable.contentX)+(centerPrev.x-center.x)
               flickable.contentY=(center.y*zoom)-(center.y-flickable.contentY)+(centerPrev.y-center.y)
               contentsScale=sc
            }

         }

         url: {
            appcore.fixUrl(appcore.currentUrl);

         }
         Connections {
            target: appcore
            onCurrentUrlChanged: { webView.url = appcore.fixUrl(appcore.currentUrl); }
            onShowingBrowserView: { webView.focus = true; }
         }

         smooth: false // We don't want smooth scaling, since we only scale during (fast) transitions
         focus: true

         preferredWidth: flickable.width
         preferredHeight: flickable.height
         contentsScale: 1

         // [Signal Handling]
         Keys.onLeftPressed: { webView.contentsScale -= 0.1; }
         Keys.onRightPressed: { webView.contentsScale += 0.1; }
         onAlert: { console.log(message); }
         onFocusChanged: {
            if ( focus == true ) { flickable.gotFocus(); }
            else { flickable.lostFocus(); }
         }
         onContentsSizeChanged: { webView.contentsScale = Math.min(1,flickable.width / contentsSize.width); }
         onUrlChanged: {
            // Reset Content to the TopLeft Corner
            flickable.contentX = 0
            flickable.contentY = 0
            webView.focus = true;
            if ( url != null ) {
               flickable.urlChanged(url.toString());
            }
         }
         onDoubleClick: {
            var zf=2.0
            // if zoomed go back to screen width
            if(webView.contentsScale*webView.width>flickable.width){
               zf=flickable.width/(webView.width/webView.contentsScale)
               doZoom(zf,clickX*zf,clickY*zf)
            // try to do heuristic zoom with maximum 2.5x
            }else if (!heuristicZoom(clickX, clickY, 2.5)) {
               // if no heuristic zoom found, zoom to 2.0x
               doZoom(zf,clickX*zf,clickY*zf)
            }

         }
         onIconChanged: { flickable.iconChanged(); }
         onLoadFinished: { if ( appcore ) { appcore.historyCurrentUrl(); } }
         onLoadFailed: { webView.stop.trigger(); }
         onZoomTo: { doZoom(zoom,centerX,centerY); }
         // [/Signal Handling]

         SequentialAnimation {
            id: quickZoom

            PropertyAction {
               target: webView
               property: "renderingEnabled"
               value: false
            }
            ParallelAnimation {
               NumberAnimation {
                  id: scaleAnim
                  target: webView; property: "contentsScale";
                  // the to property is set before calling
                  easing.type: Easing.Linear; duration: 200;
               }
               NumberAnimation {
                  id: flickVX
                  target: flickable; property: "contentX";
                  easing.type: Easing.Linear; duration: 200;
                  from: 0 // set before calling
                  to: 0 // set before calling
               }
               NumberAnimation {
                  id: flickVY
                  target: flickable; property: "contentY";
                  easing.type: Easing.Linear; duration: 200;
                  from: 0 // set before calling
                  to: 0 // set before calling
               }
            }
            // Have to set the contentXY, since the above 2
            // size changes may have started a correction if
            // contentsScale < 1.0.
            PropertyAction {
               id: finalX
               target: flickable; property: "contentX";
               value: 0 // set before calling
            }
            PropertyAction {
               id: finalY
               target: flickable; property: "contentY";
               value: 0 // set before calling
            }
            PropertyAction {
               target: webView; property: "renderingEnabled";
               value: true
            }
            PropertyAction {
               target: flickable; property: "zoomActive";
               value: false
            }
         }
      }
   }
}
