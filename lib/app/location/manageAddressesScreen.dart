import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show UserProvider, AddressUtil;
import '../../models/index.dart' show AddressModel;
import '../../util/index.dart' show Http;
import '../../theme/index.dart';
import '../../widgets/index.dart'
    show BotigaAppBar, LoaderOverlay, PassiveButton, Toast;

import 'modal/editHouseDetailModal.dart';
import 'addAddressScreen.dart';

class ManageAddressesScreen extends StatefulWidget {
  static final String route = 'manageAddressesScreen';

  @override
  _ManageAddressesScreenState createState() => _ManageAddressesScreenState();
}

class _ManageAddressesScreenState extends State<ManageAddressesScreen> {
  bool _isLoading = false;
  UserProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Saved Addresses'),
      bottomNavigationBar: _addAddressButton(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: LoaderOverlay(
            isLoading: _isLoading,
            child: ListView.builder(
              itemCount: _provider.addresses.length,
              itemBuilder: (context, index) {
                return _addressTile(_provider.addresses[index]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _addressTile(AddressModel address) {
    const sizedBox16 = SizedBox(height: 16);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBox16,
        Text(
          '${address.house}, ${address.apartment}',
          style: AppTheme.textStyle.w500.color100.size(17.0).lineHeight(1.3),
        ),
        SizedBox(height: 8.0),
        Text(
          '${address.area}, ${address.city}, ${address.state} - ${address.pincode}',
          style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
        ),
        sizedBox16,
        _addressButtons(address),
        sizedBox16,
        Divider(
          thickness: 1.0,
          color: AppTheme.dividerColor,
        ),
      ],
    );
  }

  Widget _addressButtons(AddressModel address) {
    final style = AppTheme.textStyle.w600
        .size(13)
        .lineHeight(1.5)
        .colored(AppTheme.primaryColor);
    return Row(
      children: [
        GestureDetector(
          onTap: () => EditHouseDetailModal().show(context, address),
          child: Text(
            'Edit',
            style: style,
          ),
        ),
        SizedBox(width: 24.0),
        GestureDetector(
          onTap: () => _deleteAddress(address.id),
          child: Text(
            'Delete',
            style: style,
          ),
        ),
      ],
    );
  }

  Widget _addAddressButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 10.0,
          left: 20.0,
          right: 20.0,
        ),
        child: PassiveButton(
          title: 'New Address',
          icon: Icon(
            Icons.add,
            color: AppTheme.color100,
          ),
          onPressed: () => Navigator.pushNamed(
            context,
            AddAddressScreen.route,
            arguments: ModalRoute.withName(ManageAddressesScreen.route),
          ),
        ),
      ),
    );
  }

  void _deleteAddress(String addressId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Address',
          style: AppTheme.textStyle.w500.color100,
        ),
        content: Text(
          'Are you sure you want to delete this address?',
          style: AppTheme.textStyle.w400.color100,
        ),
        actions: [
          FlatButton(
            child: Text(
              'Don\'t Delete',
              style: AppTheme.textStyle.w600.color50,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              'Confirm',
              style: AppTheme.textStyle.w600.colored(AppTheme.errorColor),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              setState(() => _isLoading = true);
              try {
                await AddressUtil.deleteAddress(context, addressId);
              } catch (error) {
                Toast(message: Http.message(error)).show(context);
              } finally {
                setState(() => _isLoading = false);
              }
            },
          ),
        ],
      ),
    );
  }
}
