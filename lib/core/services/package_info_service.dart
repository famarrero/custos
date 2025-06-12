import 'package:custos/di_container.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class PackageInfoService {
  String getAppName();

  String getAppPackageName();

  String getAppVersion();

  String getAppBuildNumber();
}

class PackageInfoServiceImpl implements PackageInfoService {
  PackageInfoServiceImpl();

  final PackageInfo _packageInfo = di();

  @override
  String getAppBuildNumber() {
    return _packageInfo.buildNumber;
  }

  @override
  String getAppName() {
    return _packageInfo.appName;
  }

  @override
  String getAppPackageName() {
    return _packageInfo.packageName;
  }

  @override
  String getAppVersion() {
    return _packageInfo.version;
  }
}
