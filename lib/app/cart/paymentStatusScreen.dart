import 'package:flutter/material.dart';

import '../../theme/index.dart';

enum PaymentStatus { success, failure, pending }

class PaymentStatusScreen extends StatefulWidget {
  final PaymentStatus status;

  PaymentStatusScreen(this.status);

  @override
  _PaymentStatusScreenState createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
      () => Navigator.of(context).popUntil((route) => route.isFirst),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.status.message,
                    textAlign: TextAlign.center,
                    style: AppTheme.textStyle.w700.color100.size(25.0),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.status.description,
                  style: AppTheme.textStyle.w500.color50.size(20.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension PaymentStatusExtension on PaymentStatus {
  String get message {
    switch (this) {
      case PaymentStatus.success:
        return 'Payment Successful';
      case PaymentStatus.failure:
        return 'Payment Failure';
      default:
        return 'Payment Pending';
    }
  }

  String get description {
    switch (this) {
      case PaymentStatus.success:
        return 'Your payment has been successful.';
      case PaymentStatus.failure:
        return 'Your payment has failed.\nAny amount deducted will be transferred back.\nPlease try payment again.';
      default:
        return 'Your payment status has not been confirmed.\nWe will get confirmation in 20 mins.\nPlease wait & your order payment status after 20 mins.';
    }
  }
}
