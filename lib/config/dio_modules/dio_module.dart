import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/core/network/device_id_manager.dart';
@module
abstract class DioModule {
  @lazySingleton
  Dio dio(DeviceIdManager deviceIdManager) {
    return Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Device-Id': deviceIdManager.deviceId,
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
    await Hive.openBox<String>(CacheConstants.deviceIdBoxName);
    return Hive;
  }

  @singleton
  Box<String> tokenBox() {
    return Hive.box<String>(CacheConstants.tokenBoxName);
  }

  @singleton
  @Named(CacheConstants.deviceIdBoxName)
  Box<String> deviceIdBox() {
    return Hive.box<String>(CacheConstants.deviceIdBoxName);
  }
}
