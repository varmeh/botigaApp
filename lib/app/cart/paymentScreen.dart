import 'package:flutter/material.dart';

import '../../theme/index.dart';
import '../../widgets/index.dart' show BotigaAppBar;

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar(''),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Payment Screen'),
        ),
      ),
    );
  }
}
