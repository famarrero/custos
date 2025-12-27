import 'package:flutter/material.dart';

/// Centralized icon registry for the whole app.
///
/// Use these icons instead of referencing `Icons.*` directly so that icon
/// changes can be made in a single place.
final class AppIcons {
  AppIcons._();

  // Generic/actions
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline;
  static const IconData search = Icons.search;
  static const IconData close = Icons.close;
  static const IconData copy = Icons.copy;
  static const IconData back = Icons.arrow_back_ios_new;
  static const IconData logout = Icons.logout;

  // Auth/user
  static const IconData user = Icons.person_outline;
  static const IconData userAdd = Icons.person_add_alt_1_outlined;

  // Password/security
  static const IconData key = Icons.key;
  static const IconData visibilityOn = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;
  static const IconData shield = Icons.shield_outlined;

  // App/settings
  static const IconData settings = Icons.settings_outlined;
  static const IconData info = Icons.info_outline;
  static const IconData language = Icons.language;
  static const IconData darkMode = Icons.dark_mode_outlined;
  static const IconData lightMode = Icons.light_mode_outlined;

  // Navigation/pages
  static const IconData groups = Icons.list;

  // Feedback
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData success = Icons.check_circle_outline;

  // Date/time
  static const IconData calendar = Icons.calendar_month_outlined;

  // Group icon picker (categories)
  static const IconData groupHome = Icons.home_outlined;
  static const IconData groupSecurity = key;
  static const IconData groupCrypto = Icons.currency_bitcoin_outlined;
  static const IconData groupFinance = Icons.account_balance_wallet_outlined;
  static const IconData groupCards = Icons.credit_card_outlined;
  static const IconData groupPersonal = Icons.account_circle_outlined;
  static const IconData groupUsers = Icons.groups_outlined;
  static const IconData groupIdentity = Icons.badge_outlined;
  static const IconData groupBusiness = Icons.work_outline;
  static const IconData groupTravel = Icons.flight_takeoff_outlined;
  static const IconData groupSocial = Icons.people_outline;
  static const IconData groupWebsites = Icons.public_outlined;
  static const IconData groupEmail = Icons.mail_outline;
  static const IconData groupMessaging = Icons.chat_bubble_outline;
  static const IconData groupShopping = Icons.shopping_bag_outlined;
  static const IconData groupGaming = Icons.sports_esports_outlined;
  static const IconData groupMobile = Icons.smartphone_outlined;
  static const IconData groupWifi = Icons.wifi_outlined;
  static const IconData groupBackup = Icons.cloud_upload_outlined;
  static const IconData groupCloud = Icons.cloud_outlined;
  static const IconData groupProtection = shield;
  static const IconData groupConfiguration = settings;
  static const IconData groupStatistics = Icons.bar_chart_outlined;
  static const IconData groupServices = Icons.add_box_outlined;
  static const IconData groupDevelopment = Icons.code;
  static const IconData groupBanking = Icons.account_balance_outlined;
  static const IconData groupOthers = Icons.category_outlined;

  // UI helpers
  static const IconData dropdown = Icons.keyboard_arrow_down_rounded;
  static const IconData chevronRight = Icons.keyboard_arrow_right_outlined;

  static const IconData check = Icons.check;
}
