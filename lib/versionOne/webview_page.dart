import 'dart:async';
import 'dart:io';

import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String? url;
  final String? title;
  const WebViewPage({this.url, this.title, Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var loadingState = true;

  @override
  Widget build(BuildContext context) {
    debugPrint(_controller.isCompleted.toString());
    // debugPrint(loadingState.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.title}'),
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: widget.url ?? 'https://fonts.google.com/',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                debugPrint('Loading Page (progress : $progress%)');
              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
              onPageStarted: (String url) {
                debugPrint('Page started loading: $url');
              },
              onPageFinished: (finish) {
                setState(() {
                  loadingState = false;
                });
              },
              gestureNavigationEnabled: true,
              backgroundColor: const Color(0x00000000),
            ),
            loadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(),
          ],
        ));
  }

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          showNormalSnackBar(context, message.message);
        });
  }
}
