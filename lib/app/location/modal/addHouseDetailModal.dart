import 'package:flutter/material.dart';

import '../../../models/apartmentModel.dart';
import '../../../providers/index.dart' show AddressUtil;
import '../../../theme/index.dart';
import '../../../util/index.dart' show Http;
import '../../../widgets/index.dart'
    show BotigaTextFieldForm, ActiveButton, BotigaBottomModal, Toast;
import '../../tabbar.dart';

class AddHouseDetailModal {
  BotigaBottomModal _bottomModal;
  String _houseNumber;
  GlobalKey<FormState> _aptFormKey = GlobalKey<FormState>();

  void show({
    BuildContext context,
    ApartmentModel apartment,
    bool clearCart,
  }) {
    const sizedBox24 = SizedBox(height: 24);

    _bottomModal = BotigaBottomModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/homeOutline.png',
                color: AppTheme.color100,
              ),
              SizedBox(width: 12.0),
              Text(
                'Your Address',
                style: AppTheme.textStyle.w700.color100
                    .size(20.0)
                    .lineHeight(1.25),
              ),
            ],
          ),
          sizedBox24,
          Text(
            apartment.name,
            style: AppTheme.textStyle.w500.color100.size(17.0).lineHeight(1.3),
          ),
          SizedBox(height: 8.0),
          Text(
            '${apartment.area}, ${apartment.city}, ${apartment.state} - ${apartment.pincode}',
            style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
          ),
          sizedBox24,
          Form(
            key: _aptFormKey,
            child: BotigaTextFieldForm(
              focusNode: null,
              labelText: 'Flat No / House No',
              onSave: (value) {
                _houseNumber = value;
              },
              validator: (value) => value.isEmpty ? 'Required' : null,
              onFieldSubmitted: (_) =>
                  _addAddress(context, apartment, clearCart),
            ),
          ),
          sizedBox24,
          ActiveButton(
            title: 'Continue',
            onPressed: () => _addAddress(context, apartment, clearCart),
          ),
        ],
      ),
    );

    // Show bottom modal
    _bottomModal.show(context);
  }

  void _addAddress(
      BuildContext context, ApartmentModel apartment, bool clearCart) async {
    if (_aptFormKey.currentState.validate()) {
      _aptFormKey.currentState.save();

      FocusScope.of(context).unfocus();
      _bottomModal.animation(true);
      try {
        await AddressUtil.addAddress(
          context: context,
          house: _houseNumber,
          apartmentId: apartment.id,
          clearCart: clearCart,
        );
        int screenIndex = clearCart ? 0 : 2;
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Tabbar(index: screenIndex),
            transitionDuration: Duration.zero,
          ),
          (route) => false,
        );
      } catch (error) {
        Toast(message: Http.message(error)).show(context);
      } finally {
        _bottomModal.animation(false);
      }
    }
  }
}
