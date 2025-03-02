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

  @override
  String get profile => 'Profil';

  @override
  String get balance => 'Bakiye';

  // Profile Screen
  @override
  String get pastOrders => 'Geçmiş Siparişler';

  @override
  String get pastOrdersDescription => 'Geçmiş siparişlerinizi görüntüleyebilirsiniz.';

  @override
  String get transactions => 'Cari Hareketler';

  @override
  String get transactionsDescription => 'Geçmiş cari hareketlerinizi görüntüleyebilirsiniz.';

  @override
  String get support => 'Destek';

  @override
  String get supportDescription => 'Destek ile iletişime geçebilirsiniz.';

  @override
  String get userAccountInfo => 'Kullanıcı Bilgilerim';

  @override
  String get userAccountInfoDescription => 'Hesap bilgilerinizi görüntüleyebilirsiniz.';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get signOutDescription => 'Çıkış yapabilirsiniz.';

  // Order History Screen
  @override
  String get orderHistory => 'Geçmiş Siparişler';

  @override
  String get noOrders => 'Geçmiş sipariş bulunmamaktadır.';

  @override
  String get subAccount => 'Alt cari';

  @override
  String get orderNumber => 'Sipariş';

  @override
  String get deleteOrder => 'Siparişi Sil';

  @override
  String get deleteOrderConfirmation => 'Bu siparişi silmek istediğinizden emin misiniz?';

  @override
  String get details => 'Detaylar';

  @override
  String get edit => 'Düzenle';

  @override
  String get downloadPdf => 'PDF İndir';

  @override
  String get waiting => 'Bekliyor';

  @override
  String get completed => 'Tamamlandı';

  @override
  String get preparing => 'Hazırlanıyor';

  @override
  String get orderDeletedSuccessfully => 'Sipariş başarıyla silindi';

  @override
  String get orderUpdatedSuccessfully => 'Sipariş başarıyla güncellendi';

  @override
  String get orderUpdateError => 'Sipariş güncellenirken hata oluştu';

  @override
  String get orderCreatedSuccessfully => 'Sipariş başarıyla oluşturuldu';

  @override
  String get orderCreateError => 'Sipariş oluşturulurken hata oluştu';

  // Transaction History Screen
  @override
  String get transactionHistory => 'Hesap Hareketleri';

  @override
  String get currentBalance => 'Güncel Bakiye';

  @override
  String get income => 'Gelir';

  @override
  String get expense => 'Gider';

  @override
  String get searchTransactions => 'Hesap hareketleri ara...';

  @override
  String get noTransactions => 'Hesap hareketleri bulunamadı.';

  // Product Detail Screen
  @override
  String get productDetail => 'Ürün Detay';

  @override
  String get productsInCart => 'Sepetteki Ürünler';

  @override
  String get piece => 'adet';

  @override
  String get removeProduct => 'Ürünü Sil';

  @override
  String get removeProductConfirm => 'Bu ürünü sepetten silmek istediğinize emin misiniz?';

  @override
  String get remove => 'Sil';

  @override
  String get colorSelection => 'Renk Seçimi';

  @override
  String get sizeSelection => 'Beden Seçimi';

  @override
  String get noProductInCart => 'Bu üründen sepetinizde bulunmamaktadır.';

  @override
  String get addToCart => 'Sepete Ekle';

  @override
  String get updateCart => 'Sepeti Güncelle';

  @override
  String get inStock => 'Stok Mevcut';

  @override
  String get outOfStock => 'Stok Mevcut Değil';

  @override
  String get selectColorAndSize => 'Lütfen Renk ve Beden Seçiniz.';

  @override
  String get enterValidQuantity => 'Lütfen geçerli bir adet giriniz.';

  @override
  String get productAddedToCart => 'Ürün Sepete Eklendi';

  // PDF Order Detail Strings
  @override
  String get orderSummary => 'Sipariş Özeti';

  @override
  String get description => 'Açıklama';

  @override
  String get quantityTotal => 'Miktar Toplamı';

  @override
  String get orderTotalPrice => 'Sipariş Toplam Fiyat';

  @override
  String get unitPrice => 'Birim Fiyat';

  @override
  String get amount => 'Tutar';

  // Cart PDF Strings
  @override
  String get cartProducts => 'Sepet Ürünleri';

  @override
  String get page => 'Sayfa';

  @override
  String get totalQuantity => 'Toplam Miktar';

  @override
  String get size => 'Beden';

  @override
  String get color => 'Renk';

  @override
  String get quantity => 'Adet';

  @override
  String get price => 'Fiyat';

  @override
  String get total => 'Toplam';

  @override
  String get productName => 'Ürün Adı';

  @override
  String get code => 'Kod';

  // Forgot Password
  @override
  String get verificationCodeSent => 'Doğrulama kodu e-posta adresinize gönderildi';
  
  @override
  String get somethingWentWrong => 'Bir şeyler yanlış gitti. Lütfen tekrar deneyin.';
  
  @override
  String get codeVerified => 'Kod başarıyla doğrulandı';
  
  @override
  String get invalidCode => 'Geçersiz doğrulama kodu';
  
  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor';
  
  @override
  String get passwordResetSuccess => 'Şifre başarıyla sıfırlandı';
  
  @override
  String get verificationCodeResent => 'Doğrulama kodu e-posta adresinize tekrar gönderildi';
  
  @override
  String get emailRequired => 'E-posta adresi gereklidir';
  
  @override
  String get forgotPassword => 'Şifremi Unuttum';
  
  @override
  String get resetPassword => 'Şifreyi Sıfırla';
  
  @override
  String get verifyCode => 'Kodu Doğrula';
  
  @override
  String get enterVerificationCode => 'E-posta adresinize gönderilen doğrulama kodunu girin';
  
  @override
  String get enterNewPassword => 'Yeni şifrenizi girin';
  
  @override
  String get confirmNewPassword => 'Yeni şifrenizi onaylayın';
  
  @override
  String get resendCode => 'Kodu Tekrar Gönder';

  // Bottom Navigation Bar
  @override
  String get home => 'Ana Sayfa';

  @override
  String get orderConfirmationTitle => 'Sipariş Onayı';

  @override
  String orderConfirmationMessage(String companyName) => '$companyName adına siparişi tamamlamak istediğinize emin misiniz?';

  @override
  String get confirm => 'Onayla';

  @override
  String get productCode => 'Kod';

  @override
  String get orderDetail => 'Sipariş Detayı';

  @override
  String get noOrderDetail => 'Sipariş Detayı bulunmamaktadır.';

  @override
  String get category => 'Kategori';

  @override
  String get all => 'Tümü';

  @override
  String get priceRange => 'Fiyat Aralığı';

  @override
  String get minPrice => 'Min. Fiyat';

  @override
  String get maxPrice => 'Max. Fiyat';

  @override
  String get applyFilter => 'Filtreyi Uygula';

  @override
  String get clearFilter => 'Filtreyi Temizle';

  @override
  String get sorting => 'Sıralama';

  @override
  String get priceAscending => 'Fiyat Artan';

  @override
  String get priceDescending => 'Fiyat Azalan';

  @override
  String get nameAscending => 'İsim A-Z';

  @override
  String get nameDescending => 'İsim Z-A';

  @override
  String get subCategories => 'Alt Kategoriler';

  @override
  String get accountNotApproved => 'Hesabınız onaylanmamıştır. Lütfen hesabınız onaylandıktan sonra tekrar deneyiniz.';

  @override
  String get loginError => 'Giriş yaparken bir hata oluştu.';

  @override
  String get warning => 'Uyarı';

  @override
  String get noDataToReport => 'Raporlanacak veri bulunamadı.';

  @override
  String get date => 'Tarih';

  @override
  String get receiptNo => 'Fiş No';

  @override
  String get receiptType => 'Fiş Türü';

  @override
  String get debit => 'Borç';

  @override
  String get credit => 'Alacak';

  @override
  String get foreignDebit => 'Döviz Borç';

  @override
  String get foreignCredit => 'Döviz Alacak';

  @override
  String get foreignBalance => 'Döviz Bakiye';

  @override
  String get current => 'Cari';

  @override
  String get period => 'Dönem';

  @override
  String get currency => 'Para Birimi';
}
