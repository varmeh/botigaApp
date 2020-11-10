import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

import '../../theme/index.dart';
import '../../widgets/index.dart' show LoaderOverlay;
import '../../providers/index.dart' show OrdersProvider;
import 'paymentStatusScreen.dart';

class PaymentScreen extends StatefulWidget {
  static const route = 'payment';

  final String paymentId;
  final String paymentToken;

  PaymentScreen({
    @required this.paymentId,
    @required this.paymentToken,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  WebViewController _webController;
  bool _isLoading = true;

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
              onPageFinished: (url) {
                if (url.contains('showPaymentPage')) {
                  setState(() => _isLoading = false);
                }
                if (url.contains('/transaction/status')) {
                  _showPaymentStatus();

                  // Clear order list to enable reloading of orders
                  Provider.of<OrdersProvider>(context, listen: false)
                      .resetOrders();
                }
              },
              onWebViewCreated: (controller) {
                _webController = controller;

                _webController.loadUrl(new Uri.dataFromString(
                  _showPaymentPage(),
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
  String _showPaymentPage() {
    const mid = 'OJdkNI97902555723463'; // TODO: update merchant id
    return '''
		<html>
			<head>
				<title>Show Payment Page</title>
			</head>
			<body>
				<center>
					<h1 style="font-size:500%">Please do not refresh this page...</h1>
				</center>
				<form method="post" action="https://securegw-stage.paytm.in/theia/api/v1/showPaymentPage?mid=$mid&orderId=${widget.paymentId}" name="paytm">
					<table border="1">
							<tbody>
								<input type="hidden" name="mid" value="$mid">
								<input type="hidden" name="orderId" value="${widget.paymentId}">
								<input type="hidden" name="txnToken" value="${widget.paymentToken}">
							</tbody>
					</table>
					<script type="text/javascript"> document.paytm.submit(); </script>
				</form>
			</body>
		</html>
		''';
  }

  void _showPaymentStatus() {
    _webController.evaluateJavascript('document.body.innerText').then((data) {
      var decodedJSON = jsonDecode(data);
      final txnStatus = decodedJSON['status'];
      PaymentStatus status = PaymentStatus.pending;
      if (txnStatus == 'success') {
        status = PaymentStatus.success;
      } else if (txnStatus == 'failure') {
        status = PaymentStatus.failure;
      }
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => PaymentStatusScreen(status),
          transitionDuration: Duration.zero,
        ),
      );
    });
  }
}
