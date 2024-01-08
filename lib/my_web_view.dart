import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  const MyWebView({super.key, required this.controller});
  final WebViewController controller;

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  var loadingPercentage = 0 ;
  @override
  void initState(){
    super.initState();
    widget.controller..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url){
          setState(() {
            loadingPercentage=0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage=100; 
          });
        },
      )
    )..setJavaScriptMode(JavaScriptMode.unrestricted)..addJavaScriptChannel("SnackBar", onMessageReceived: (message){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)));
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Stack(
  children: [
    WebViewWidget(controller: widget.controller),
    if (loadingPercentage < 100)
      Positioned.fill(
        child: Container(
          color: Colors.white.withOpacity(1),
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.blueGrey,
            ),
          ),
        ),
      ),
  ],
);

  }
}
