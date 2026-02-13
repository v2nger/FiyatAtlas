import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'FiyatAtlas'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get homeTitle;

  /// No description provided for @searchTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get searchTitle;

  /// No description provided for @addTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get addTitle;

  /// No description provided for @categoriesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kategoriler'**
  String get categoriesTitle;

  /// No description provided for @profileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @scanBarcode.
  ///
  /// In tr, this message translates to:
  /// **'Barkod Tara'**
  String get scanBarcode;

  /// No description provided for @manualEntry.
  ///
  /// In tr, this message translates to:
  /// **'Elle Giriş Yap'**
  String get manualEntry;

  /// No description provided for @guestLogin.
  ///
  /// In tr, this message translates to:
  /// **'Misafir Girişi Yap'**
  String get guestLogin;

  /// No description provided for @login.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get login;

  /// No description provided for @register.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get register;

  /// No description provided for @emailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get passwordLabel;

  /// No description provided for @forgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi Unuttum'**
  String get forgotPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In tr, this message translates to:
  /// **'veya şununla devam et'**
  String get orContinueWith;

  /// No description provided for @googleSignIn.
  ///
  /// In tr, this message translates to:
  /// **'Google ile Giriş Yap'**
  String get googleSignIn;

  /// No description provided for @appleSignIn.
  ///
  /// In tr, this message translates to:
  /// **'Apple ile Giriş Yap'**
  String get appleSignIn;

  /// No description provided for @kvkkAgreement.
  ///
  /// In tr, this message translates to:
  /// **'KVKK Aydınlatma Metni\'ni okudum, onaylıyorum.'**
  String get kvkkAgreement;

  /// No description provided for @userAgreement.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı Sözleşmesi\'ni okudum, onaylıyorum.'**
  String get userAgreement;

  /// No description provided for @agreementsRequiredError.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için sözleşmeleri onaylamalısınız.'**
  String get agreementsRequiredError;

  /// No description provided for @lowestPrice.
  ///
  /// In tr, this message translates to:
  /// **'En Düşük'**
  String get lowestPrice;

  /// No description provided for @averagePrice.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama'**
  String get averagePrice;

  /// No description provided for @highestPrice.
  ///
  /// In tr, this message translates to:
  /// **'En Yüksek'**
  String get highestPrice;

  /// No description provided for @priceHistory.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat & Stok Geçmişi'**
  String get priceHistory;

  /// No description provided for @noWebData.
  ///
  /// In tr, this message translates to:
  /// **'Henüz veri girişi yok.'**
  String get noWebData;

  /// No description provided for @badgesCollection.
  ///
  /// In tr, this message translates to:
  /// **'Rozet Koleksiyonu'**
  String get badgesCollection;

  /// No description provided for @mapTitle.
  ///
  /// In tr, this message translates to:
  /// **'Market Haritası'**
  String get mapTitle;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @offersNear.
  ///
  /// In tr, this message translates to:
  /// **'Yakınındaki Fırsatlar'**
  String get offersNear;

  /// No description provided for @pointHistory.
  ///
  /// In tr, this message translates to:
  /// **'Puan Hareketleri'**
  String get pointHistory;

  /// No description provided for @totalPoints.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Puanın'**
  String get totalPoints;

  /// No description provided for @thisWeek.
  ///
  /// In tr, this message translates to:
  /// **'Bu Hafta'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In tr, this message translates to:
  /// **'Bu Ay'**
  String get thisMonth;

  /// No description provided for @allTime.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get allTime;

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @verificationRequired.
  ///
  /// In tr, this message translates to:
  /// **'E-posta doğrulaması gerekli.'**
  String get verificationRequired;

  /// No description provided for @checkEmail.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen e-posta kutunuzu kontrol edin.'**
  String get checkEmail;

  /// No description provided for @resendVerification.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama E-postası Gönder'**
  String get resendVerification;

  /// No description provided for @verifyButton.
  ///
  /// In tr, this message translates to:
  /// **'Doğrula'**
  String get verifyButton;

  /// No description provided for @priceEntryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat Girişi'**
  String get priceEntryTitle;

  /// No description provided for @changeLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dili Değiştir'**
  String get changeLanguage;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Sıfırlama'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordDesc.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen e-posta adresinizi girin, sıfırlama bağlantısı gönderelim.'**
  String get resetPasswordDesc;

  /// No description provided for @sendResetLink.
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get sendResetLink;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @resetLinkSent.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırlama bağlantısı gönderildi.'**
  String get resetLinkSent;
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
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
