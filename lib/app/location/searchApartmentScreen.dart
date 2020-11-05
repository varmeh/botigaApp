import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/userProvider.dart';
import '../../models/apartmentModel.dart';
import '../../util/index.dart' show Http;
import '../../theme/index.dart';
import '../../widgets/index.dart'
    show
        BotigaAppBar,
        LoaderOverlay,
        SearchBar,
        BotigaTextFieldForm,
        FullWidthButton,
        BotigaBottomModal,
        Toast,
        HttpServiceExceptionWidget;

class SearchApartmentScreen extends StatefulWidget {
  static final String route = 'searchApartment';

  final Function onSelection;

  SearchApartmentScreen({@required this.onSelection});

  @override
  _SearchApartmentScreenState createState() => _SearchApartmentScreenState();
}

class _SearchApartmentScreenState extends State<SearchApartmentScreen> {
  final List<ApartmentModel> _apartments = [];
  String _query = '';
  String _houseNumber;
  var _bottomModal;
  bool _loadApartment = true;

  GlobalKey<FormState> _aptFormKey;
  FocusNode _aptFocusNode;

  @override
  void initState() {
    super.initState();
    _aptFormKey = GlobalKey<FormState>();
    _aptFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _aptFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Select your community'),
      body: SafeArea(
        child: Container(
          color: AppTheme.backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SearchBar(
                placeholder: 'Apartment / Area / City / Pincode',
                onSubmit: (value) {
                  setState(() {
                    _query = value;
                    _loadApartment = true;
                  });
                },
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: _searchList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<void> _searchList() {
    return FutureBuilder(
      future: getApartments(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return HttpServiceExceptionWidget(
            exception: snapshot.error,
            onTap: () {
              // Rebuild screen
              setState(() {});
            },
          );
        } else {
          return LoaderOverlay(
            isLoading: snapshot.connectionState == ConnectionState.waiting,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: ListView.builder(
                itemCount: _apartments.length + 1,
                itemBuilder: (context, index) {
                  return index < _apartments.length
                      ? _apartmentTile(index)
                      : _missingApartmentMessage();
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget _apartmentTile(int index) {
    final apartment = _apartments[index];

    return GestureDetector(
      onTap: () {
        _showApartmentInfoDialog(context, apartment);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          Text(
            apartment.name,
            style: AppTheme.textStyle.w500.color100.size(17.0).lineHeight(1.3),
          ),
          SizedBox(height: 8.0),
          Text(
            '${apartment.area}, ${apartment.city}, ${apartment.state} - ${apartment.pincode}',
            style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
          ),
          SizedBox(height: 20.0),
          Divider(
            thickness: 1.0,
            color: AppTheme.dividerColor,
          ),
        ],
      ),
    );
  }

  Widget _missingApartmentMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        Text(
          'Don’t find your apartment?',
          style: AppTheme.textStyle.w500.color100.size(13.0).lineHeight(1.5),
        ),
        SizedBox(height: 8.0),
        Text(
          'Please stay tuned, we are expanding rapidly to apartments.',
          style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
        ),
        SizedBox(height: 100.0),
      ],
    );
  }

  void _showApartmentInfoDialog(
    BuildContext context,
    ApartmentModel apartment,
  ) {
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
              focusNode: _aptFocusNode,
              labelText: 'Flat No / House No',
              onSave: (value) {
                _houseNumber = value;
              },
              validator: (value) => value.isEmpty ? 'Required' : null,
              onFieldSubmitted: (_) => _submitApartment(apartment),
            ),
          ),
          sizedBox24,
          FullWidthButton(
            title: 'Continue',
            onPressed: () => _submitApartment(apartment),
          ),
        ],
      ),
    );

    // Show bottom modal
    _bottomModal.show(context);
  }

  Future<void> getApartments() async {
    if (_loadApartment) {
      try {
        _loadApartment = false;
        final json =
            await Http.get('/api/services/apartments/search?text=$_query');
        _apartments.clear();
        json.forEach(
            (apartment) => _apartments.add(ApartmentModel.fromJson(apartment)));
      } catch (error) {
        Toast(message: Http.message(error)).show(context);
      } finally {
        setState(() => _loadApartment = false);
      }
    }
  }

  void _submitApartment(ApartmentModel apartment) async {
    FocusScope.of(context).unfocus();
    _bottomModal.animation(true);
    if (_aptFormKey.currentState.validate()) {
      _aptFormKey.currentState.save();
      try {
        await Provider.of<UserProvider>(context, listen: false).updateApartment(
          house: _houseNumber,
          apartment: apartment,
        );
        widget.onSelection();
      } catch (error) {
        Toast(message: Http.message(error)).show(context);
      } finally {
        _bottomModal.animation(false);
      }
    }
  }
}
