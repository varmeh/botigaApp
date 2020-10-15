import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../util/index.dart' show HttpService, HttpServiceExceptionWidget;
import '../../theme/index.dart';
import '../../widgets/index.dart'
    show
        BotigaAppBar,
        Loader,
        SearchBar,
        BotigaTextFieldForm,
        FullWidthButton,
        BotigaBottomModal;

class SearchApartmentScreen extends StatefulWidget {
  static final String route = 'searchApartment';

  @override
  _SearchApartmentScreenState createState() => _SearchApartmentScreenState();
}

class _SearchApartmentScreenState extends State<SearchApartmentScreen> {
  final List _apartments = [];
  String _query = '';

  GlobalKey<FormState> _apartmentKey;
  FocusNode _focusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                placeholder: 'Apartment or Area or City',
                onSubmit: (value) {
                  setState(() {
                    _query = value;
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        } else if (snapshot.hasError) {
          return HttpServiceExceptionWidget(
            exception: snapshot.error,
            onTap: () {
              // Rebuild screen
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => SearchApartmentScreen(),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          );
        } else {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: ListView.builder(
              itemCount: _apartments.length + 1,
              itemBuilder: (context, index) {
                return index < _apartments.length
                    ? _apartmentTile(index)
                    : _missingApartmentMessage();
              },
            ),
          );
        }
      },
    );
  }

  Widget _apartmentTile(int index) {
    final _apartment = _apartments[index];

    return GestureDetector(
      onTap: () {
        _showApartmentInfoDialog(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          Text(
            _apartment,
            style: AppTheme.textStyle.w500.color100.size(17.0).lineHeight(1.3),
          ),
          SizedBox(height: 8.0),
          Text(
            'Jala Hobli, Vidhya Nagar Cross, Huttanahalli, Bengaluru, Karnataka 562157',
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

  void _showApartmentInfoDialog(BuildContext context) {
    const sizedBox24 = SizedBox(height: 24);

    BotigaBottomModal(
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
            'Adarsh Palm Retreat',
            style: AppTheme.textStyle.w500.color100.size(17.0).lineHeight(1.3),
          ),
          SizedBox(height: 8.0),
          Text(
            'Jala Hobli, Vidhya Nagar Cross, Huttanahalli, Bengaluru, Karnataka 562157',
            style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
          ),
          sizedBox24,
          BotigaTextFieldForm(
            formKey: null,
            focusNode: null,
            labelText: 'Flat No/Villa Number',
            onSave: (_) {},
          ),
          sizedBox24,
          FullWidthButton(
            title: 'Continue',
            onPressed: () {},
          ),
        ],
      ),
    ).show(context);
  }

  Future<void> getApartments() async {
    final response = await http.get(
      HttpService.url('/api/services/cities'),
    );

    final json = HttpService.parse(response);
    _apartments.clear();
    json.forEach((city) => _apartments.add(city));
  }
}
