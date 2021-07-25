import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final CacheManager customCacheManager = CacheManager(
  Config(
    'customCacheKey',
    stalePeriod: Duration(days: 30),
    maxNrOfCacheObjects: 200,
  ),
);
