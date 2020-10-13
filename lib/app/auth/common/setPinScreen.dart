import 'package:flutter/material.dart';

import '../../../theme/index.dart';
import '../../../widgets/index.dart';

class SetPinScreen extends StatefulWidget {
  static final route = 'setPin';

  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  GlobalKey<FormState> _form = GlobalKey();
  String pinValue = '';

  @override
  Widget build(BuildContext context) {
    final String message = ModalRoute.of(context).settings.arguments;
    const sizedBox = SizedBox(height: 32);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppTheme.color100,
          ),
        ),
        title: Text(
          'Set PIN',
          style: AppTheme.textStyle.w600.color100.size(20).lineHeight(1.25),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          color: AppTheme.backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              sizedBox,
              Text(
                message,
                style: AppTheme.textStyle.w500.color50.size(13).lineHeight(1.5),
              ),
              sizedBox,
              pinTextField(),
              sizedBox,
              setPinButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget pinTextField() {
    return Form(
      key: _form,
      child: PinTextField(
        pins: 4,
        onSaved: (val) => pinValue = val,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }

  Container setPinButton() {
    return Container(
      width: 160,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8.0),
        ),
        onPressed: () {
          if (_form.currentState.validate()) {
            _form.currentState.save(); //value saved in pinValue
            Navigator.of(context).pushNamed('');
          }
        },
        color: AppTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            'Set Pin',
            style: AppTheme.textStyle.w600
                .size(15.0)
                .lineHeight(1.5)
                .colored(AppTheme.backgroundColor),
          ),
        ),
      ),
    );
  }
}
