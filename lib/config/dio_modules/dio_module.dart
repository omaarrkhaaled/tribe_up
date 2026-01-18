import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tribe_up/core/constants/api_constants.dart';

@module
abstract class DioModule {
  @singleton
  Dio get dio {
    return Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }
}

@module
abstract class SharedPrefModule {
  @singleton
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}

@module
abstract class HiveModule {
  @preResolve
  @singleton
  Future<HiveInterface> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(CacheConstants.tokenBoxName);
    return Hive;
  }

  @singleton
  Box<String> tokenBox() {
    return Hive.box<String>(CacheConstants.tokenBoxName);
  }
}
