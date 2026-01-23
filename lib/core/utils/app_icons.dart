import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Centralized icon registry for the whole app.
///
/// Use these icons instead of referencing `Icons.*` directly so that icon
/// changes can be made in a single place.
final class AppIcons {
  AppIcons._();

  static const IconData add = FontAwesomeIcons.circlePlus;
  static const IconData edit = FontAwesomeIcons.penToSquare;
  static const IconData delete = FontAwesomeIcons.trashCan;
  static const IconData search = FontAwesomeIcons.magnifyingGlass;
  static const IconData close = FontAwesomeIcons.xmark;
  static const IconData copy = FontAwesomeIcons.copy;
  static const IconData back = FontAwesomeIcons.chevronLeft;
  static const IconData logout = FontAwesomeIcons.rightFromBracket;
  static const IconData debug = FontAwesomeIcons.bug;
  static const IconData user = FontAwesomeIcons.circleUser;
  static const IconData userAdd = FontAwesomeIcons.userPlus;
  static const IconData key = FontAwesomeIcons.key;
  static const IconData visibilityOn = FontAwesomeIcons.eye;
  static const IconData visibilityOff = FontAwesomeIcons.eyeSlash;
  static const IconData shield = FontAwesomeIcons.shield;
  static const IconData settings = FontAwesomeIcons.gear;
  static const IconData info = FontAwesomeIcons.circleInfo;
  static const IconData language = FontAwesomeIcons.language;
  static const IconData darkMode = FontAwesomeIcons.moon;
  static const IconData lightMode = FontAwesomeIcons.sun;
  static const IconData groups = FontAwesomeIcons.list;
  static const IconData warning = FontAwesomeIcons.triangleExclamation;
  static const IconData success = FontAwesomeIcons.circleCheck;
  static const IconData calendar = FontAwesomeIcons.calendar;
  static const IconData groupHome = FontAwesomeIcons.house;
  static const IconData groupSecurity = key;
  static const IconData groupCrypto = FontAwesomeIcons.bitcoin;
  static const IconData groupFinance = FontAwesomeIcons.wallet;
  static const IconData groupCards = FontAwesomeIcons.creditCard;
  static const IconData groupPersonal = FontAwesomeIcons.circleUser;
  static const IconData groupUsers = FontAwesomeIcons.users;
  static const IconData groupIdentity = FontAwesomeIcons.idCard;
  static const IconData groupBusiness = FontAwesomeIcons.briefcase;
  static const IconData groupTravel = FontAwesomeIcons.plane;
  static const IconData groupSocial = FontAwesomeIcons.peopleGroup;
  static const IconData groupWebsites = FontAwesomeIcons.globe;
  static const IconData groupEmail = FontAwesomeIcons.envelope;
  static const IconData groupMessaging = FontAwesomeIcons.comment;
  static const IconData groupShopping = FontAwesomeIcons.bagShopping;
  static const IconData groupGaming = FontAwesomeIcons.gamepad;
  static const IconData groupMobile = FontAwesomeIcons.mobile;
  static const IconData groupWifi = FontAwesomeIcons.wifi;
  static const IconData groupBackup = FontAwesomeIcons.cloudArrowUp;
  static const IconData groupCloud = FontAwesomeIcons.cloud;
  static const IconData groupProtection = shield;
  static const IconData groupConfiguration = settings;
  static const IconData groupStatistics = FontAwesomeIcons.chartBar;
  static const IconData groupServices = FontAwesomeIcons.box;
  static const IconData groupDevelopment = FontAwesomeIcons.code;
  static const IconData groupBanking = FontAwesomeIcons.buildingColumns;
  static const IconData groupOthers = FontAwesomeIcons.folder;
  static const IconData dropdown = FontAwesomeIcons.chevronDown;
  static const IconData chevronRight = FontAwesomeIcons.chevronRight;
  static const IconData check = FontAwesomeIcons.check;
  static const IconData import = FontAwesomeIcons.fileImport;
  static const IconData export = FontAwesomeIcons.fileExport;
  static const IconData clock = FontAwesomeIcons.clock;
  static const IconData otp = FontAwesomeIcons.shieldHalved;
  static const IconData qrCode = FontAwesomeIcons.qrcode;
  static const IconData analytics = FontAwesomeIcons.chartLine;
}
