import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storak/home.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'manage/static_method.dart';

class WebViewPage extends StatefulWidget {
  final String? sUrl;

  const WebViewPage(this.sUrl, {Key? key}) : super(key: key);

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  WebViewController controller = WebViewController();
  @override
  void initState() {
    controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(widget.sUrl.toString()))
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (url) {
          setState(() {
            if (url.contains('success_page')) {
              STM().successDialogWithReplace(
                ctx,
                "Payment successfully",
                Home()
              );
            } else if (url.contains("failed_page")) {
              STM().displayToast("Payment Failed",ToastGravity.CENTER);
              STM().back2Previous(ctx);
            }
          });
        },
      )
    );

    super.initState();
  }

  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
