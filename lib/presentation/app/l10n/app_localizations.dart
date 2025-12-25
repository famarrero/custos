import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
  ];

  /// No description provided for @custos.
  ///
  /// In es, this message translates to:
  /// **'Custos'**
  String get custos;

  /// No description provided for @pageNotFound.
  ///
  /// In es, this message translates to:
  /// **'La página no fue encontrada'**
  String get pageNotFound;

  /// No description provided for @pageNotFoundSubtitle.
  ///
  /// In es, this message translates to:
  /// **'No pudimos encontrar la página que buscabas.'**
  String get pageNotFoundSubtitle;

  /// No description provided for @unknownErrorOccurred.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error desconocido'**
  String get unknownErrorOccurred;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @goBack.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get goBack;

  /// No description provided for @ok.
  ///
  /// In es, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @add.
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get add;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @requiredField.
  ///
  /// In es, this message translates to:
  /// **'Campo requerido'**
  String get requiredField;

  /// No description provided for @invalidField.
  ///
  /// In es, this message translates to:
  /// **'Campo inválido'**
  String get invalidField;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordsNotMatch;

  /// No description provided for @incorrectMasterKey.
  ///
  /// In es, this message translates to:
  /// **'La clave maestra es incorrecta'**
  String get incorrectMasterKey;

  /// No description provided for @masterKeyNotSet.
  ///
  /// In es, this message translates to:
  /// **'La clave maestra aún no está configurada'**
  String get masterKeyNotSet;

  /// No description provided for @masterKeyErrorSet.
  ///
  /// In es, this message translates to:
  /// **'Error configurando la clave maestra'**
  String get masterKeyErrorSet;

  /// No description provided for @sureWantPerformThisAction.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro que deseas realizar esta acción?'**
  String get sureWantPerformThisAction;

  /// No description provided for @contentNotFound.
  ///
  /// In es, this message translates to:
  /// **'Contenido no encontrado'**
  String get contentNotFound;

  /// No description provided for @navPasswords.
  ///
  /// In es, this message translates to:
  /// **'Contraseñas'**
  String get navPasswords;

  /// No description provided for @navGroups.
  ///
  /// In es, this message translates to:
  /// **'Grupos'**
  String get navGroups;

  /// No description provided for @navSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get navSettings;

  /// No description provided for @confirmLogoutTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro que deseas cerrar sesión?'**
  String get confirmLogoutTitle;

  /// No description provided for @logoutConfirmButton.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get logoutConfirmButton;

  /// No description provided for @pressAgainToExit.
  ///
  /// In es, this message translates to:
  /// **'Presione nuevamente para salir del app'**
  String get pressAgainToExit;

  /// No description provided for @passwordCopiedToClipboard.
  ///
  /// In es, this message translates to:
  /// **'Contraseña copiada al portapapeles'**
  String get passwordCopiedToClipboard;

  /// No description provided for @confirmDeletePasswordEntryTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que deseas eliminar esta entrada?'**
  String get confirmDeletePasswordEntryTitle;

  /// No description provided for @confirmDeleteGroupTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que deseas eliminar este grupo?'**
  String get confirmDeleteGroupTitle;

  /// No description provided for @allGroups.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get allGroups;

  /// No description provided for @fieldUrl.
  ///
  /// In es, this message translates to:
  /// **'URL'**
  String get fieldUrl;

  /// No description provided for @fieldUsername.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get fieldUsername;

  /// No description provided for @fieldEmail.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldPhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get fieldPhone;

  /// No description provided for @fieldPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get fieldPassword;

  /// No description provided for @fieldNote.
  ///
  /// In es, this message translates to:
  /// **'Nota'**
  String get fieldNote;

  /// No description provided for @fieldGroup.
  ///
  /// In es, this message translates to:
  /// **'Grupo'**
  String get fieldGroup;

  /// No description provided for @fieldProfileName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del perfil'**
  String get fieldProfileName;

  /// No description provided for @fieldMasterKey.
  ///
  /// In es, this message translates to:
  /// **'Clave maestra'**
  String get fieldMasterKey;

  /// No description provided for @fieldRepeatMasterKey.
  ///
  /// In es, this message translates to:
  /// **'Repetir clave maestra'**
  String get fieldRepeatMasterKey;

  /// No description provided for @loginWelcomeBackTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido de nuevo!'**
  String get loginWelcomeBackTitle;

  /// No description provided for @loginSelectProfileSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un perfil'**
  String get loginSelectProfileSubtitle;

  /// No description provided for @loginNoProfileTitle.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay perfiles'**
  String get loginNoProfileTitle;

  /// No description provided for @loginNoProfileSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Cuando crees un perfil aparecerá aquí. Pulsa en Crear perfil para agregar uno.'**
  String get loginNoProfileSubtitle;

  /// No description provided for @loginOrCreateOne.
  ///
  /// In es, this message translates to:
  /// **'O crea uno'**
  String get loginOrCreateOne;

  /// No description provided for @loginCreateProfileButton.
  ///
  /// In es, this message translates to:
  /// **'Crear perfil'**
  String get loginCreateProfileButton;

  /// No description provided for @loginInProfileTitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión en perfil'**
  String get loginInProfileTitle;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Ingresar'**
  String get loginButton;

  /// No description provided for @registerCreateProfileTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear un nuevo perfil'**
  String get registerCreateProfileTitle;

  /// No description provided for @registerCreateProfileSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el nombre del perfil y la clave maestra para crear un nuevo perfil.'**
  String get registerCreateProfileSubtitle;

  /// No description provided for @registerCreateProfileButton.
  ///
  /// In es, this message translates to:
  /// **'Crear perfil'**
  String get registerCreateProfileButton;

  /// No description provided for @registerWarningComplexMasterKey.
  ///
  /// In es, this message translates to:
  /// **'Por seguridad, usa una clave maestra compleja. Se recomienda al menos 8 caracteres, incluyendo mayúsculas, minúsculas, números y caracteres especiales.'**
  String get registerWarningComplexMasterKey;

  /// No description provided for @registerWarningForgetMasterKey.
  ///
  /// In es, this message translates to:
  /// **'Si olvidas la clave maestra, no podrás recuperar tus datos.'**
  String get registerWarningForgetMasterKey;

  /// No description provided for @settingsThemeModeTitle.
  ///
  /// In es, this message translates to:
  /// **'Modo de tema'**
  String get settingsThemeModeTitle;

  /// No description provided for @settingsThemeModeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Elige entre modo claro y oscuro.'**
  String get settingsThemeModeSubtitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Selecciona tu idioma preferido.'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsChangeLanguageTitle.
  ///
  /// In es, this message translates to:
  /// **'Cambiar idioma'**
  String get settingsChangeLanguageTitle;

  /// No description provided for @settingsPrivacyPolicyTitle.
  ///
  /// In es, this message translates to:
  /// **'Política de privacidad'**
  String get settingsPrivacyPolicyTitle;

  /// No description provided for @settingsPrivacyPolicySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Revisa la política de privacidad de la app.'**
  String get settingsPrivacyPolicySubtitle;

  /// No description provided for @settingsRemoveProfileTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar perfil'**
  String get settingsRemoveProfileTitle;

  /// No description provided for @settingsRemoveProfileSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar el perfil actual.'**
  String get settingsRemoveProfileSubtitle;

  /// No description provided for @settingsRemoveProfileConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro que deseas eliminar este perfil? Esta acción no se puede deshacer.'**
  String get settingsRemoveProfileConfirmTitle;

  /// No description provided for @settingsRemoveProfileConfirmCheckbox.
  ///
  /// In es, this message translates to:
  /// **'¡Estoy seguro!'**
  String get settingsRemoveProfileConfirmCheckbox;

  /// No description provided for @settingsAboutUsTitle.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get settingsAboutUsTitle;

  /// No description provided for @groupsAddGroupTitle.
  ///
  /// In es, this message translates to:
  /// **'Agregar grupo'**
  String get groupsAddGroupTitle;

  /// No description provided for @groupsEditGroupTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar grupo'**
  String get groupsEditGroupTitle;

  /// No description provided for @groupsNoGroupsTitle.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron grupos'**
  String get groupsNoGroupsTitle;

  /// No description provided for @groupsNoGroupsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Crea un grupo para organizar tus cuentas y recursos.'**
  String get groupsNoGroupsSubtitle;

  /// No description provided for @upsertGroupNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del grupo'**
  String get upsertGroupNameLabel;

  /// No description provided for @upsertGroupSelectIconLabel.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un ícono para el grupo'**
  String get upsertGroupSelectIconLabel;

  /// No description provided for @upsertGroupSelectColorLabel.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un color para el grupo'**
  String get upsertGroupSelectColorLabel;

  /// No description provided for @passwordsSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get passwordsSearchHint;

  /// No description provided for @passwordsNoPasswordsTitle.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron contraseñas'**
  String get passwordsNoPasswordsTitle;

  /// No description provided for @passwordsNoPasswordsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Crea una entrada de contraseña para administrar tus cuentas.'**
  String get passwordsNoPasswordsSubtitle;

  /// No description provided for @passwordsAccountsTitle.
  ///
  /// In es, this message translates to:
  /// **'Cuentas'**
  String get passwordsAccountsTitle;

  /// No description provided for @passwordsNoResultsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'No hay resultados para estos filtros'**
  String get passwordsNoResultsSubtitle;

  /// No description provided for @passwordsCleanFilters.
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtros'**
  String get passwordsCleanFilters;

  /// No description provided for @upsertPasswordAddAccountTitle.
  ///
  /// In es, this message translates to:
  /// **'Agregar cuenta'**
  String get upsertPasswordAddAccountTitle;

  /// No description provided for @upsertPasswordEditAccountTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar cuenta'**
  String get upsertPasswordEditAccountTitle;

  /// No description provided for @upsertPasswordWebOrAppNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la web o app'**
  String get upsertPasswordWebOrAppNameLabel;

  /// No description provided for @upsertPasswordGeneratePasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Generar contraseña'**
  String get upsertPasswordGeneratePasswordTitle;

  /// No description provided for @iconPickerTitle.
  ///
  /// In es, this message translates to:
  /// **'Elige un ícono'**
  String get iconPickerTitle;

  /// No description provided for @colorPickerTitle.
  ///
  /// In es, this message translates to:
  /// **'Elige un color'**
  String get colorPickerTitle;

  /// No description provided for @iconLabelHome.
  ///
  /// In es, this message translates to:
  /// **'Hogar'**
  String get iconLabelHome;

  /// No description provided for @iconLabelSecurity.
  ///
  /// In es, this message translates to:
  /// **'Seguridad'**
  String get iconLabelSecurity;

  /// No description provided for @iconLabelCrypto.
  ///
  /// In es, this message translates to:
  /// **'Criptomonedas'**
  String get iconLabelCrypto;

  /// No description provided for @iconLabelFinance.
  ///
  /// In es, this message translates to:
  /// **'Finanzas'**
  String get iconLabelFinance;

  /// No description provided for @iconLabelCards.
  ///
  /// In es, this message translates to:
  /// **'Tarjetas'**
  String get iconLabelCards;

  /// No description provided for @iconLabelPersonal.
  ///
  /// In es, this message translates to:
  /// **'Personal'**
  String get iconLabelPersonal;

  /// No description provided for @iconLabelUsers.
  ///
  /// In es, this message translates to:
  /// **'Usuarios'**
  String get iconLabelUsers;

  /// No description provided for @iconLabelIdentity.
  ///
  /// In es, this message translates to:
  /// **'Identidad'**
  String get iconLabelIdentity;

  /// No description provided for @iconLabelBusiness.
  ///
  /// In es, this message translates to:
  /// **'Empresarial'**
  String get iconLabelBusiness;

  /// No description provided for @iconLabelTravel.
  ///
  /// In es, this message translates to:
  /// **'Viajes'**
  String get iconLabelTravel;

  /// No description provided for @iconLabelSocial.
  ///
  /// In es, this message translates to:
  /// **'Redes sociales'**
  String get iconLabelSocial;

  /// No description provided for @iconLabelWebsites.
  ///
  /// In es, this message translates to:
  /// **'Sitios webs'**
  String get iconLabelWebsites;

  /// No description provided for @iconLabelEmail.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get iconLabelEmail;

  /// No description provided for @iconLabelMessaging.
  ///
  /// In es, this message translates to:
  /// **'Mensajería'**
  String get iconLabelMessaging;

  /// No description provided for @iconLabelShopping.
  ///
  /// In es, this message translates to:
  /// **'Compras'**
  String get iconLabelShopping;

  /// No description provided for @iconLabelGaming.
  ///
  /// In es, this message translates to:
  /// **'Juegos'**
  String get iconLabelGaming;

  /// No description provided for @iconLabelMobile.
  ///
  /// In es, this message translates to:
  /// **'Móvil'**
  String get iconLabelMobile;

  /// No description provided for @iconLabelWifi.
  ///
  /// In es, this message translates to:
  /// **'Wi-Fi'**
  String get iconLabelWifi;

  /// No description provided for @iconLabelBackup.
  ///
  /// In es, this message translates to:
  /// **'Respaldo'**
  String get iconLabelBackup;

  /// No description provided for @iconLabelCloud.
  ///
  /// In es, this message translates to:
  /// **'Nube'**
  String get iconLabelCloud;

  /// No description provided for @iconLabelProtection.
  ///
  /// In es, this message translates to:
  /// **'Protección'**
  String get iconLabelProtection;

  /// No description provided for @iconLabelConfiguration.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get iconLabelConfiguration;

  /// No description provided for @iconLabelStatistics.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get iconLabelStatistics;

  /// No description provided for @iconLabelServices.
  ///
  /// In es, this message translates to:
  /// **'Servicios'**
  String get iconLabelServices;

  /// No description provided for @iconLabelDevelopment.
  ///
  /// In es, this message translates to:
  /// **'Desarrollo'**
  String get iconLabelDevelopment;

  /// No description provided for @iconLabelBanking.
  ///
  /// In es, this message translates to:
  /// **'Banca'**
  String get iconLabelBanking;

  /// No description provided for @iconLabelOthers.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get iconLabelOthers;

  /// No description provided for @passwordGeneratorLengthTitle.
  ///
  /// In es, this message translates to:
  /// **'Longitud de contraseña'**
  String get passwordGeneratorLengthTitle;

  /// No description provided for @passwordGeneratorCharactersLabel.
  ///
  /// In es, this message translates to:
  /// **'Caracteres'**
  String get passwordGeneratorCharactersLabel;

  /// No description provided for @passwordGeneratorIncludeTitle.
  ///
  /// In es, this message translates to:
  /// **'Incluir'**
  String get passwordGeneratorIncludeTitle;

  /// No description provided for @passwordGeneratorUppercaseTitle.
  ///
  /// In es, this message translates to:
  /// **'Mayúsculas'**
  String get passwordGeneratorUppercaseTitle;

  /// No description provided for @passwordGeneratorLowercaseTitle.
  ///
  /// In es, this message translates to:
  /// **'Minúsculas'**
  String get passwordGeneratorLowercaseTitle;

  /// No description provided for @passwordGeneratorNumbersTitle.
  ///
  /// In es, this message translates to:
  /// **'Números'**
  String get passwordGeneratorNumbersTitle;

  /// No description provided for @passwordGeneratorSymbolsTitle.
  ///
  /// In es, this message translates to:
  /// **'Símbolos'**
  String get passwordGeneratorSymbolsTitle;

  /// No description provided for @passwordGeneratorGenerateButton.
  ///
  /// In es, this message translates to:
  /// **'Generar contraseña'**
  String get passwordGeneratorGenerateButton;

  /// No description provided for @privacyPolicyLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error cargando la política de privacidad: {error}'**
  String privacyPolicyLoadError(Object error);

  /// No description provided for @appVersion.
  ///
  /// In es, this message translates to:
  /// **'Versión {version}'**
  String appVersion(Object version);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
