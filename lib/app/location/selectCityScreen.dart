import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../util/index.dart';
import '../../widgets/index.dart';
import '../../theme/index.dart';

class SelectCityScreen extends StatelessWidget {
  static final route = 'selectCity';
  final List<String> _cities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Select City'),
      body: SafeArea(
        child: Container(
          color: AppTheme.backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: FutureBuilder(
            future: getCities(),
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
                        pageBuilder: (_, __, ___) => SelectCityScreen(),
                        transitionDuration: Duration.zero,
                      ),
                    );
                  },
                );
              } else {
                return ListView(
                  children: [
                    ..._cities.map(
                      (city) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          city,
                          style: AppTheme.textStyle.w500.color100
                              .size(17.0)
                              .lineHeight(1.3),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      color: AppTheme.dividerColor,
                      height: 32.0,
                    ),
                    Text(
                      'Don’t find your city?',
                      style: AppTheme.textStyle.w500.color100
                          .size(13.0)
                          .lineHeight(1.5),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Please stay tuned, we are expanding rapidly to other cities.',
                      style: AppTheme.textStyle.w500.color50
                          .size(13.0)
                          .lineHeight(1.5),
                    ),
                    SizedBox(height: 100.0)
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> getCities() async {
    final response = await http.get(
      HttpService.url('/api/services/cities'),
    );

    final json = HttpService.parse(response);
    json.forEach((city) => _cities.add(city));
  }
}
