import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/index.dart';

class PaymentScreen extends StatefulWidget {
  final String orderNumber;
  final String txnToken;

  PaymentScreen({
    @required this.orderNumber,
    @required this.txnToken,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  WebViewController _webController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  void dispose() {
    _webController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebView(
            debuggingEnabled: false,
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (url) {
              print(url);
            },
            onPageFinished: (url) {
              print(url);
            },
            onWebViewCreated: (controller) {
              _webController = controller;

              _webController.loadUrl(new Uri.dataFromString(
                _loadSubmitRequest(),
                mimeType: 'text/html',
              ).toString());
            },
          ),
        ),
      ),
    );
  }

  String _loadSubmitRequest() {
    return '''
		<html>
			<head>
				<title>Show Payment Page</title>
			</head>
			<body>
				<center>
					<h1>Please do not refresh this page...</h1>
				</center>
				<form method="post" action="https://securegw-stage.paytm.in/theia/api/v1/showPaymentPage?mid=OJdkNI97902555723463&orderId=${widget.orderNumber}" name="paytm">
					<table border="1">
							<tbody>
								<input type="hidden" name="mid" value="OJdkNI97902555723463">
								<input type="hidden" name="orderId" value="${widget.orderNumber}">
								<input type="hidden" name="txnToken" value="${widget.txnToken}">
							</tbody>
					</table>
					<script type="text/javascript"> document.paytm.submit(); </script>
				</form>
			</body>
		</html>
		''';
  }
}
