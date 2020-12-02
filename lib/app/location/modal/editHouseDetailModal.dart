import 'package:flutter/material.dart';

import '../../../models/index.dart' show AddressModel;
import '../../../providers/index.dart' show AddressUtil;
import '../../../theme/index.dart';
import '../../../util/index.dart' show Http;
import '../../../widgets/index.dart'
    show BotigaTextFieldForm, ActiveButton, BotigaBottomModal, Toast;

class EditHouseDetailModal {
  BotigaBottomModal _bottomModal;
  String _houseNumber;
  GlobalKey<FormState> _aptFormKey = GlobalKey<FormState>();

  void show(
    BuildContext context,
    AddressModel address,
  ) {
    _bottomModal = _modal(context, address);

    // Show bottom modal
    _bottomModal.show(context);
  }

  BotigaBottomModal _modal(BuildContext context, AddressModel address) {
    const sizedBox24 = SizedBox(height: 24);
    return BotigaBottomModal(
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
                'Update Address',
                style: AppTheme.textStyle.w700.color100
                    .size(20.0)
                    .lineHeight(1.25),
              ),
            ],
          ),
          sizedBox24,
          Text(
            address.apartment,
            style: AppTheme.textStyle.w500.color100.size(17.0).lineHeight(1.3),
          ),
          SizedBox(height: 8.0),
          Text(
            '${address.area}, ${address.city}, ${address.state} - ${address.pincode}',
            style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
          ),
          sizedBox24,
          Form(
            key: _aptFormKey,
            child: BotigaTextFieldForm(
              initialValue: address.house,
              focusNode: null,
              labelText: 'Flat No / House No',
              onSave: (value) {
                _houseNumber = value;
              },
              validator: (value) => value.isEmpty ? 'Required' : null,
              onFieldSubmitted: (_) => _updateAddress(context, address),
            ),
          ),
          sizedBox24,
          ActiveButton(
            title: 'Continue',
            onPressed: () => _updateAddress(context, address),
          ),
        ],
      ),
    );
  }

  void _updateAddress(BuildContext context, AddressModel address) async {
    if (_aptFormKey.currentState.validate()) {
      _aptFormKey.currentState.save();

      FocusScope.of(context).unfocus();
      _bottomModal.animation(true);
      try {
        await AddressUtil.updateAddress(
          context: context,
          house: _houseNumber,
          address: address,
        );
        Navigator.pop(context);
      } catch (error) {
        Toast(message: Http.message(error)).show(context);
      } finally {
        _bottomModal.animation(false);
      }
    }
  }
}
