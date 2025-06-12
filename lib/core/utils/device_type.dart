import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

enum DeviceType { isMobile, isTablet }

class DeviceInfo {
  static DeviceType getDeviceType(BuildContext context) {
    final size = context.mediaQuery.size;

    if (size.shortestSide >= 600) {
      return DeviceType.isTablet;
    } else {
      return DeviceType.isMobile;
    }
  }

  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.isTablet;
  }

  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.isMobile;
  }

  static T valueForDevice<T>(
    BuildContext context, {
    required T mobile,
    required T tablet,
  }) {
    return isTablet(context) ? tablet : mobile;
  }
}
