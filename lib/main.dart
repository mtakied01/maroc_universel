import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'my_web_view.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: const Color.fromRGBO(15, 66, 66, 1)));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maroc Universel',
      theme: ThemeData(useMaterial3: true),
      home: WebViewApp(),
    );
  }
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()..loadRequest(Uri.parse("https://marocuniversel.com/"));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(await controller.canGoBack()){
        await controller.goBack();
        return false;
        }
        else{
           final value = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('تنبيه',textDirection: TextDirection.rtl),
              content: const Text('هل تريد الخروج؟',textDirection: TextDirection.rtl),
              actions: [
                ElevatedButton(
                  onPressed: () {
                      Navigator.of(context).pop(false); // Close dialog if unable to go back
                    
                    },
                  child: const Text('لا',textDirection: TextDirection.rtl,),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('خروج',textDirection: TextDirection.rtl,),
                ),
              ],
            );
          },
        );
         return value ?? false; 
        }
        // // return false if the dialog is dismissed
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(28.0),
          child: Container(
            height: 28,
          ),
        ),
        body: MyWebView(controller: controller),
      ),
    );
  }
}
