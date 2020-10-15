import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../util/index.dart' show HttpService, HttpServiceExceptionWidget;
import '../../theme/index.dart';
import '../../widgets/index.dart' show BotigaAppBar, Loader, SearchBar;

class SearchApartmentScreen extends StatefulWidget {
  static final String route = 'searchApartment';

  @override
  _SearchApartmentScreenState createState() => _SearchApartmentScreenState();
}

class _SearchApartmentScreenState extends State<SearchApartmentScreen> {
  final List _apartments = [];
  String _query = '';

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
              Expanded(
                child: FutureBuilder(
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
                              pageBuilder: (_, __, ___) =>
                                  SearchApartmentScreen(),
                              transitionDuration: Duration.zero,
                            ),
                          );
                        },
                      );
                    } else {
                      return ListView.builder(
                        itemCount: _apartments.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              _apartments[index],
                              style: AppTheme.textStyle.w500.color100
                                  .size(17.0)
                                  .lineHeight(1.3),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
