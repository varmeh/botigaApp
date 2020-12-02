import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../theme/index.dart';
import 'index.dart' show BotigaAppBar;

class PolicyWebiewScreen extends StatefulWidget {
  final String url;

  PolicyWebiewScreen(this.url);

  @override
  _PolicyWebiewScreenState createState() => _PolicyWebiewScreenState();
}

class _PolicyWebiewScreenState extends State<PolicyWebiewScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar(''),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebView(
            initialUrl: widget.url,
            debuggingEnabled: false,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
