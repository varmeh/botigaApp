import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/index.dart';
import '../../widgets/index.dart' show LoaderOverlay;

class PaymentScreen extends StatefulWidget {
  final String orderId;
  final String txnToken;

  PaymentScreen({
    @required this.orderId,
    @required this.txnToken,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  WebViewController _webController;
  bool _isLoading = false;

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
        child: LoaderOverlay(
          isLoading: _isLoading,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: WebView(
              debuggingEnabled: false,
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (url) {
                print('started: $url');
                setState(() => _isLoading = true);
              },
              onPageFinished: (url) {
                print('ended: $url');
                setState(() => _isLoading = false);
              },
              onWebViewCreated: (controller) {
                _webController = controller;

                _webController.loadUrl(new Uri.dataFromString(
                  __showPaymentPage(),
                  mimeType: 'text/html',
                ).toString());
              },
            ),
          ),
        ),
      ),
    );
  }

  // https://developer.paytm.com/docs/show-payment-page/?ref=payments
  String __showPaymentPage() {
    return '''
		<html>
			<head>
				<title>Show Payment Page</title>
			</head>
			<body>
				<center>
					<h1>Please do not refresh this page...</h1>
				</center>
				<form method="post" action="https://securegw-stage.paytm.in/theia/api/v1/showPaymentPage?mid=OJdkNI97902555723463&orderId=${widget.orderId}" name="paytm">
					<table border="1">
							<tbody>
								<input type="hidden" name="mid" value="OJdkNI97902555723463">
								<input type="hidden" name="orderId" value="${widget.orderId}">
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
