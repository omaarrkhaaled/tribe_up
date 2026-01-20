import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:uuid/uuid.dart';

@singleton
class DeviceIdManager {
  final Box<String> deviceIdBox;

  DeviceIdManager({
    @Named(CacheConstants.deviceIdBoxName) required this.deviceIdBox,
  });

  String get deviceId {
    String? deviceId = deviceIdBox.get(CacheConstants.deviceIdKey);

    if (deviceId == null) {
      deviceId = const Uuid().v4();
      deviceIdBox.put(CacheConstants.deviceIdKey, deviceId);
    }

    return deviceId;
  }
}
