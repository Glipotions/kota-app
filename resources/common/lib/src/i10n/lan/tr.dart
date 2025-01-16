import 'package:common/src/i10n/default_localization.dart';

///Localization File For Turkish - TR
class TrLocalization extends AppLocalizationLabel {
  @override
  final String lanCode = 'tr';
  @override
  final String localizationTitle = 'Türkçe';
  @override
  final String defaultErrorMessage =
      'Hata oluştu. Lütfen daha sonra tekrar deneyiniz';
  @override
  final String noInternetErrorMessage =
      'Lütfen internet bağlantınızı kontrol ediniz.';
  @override
  final String unauthorizedErrorMessage =
      'Bu işlem için yetkiniz bulunmamaktadır.';
  @override
  final String serverErrorMessage =
      'Sunucu kaynaklı bi hata oluştu. Lütfen daha sonra tekrar deneyiniz';
  @override
  final String cancelBtnText = 'İptal';
  @override
  final String tryAgainBtnText = 'Tekrar Dene';

  @override
  String get timeoutErrorMessage => 'Bağlantı zaman aşımına uğradı';

  @override
  String get unknownPageRouteMessageText => 'Burada olmaman gerek :)';

  @override
  String get eMail => 'E-Mail';

  @override
  String get login => 'Giriş Yap';

  @override
  String get loginToYourAccount => 'Hesabınıza Giriş Yapın';

  @override
  String get password => 'Şifre';

  @override
  String get welcomeBack => 'Hoşgeldiniz';

  @override
  String get dashboard => 'Panel';

  @override
  String get document => 'Doküman';

  @override
  String get task => 'Görevler';

  @override
  String get transaction => 'İşlemler';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String atLeastLenghtText(int desiredLenght) =>
      'Lütfen en az $desiredLenght giriniz.';

  @override
  String get invalidCreditCardCvvText => 'Lütfen geçerli bir CVV giriniz.';

  @override
  String get invalidCreditCardDateText =>
      'Lütfen geçerli bir kart tarihi giriniz.';

  @override
  String get invalidCreditCardNumberText =>
      'Lütfen geçerli bir kart numarası giriniz.';

  @override
  String get invalidMailText => 'Lütfen geçerli bir mail giriniz.';

  @override
  String get invalidNameText => 'Lütfen geçerli bir isim giriniz.';

  @override
  String get requiredText => 'Bu alan zorunludur.';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get succesfullyLoggedIn => 'Başarıyla giriş yapıldı';

  @override
  String get succesfullyLoggedOut => 'Başarı ile çıkış yapıldı.';

  // Account Management
  @override
  String get accountSettings => 'Hesap Ayarları';
  @override
  String get language => 'Dil';
  @override
  String get selectLanguage => 'Dil Seçiniz';

  // Products Screen
  @override
  String get products => 'Ürünler';
  @override
  String get filter => 'Filtrele';
  @override
  String get clearFilters => 'Filtreleri Temizle';
  @override
  String get searchTermRequired => 'Arama terimi giriniz.';
  @override
  String get noProductsFound => 'Ürün bulunamadı';
  @override
  String get searchAndSelect => "Arama yapıp tamam'a tıklayınız...";
  @override
  String get accountInfo => 'Hesap Bilgileri';
  @override
  String get preferences => 'Tercihler';
  @override
  String get accountManagement => 'Hesap Yönetimi';

  @override
  String get username => 'Kullanıcı Adı';
  @override
  String get fullName => 'Ad Soyad';
  @override
  String get email => 'E-posta';
  @override
  String get darkMode => 'Karanlık Mod';
  @override
  String get deleteAccount => 'Hesabı Sil';
  @override
  String get deleteAccountSubtitle => 'Bu işlem geri alınamaz';
  @override
  String get deleteAccountDialogTitle => 'Hesap Silme Onayı';
  @override
  String get deleteAccountDialogMessage => 'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.';
  @override
  String get deleteAccountDescription => 'Hesabınızı silmek istediğinizden emin misiniz?';

  @override
  String get deleteAccountConfirmation => 'Hesabı Sil';

  @override
  String get deleteAccountWarning => 'Bu işlem geri alınamaz. Tüm verileriniz silinecektir.';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  // Cart Screen
  @override
  String get cart => 'Sepetim';
  @override
  String get clearCart => 'Sepeti Temizle';
  @override
  String get clearCartConfirmation => 'Sepetteki tüm ürünleri silmek istediğinizden emin misiniz?';
  @override
  String get clear => 'Temizle';
  @override
  String get totalAmount => 'Toplam Tutar:';
  @override
  String get orderNote => 'Sipariş Notu';
  @override
  String get addOrderNote => 'Siparişiniz için not ekleyin...';
  @override
  String get completeOrder => 'Siparişi Tamamla';
  @override
  String get updateOrder => 'Sipariş Güncelle';
  @override
  String get emptyCartMessage => 'Sepete ürün eklenmemiştir.\nSepete eklediğiniz bütün ürünler burada listelenecektir!';
  @override
  String get removeFromCart => 'Sepetten Kaldır';
}
