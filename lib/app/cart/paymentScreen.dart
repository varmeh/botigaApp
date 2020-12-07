import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

import '../../theme/index.dart';
import '../../util/index.dart' show StringExtensions, Flavor;
import '../../widgets/index.dart' show LoaderOverlay;
import '../../providers/index.dart' show OrdersProvider;

import '../tabbar.dart';
import 'orderStatusScreen.dart';

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
  bool _isWebViewVisible = true;

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
            child: Visibility(
              visible: _isWebViewVisible,
              child: WebView(
                debuggingEnabled: false,
                javascriptMode: JavascriptMode.unrestricted,
                onPageStarted: (url) {
                  if (url.containsIgnoreCase('status')) {
                    _showPaymentStatus();
                  }
                },
                onPageFinished: (url) {
                  if (url.contains('showPaymentPage')) {
                    setState(() => _isLoading = false);
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
      ),
    );
  }

  // https://developer.paytm.com/docs/show-payment-page/?ref=payments
  String _showPaymentPage() {
    final mid = Flavor.shared.paytmMid;
    return '''
		<html>
			<head>
				<title>Show Payment Page</title>
			</head>
			<body>
				<center>
					<h1 ${Platform.isAndroid ? '' : 'style="font-size:500%"'}>Please do not refresh this page...</h1>
				</center>
				<form method="post" action="${Flavor.shared.paytmTransactionUrl}/theia/api/v1/showPaymentPage?mid=$mid&orderId=${widget.paymentId}" name="paytm">
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

  void _showPaymentStatus() async {
    setState(() {
      _isWebViewVisible = false;
      _isLoading = true;
    });
    final provider = Provider.of<OrdersProvider>(context, listen: false);
    try {
      final order = await provider.getOrderStatus(
          '/api/user/orders/transaction/status?paymentId=${widget.paymentId}');
      Future.delayed(Duration(milliseconds: 25), () {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => OrderStatusScreen(order),
            transitionDuration: Duration.zero,
          ),
          (route) => false,
        );
      });
    } catch (_) {
      _showFailureMessage();
    } finally {
      // Clear order list to enable reloading of orders
      provider.resetOrders();
      setState(() => _isLoading = true);
    }
  }

  void _showFailureMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Payment Status Unavailable',
          style: AppTheme.textStyle.w500.color100,
        ),
        content: Text(
          'Unable to fetch order payment status. We would redirect you to orders screen for details. Sorry for the inconvinence',
          style: AppTheme.textStyle.w400.color100,
        ),
        actions: [
          FlatButton(
            child: Text(
              'Close',
              style: AppTheme.textStyle.w600.colored(AppTheme.primaryColor),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => Tabbar(index: 1),
                  transitionDuration: Duration.zero,
                ),
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}
