// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get custos => 'Custos';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get pageNotFoundSubtitle =>
      'We couldn\'t find the page you were looking for.';

  @override
  String get unknownErrorOccurred => 'An unknown error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get goBack => 'Go back';

  @override
  String get ok => 'OK';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get requiredField => 'Required field';

  @override
  String get invalidField => 'Invalid field';

  @override
  String get passwordsNotMatch => 'Passwords not match';

  @override
  String get incorrectMasterKey => 'Master key is incorrect';

  @override
  String get masterKeyNotSet => 'Master key not set yet';

  @override
  String get masterKeyErrorSet => 'Error creating the master key';

  @override
  String get sureWantPerformThisAction => 'Sure want perform this action?';

  @override
  String get contentNotFound => 'Content not found';

  @override
  String get navPasswords => 'Passwords';

  @override
  String get navGroups => 'Groups';

  @override
  String get navSettings => 'Settings';

  @override
  String get confirmLogoutTitle => 'Are you sure you want to sign out?';

  @override
  String get logoutConfirmButton => 'Sign out';

  @override
  String get pressAgainToExit => 'Press again to exit the app';

  @override
  String get passwordCopiedToClipboard => 'Password copied to clipboard';

  @override
  String get confirmDeletePasswordEntryTitle =>
      'Are you sure you want to delete this entry?';

  @override
  String get confirmDeleteGroupTitle =>
      'Are you sure you want to delete this group?';

  @override
  String get allGroups => 'All';

  @override
  String get fieldUrl => 'URL';

  @override
  String get fieldUsername => 'Username';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPhone => 'Phone';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldNote => 'Note';

  @override
  String get fieldGroup => 'Group';

  @override
  String get fieldProfileName => 'Profile name';

  @override
  String get fieldProfileNameHint => 'Enter your profile name';

  @override
  String get fieldMasterKey => 'Master key';

  @override
  String get fieldMasterKeyHint => 'Enter your master key';

  @override
  String get fieldRepeatMasterKey => 'Repeat master key';

  @override
  String get fieldRepeatMasterKeyHint => 'Repeat your master key';

  @override
  String get loginWelcomeBackTitle => 'Welcome back!';

  @override
  String get loginSelectProfileSubtitle => 'Select a profile';

  @override
  String get loginNoProfileTitle => 'No profile yet';

  @override
  String get loginNoProfileSubtitle =>
      'When you create a profile it will appear here. Click Create profile to add one.';

  @override
  String get loginOrCreateOne => 'Or create one';

  @override
  String get loginCreateProfileButton => 'Create profile';

  @override
  String get loginButton => 'Sign in';

  @override
  String get registerCreateProfileTitle => 'Create a new profile';

  @override
  String get registerCreateProfileSubtitle =>
      'Please enter the profile name and master key to create a new profile.';

  @override
  String get registerCreateProfileButton => 'Create profile';

  @override
  String get registerWarningComplexMasterKey =>
      'Please use a complex master key for better security. It is recommended to use at least 8 characters, including uppercase and lowercase letters, numbers, and special characters.';

  @override
  String get registerWarningForgetMasterKey =>
      'If you forget the master key, you will not be able to recover your data.';

  @override
  String get registerAcceptPrivacyPolicy => 'I accept the privacy policy';

  @override
  String get registerSeePrivacyPolicy => 'See privacy policy';

  @override
  String get settingsThemeModeTitle => 'Theme mode';

  @override
  String get settingsThemeModeSubtitle => 'Choose between light and dark mode.';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Select your preferred language.';

  @override
  String get settingsChangeLanguageTitle => 'Change language';

  @override
  String get settingsPrivacyPolicyTitle => 'Privacy policy';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Review the privacy policy of the app.';

  @override
  String get settingsRemoveProfileTitle => 'Remove profile';

  @override
  String get settingsRemoveProfileSubtitle => 'Delete the current profile.';

  @override
  String get settingsRemoveProfileConfirmTitle =>
      'Are you sure you want to delete this profile? This action cannot be undone.';

  @override
  String get settingsRemoveProfileConfirmCheckbox => 'I\'m sure!';

  @override
  String get settingsAboutUsTitle => 'About us';

  @override
  String get groupsAddGroupTitle => 'Add group';

  @override
  String get groupsEditGroupTitle => 'Edit group';

  @override
  String get groupsNoGroupsTitle => 'No groups found';

  @override
  String get groupsNoGroupsSubtitle =>
      'Create a group to manage your users and resources.';

  @override
  String get upsertGroupNameLabel => 'Group name';

  @override
  String get upsertGroupSelectIconLabel => 'Select icon for group';

  @override
  String get upsertGroupSelectColorLabel => 'Select color for group';

  @override
  String get passwordsSearchHint => 'Search';

  @override
  String get passwordsNoPasswordsTitle => 'No passwords found';

  @override
  String get passwordsNoPasswordsSubtitle =>
      'Create a password entry to manage your accounts.';

  @override
  String get passwordsNoResultsSubtitle => 'No results for these filters';

  @override
  String get passwordsCleanFilters => 'Clean filters';

  @override
  String get upsertPasswordAddAccountTitle => 'Add account';

  @override
  String get upsertPasswordEditAccountTitle => 'Edit account';

  @override
  String get upsertPasswordWebOrAppNameLabel => 'Web or app name';

  @override
  String get upsertPasswordWebOrAppNameHint => 'E.g. Gmail';

  @override
  String get upsertPasswordGeneratePasswordTitle => 'Generate password';

  @override
  String get fieldUrlHint => 'https://example.com';

  @override
  String get fieldUsernameHint => 'E.g. john_doe';

  @override
  String get fieldEmailHint => 'name@example.com';

  @override
  String get fieldPhoneHint => '+1 555 000 0000';

  @override
  String get fieldPasswordHint => '••••••••';

  @override
  String get fieldGroupHint => 'Select a group';

  @override
  String get fieldExpirationDateLabel => 'Expiration date';

  @override
  String get fieldExpirationDateHint => 'Select an expiration date';

  @override
  String get expirationDate => 'Expiration date';

  @override
  String get fieldNoteHint => 'E.g. This is my password for Gmail';

  @override
  String get iconPickerTitle => 'Pick an icon';

  @override
  String get colorPickerTitle => 'Pick a color';

  @override
  String get iconLabelHome => 'Home';

  @override
  String get iconLabelSecurity => 'Security';

  @override
  String get iconLabelCrypto => 'Crypto';

  @override
  String get iconLabelFinance => 'Finance';

  @override
  String get iconLabelCards => 'Cards';

  @override
  String get iconLabelPersonal => 'Personal';

  @override
  String get iconLabelUsers => 'Users';

  @override
  String get iconLabelIdentity => 'Identity';

  @override
  String get iconLabelBusiness => 'Business';

  @override
  String get iconLabelTravel => 'Travel';

  @override
  String get iconLabelSocial => 'Social networks';

  @override
  String get iconLabelWebsites => 'Websites';

  @override
  String get iconLabelEmail => 'Email';

  @override
  String get iconLabelMessaging => 'Messaging';

  @override
  String get iconLabelShopping => 'Shopping';

  @override
  String get iconLabelGaming => 'Gaming';

  @override
  String get iconLabelMobile => 'Mobile';

  @override
  String get iconLabelWifi => 'Wi-Fi';

  @override
  String get iconLabelBackup => 'Backup';

  @override
  String get iconLabelCloud => 'Cloud';

  @override
  String get iconLabelProtection => 'Protection';

  @override
  String get iconLabelConfiguration => 'Settings';

  @override
  String get iconLabelStatistics => 'Statistics';

  @override
  String get iconLabelServices => 'Services';

  @override
  String get iconLabelDevelopment => 'Development';

  @override
  String get iconLabelBanking => 'Banking';

  @override
  String get iconLabelOthers => 'Others';

  @override
  String get passwordGeneratorLengthTitle => 'Password length';

  @override
  String get passwordGeneratorCharactersLabel => 'Characters';

  @override
  String get passwordGeneratorIncludeTitle => 'Include';

  @override
  String get passwordGeneratorUppercaseTitle => 'Uppercase letters';

  @override
  String get passwordGeneratorLowercaseTitle => 'Lowercase letters';

  @override
  String get passwordGeneratorNumbersTitle => 'Numbers';

  @override
  String get passwordGeneratorSymbolsTitle => 'Symbols';

  @override
  String get passwordGeneratorGenerateButton => 'Generate password';

  @override
  String privacyPolicyLoadError(Object error) {
    return 'Error loading privacy policy: $error';
  }

  @override
  String appVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get biometricAuthFailed => 'Biometric authentication failed';

  @override
  String settingsProfileCreatedAt(Object date) {
    return 'Created on $date';
  }

  @override
  String get settingsExportTitle => 'Export';

  @override
  String get settingsImportTitle => 'Import';

  @override
  String get settingsExportSubtitle => 'Export your data to a .custos file';

  @override
  String get settingsImportSubtitle => 'Import your data from a .custos file';

  @override
  String get settingsExportDataTitle => 'Export your data';

  @override
  String get settingsImportDataTitle => 'Import your data';

  @override
  String get settingsBiometricDisableTitle => 'Disable fingerprint';

  @override
  String get settingsBiometricEnableTitle => 'Enable fingerprint';

  @override
  String get settingsBiometricDisableSubtitle =>
      'Disable fingerprint authentication';

  @override
  String get settingsBiometricEnableSubtitle =>
      'Configure fingerprint authentication for faster access';

  @override
  String get settingsAboutUsSubtitle => 'Application information';

  @override
  String get biometricSetupDisableTitle => 'Disable biometric authentication';

  @override
  String get biometricSetupEnableTitle => 'Configure biometric authentication';

  @override
  String get biometricSetupCheckingAvailability => 'Checking availability...';

  @override
  String biometricSetupDisableQuestion(Object profileName) {
    return 'Do you want to disable fingerprint authentication for $profileName?';
  }

  @override
  String get biometricSetupDisableSubtitle =>
      'You will need to use your master key to sign in each time.';

  @override
  String get biometricSetupEnableMasterKeyPrompt =>
      'Enter your master key to configure biometric authentication';

  @override
  String biometricSetupEnableQuestion(Object profileName) {
    return 'Do you want to configure fingerprint authentication for faster access to $profileName?';
  }

  @override
  String get biometricSetupEnableSubtitle =>
      'You can use your fingerprint to sign in instead of typing your master key each time.';

  @override
  String get biometricSetupNotAvailableTitle =>
      'Your device does not have fingerprint configured or is not compatible.';

  @override
  String get biometricSetupNotAvailableSubtitle =>
      'You can configure biometrics in your device settings and try again.';

  @override
  String get biometricSetupDisableButton => 'Disable';

  @override
  String get biometricSetupContinueButton => 'Continue';

  @override
  String get biometricSetupConfigureButton => 'Configure fingerprint';

  @override
  String get loadingDialogMessage => 'Loading, please wait...';

  @override
  String loginProfileGreeting(Object profileName) {
    return 'Hello $profileName';
  }

  @override
  String get loginProfileMasterKeyHint => 'Enter your master key';

  @override
  String get loginProfileForgotMasterKeyQuestion => 'Forgot your master key?';

  @override
  String loginProfileForgotMasterKeyMessage(Object profileName) {
    return 'We\'re sorry $profileName, there\'s nothing we can do to help you with your master key. You have lost all your data and we won\'t be able to recover it.';
  }

  @override
  String biometricSetupEnableReason(Object profileName) {
    return 'Authenticate with your fingerprint to enable quick access to $profileName';
  }

  @override
  String get biometricSetupErrorIncorrectMasterKey =>
      'The master key is incorrect';

  @override
  String biometricSetupErrorEnable(Object error) {
    return 'Error enabling biometrics: $error';
  }

  @override
  String biometricSetupErrorDisable(Object error) {
    return 'Error disabling biometrics: $error';
  }

  @override
  String biometricSetupErrorConfigure(Object error) {
    return 'Error configuring biometrics: $error';
  }

  @override
  String get deletePasswordTitle => 'Delete password';

  @override
  String passwordExpiredOn(Object date) {
    return 'Password expired on: $date';
  }

  @override
  String get deleteGroupTitle => 'Delete group';

  @override
  String get deleteGroupSubtitle =>
      'Password entries associated with this group will not be deleted but will remain without an assigned group.';

  @override
  String get logoutTitle => 'Sign out';

  @override
  String get settingsRemoveProfileWarning =>
      'If you delete the profile, you will lose all your accounts and passwords and will not be able to recover them. We recommend exporting your data in the \"Export\" section before deleting the profile.';

  @override
  String get importExportDataExportTitle => 'Export data';

  @override
  String get importExportDataImportTitle => 'Import data';

  @override
  String get importMasterKeyDialogTitle =>
      'The backup file is ready to be imported. Enter the profile master key to continue.';

  @override
  String get importMasterKeyDialogImportButton => 'Import';

  @override
  String get importMasterKeyDialogError => 'Error importing';

  @override
  String get importMasterKeyDialogSuccess => 'Data imported successfully';

  @override
  String get masterKeyValidatorExportPrompt =>
      'Enter your master key to continue with the export';

  @override
  String get masterKeyValidatorContinueButton => 'Continue';

  @override
  String get invalidOtpFormat => 'Invalid otp format';

  @override
  String invalidOtpLength(int length) {
    return 'OTP must be $length digits';
  }

  @override
  String get otpSecurityCodeAddedSuccessfully =>
      'Security code added successfully';

  @override
  String get otpNoAccountsToShow => 'No accounts to show';

  @override
  String get otpAddAccountsToGetOtpCodes => 'Add accounts to get the OTP codes';

  @override
  String get otpScanQR => 'Scan QR';

  @override
  String get otpAddManual => 'Add manual';

  @override
  String get otpAddSecurityCode => 'Add security code';

  @override
  String get otpCodeCopiedToClipboard => 'OTP code copied to clipboard';

  @override
  String get otpDeleteAccount => 'Delete account';

  @override
  String get otpDeleteAccountConfirm =>
      'Are you sure you want to delete this account?';

  @override
  String get otpDeleteAccountWarning =>
      'This action cannot be undone. You will no longer be able to access the OTP codes for this account.';

  @override
  String get otpNameLabel => 'Name';

  @override
  String get otpNameHint => ' E.g. Google, GitHub, etc...';

  @override
  String get otpSecretCodeLabel => 'Secret code';

  @override
  String get otpSecretCodeHint =>
      'E.g. ABCD EFGH IJKL MNOP QRST UVWX YZ23 4567';

  @override
  String otpNextIn(int seconds) {
    return 'Next in $seconds s';
  }
}
