import 'package:common/src/i10n/default_localization.dart';

class ArLocalization extends AppLocalizationLabel {
  @override
  String get localizationTitle => 'العربية';

  @override
  String get lanCode => 'AR';

  @override
  String get defaultErrorMessage => 'حدث خطأ. يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get serverErrorMessage => 'حدث خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get noInternetErrorMessage => 'يرجى التحقق من اتصال الإنترنت الخاص بك';

  @override
  String get unauthorizedErrorMessage => 'ليس لديك صلاحية لهذه العملية';

  @override
  String get timeoutErrorMessage => 'انتهت مهلة الاتصال';

  @override
  String get cancelBtnText => 'إلغاء';

  @override
  String get tryAgainBtnText => 'حاول مرة أخرى';

  @override
  String get unknownPageRouteMessageText => 'لا يجب أن تكون هنا :)';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get loginToYourAccount => 'تسجيل الدخول إلى حسابك';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get eMail => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get transaction => 'المعاملات';

  @override
  String get task => 'المهام';

  @override
  String get document => 'المستند';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get unknown => 'غير معروف';

  @override
  String get requiredText => 'هذا الحقل مطلوب';

  @override
  String get invalidMailText => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get invalidNameText => 'يرجى إدخال اسم صحيح';

  @override
  String get invalidCreditCardNumberText => 'يرجى إدخال رقم بطاقة صحيح';

  @override
  String get invalidCreditCardDateText => 'يرجى إدخال تاريخ صحيح';

  @override
  String get invalidCreditCardCvvText => 'يرجى إدخال رمز CVV صحيح';

  @override
  String atLeastLenghtText(int desiredLenght) => 'يرجى إدخال $desiredLenght حرف على الأقل';

  @override
  String get succesfullyLoggedOut => 'تم تسجيل الخروج بنجاح';

  @override
  String get succesfullyLoggedIn => 'تم تسجيل الدخول بنجاح';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get language => 'اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountSubtitle => 'حذف الحساب لا يمكن التراجع عنه';

  @override
  String get deleteAccountDialogTitle => 'حذف الحساب';

  @override
  String get deleteAccountDialogMessage => 'هل أنت متأكد أنك تريد حذف حسابك؟';

  @override
  String get deleteAccountDescription => 'سيتم حذف جميع بياناتك بعد حذف الحساب';

  @override
  String get deleteAccountConfirmation => 'نعم، احذف حسابي';

  @override
  String get deleteAccountWarning => 'لا يمكن التراجع عن هذا الإجراء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get products => 'المنتجات';

  @override
  String get filter => 'تصفية';

  @override
  String get clearFilters => 'مسح التصفية';

  @override
  String get searchTermRequired => 'يرجى إدخال كلمة البحث';

  @override
  String get noProductsFound => 'لم يتم العثور على منتجات';

  @override
  String get searchAndSelect => 'البحث والاختيار';

  @override
  String get accountInfo => 'معلومات الحساب';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get accountManagement => 'إدارة الحساب';

  @override
  String get cart => 'السلة';

  @override
  String get clearCart => 'تفريغ السلة';

  @override
  String get clearCartConfirmation => 'هل أنت متأكد أنك تريد تفريغ السلة؟';

  @override
  String get clear => 'مسح';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get orderNote => 'ملاحظة الطلب';

  @override
  String get addOrderNote => 'إضافة ملاحظة للطلب';

  @override
  String get completeOrder => 'إتمام الطلب';

  @override
  String get updateOrder => 'تحديث الطلب';

  @override
  String get emptyCartMessage => 'سلة التسوق فارغة';

  @override
  String get removeFromCart => 'إزالة من السلة';

  @override
  String get addToCart => 'إضافة إلى السلة';

  @override
  String get updateCart => 'تحديث السلة';

  @override
  String get inStock => 'متوفر';

  @override
  String get outOfStock => 'غير متوفر';

  @override
  String get selectColorAndSize => 'اختر اللون والمقاس';

  @override
  String get enterValidQuantity => 'يرجى إدخال كمية صحيحة';

  @override
  String get productAddedToCart => 'تمت إضافة المنتج إلى السلة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get balance => 'الرصيد';

  @override
  String get pastOrders => 'الطلبات السابقة';

  @override
  String get pastOrdersDescription => 'عرض طلباتك السابقة';

  @override
  String get transactions => 'المعاملات';

  @override
  String get transactionsDescription => 'سجل معاملاتك';

  @override
  String get support => 'الدعم';

  @override
  String get supportDescription => 'تواصل مع الدعم';

  @override
  String get userAccountInfo => 'معلومات المستخدم';

  @override
  String get userAccountInfoDescription => 'بياناتك الشخصية';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get signOutDescription => 'الخروج من الحساب';

  @override
  String get orderHistory => 'سجل الطلبات';

  @override
  String get noOrders => 'لا توجد طلبات';

  @override
  String get subAccount => 'حساب فرعي';

  @override
  String get orderNumber => 'رقم الطلب';

  @override
  String get deleteOrder => 'حذف الطلب';

  @override
  String get deleteOrderConfirmation => 'هل أنت متأكد أنك تريد حذف هذا الطلب؟';

  @override
  String get details => 'التفاصيل';

  @override
  String get edit => 'تعديل';

  @override
  String get downloadPdf => 'تحميل PDF';

  @override
  String get waiting => 'قيد الانتظار';

  @override
  String get completed => 'مكتمل';

  @override
  String get preparing => 'قيد التحضير';

  @override
  String get transactionHistory => 'سجل المعاملات';

  @override
  String get currentBalance => 'الرصيد الحالي';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get searchTransactions => 'البحث في المعاملات';

  @override
  String get noTransactions => 'لا توجد معاملات';

  @override
  String get productDetail => 'تفاصيل المنتج';

  @override
  String get productsInCart => 'المنتجات في السلة';

  @override
  String get piece => 'قطعة';

  @override
  String get home => 'الرئيسية';

  @override
  String get colorSelection => 'اختيار اللون';

  @override
  String get noProductInCart => 'لا توجد منتجات في السلة';

  @override
  String get remove => 'إزالة';

  @override
  String get removeProduct => 'إزالة المنتج';

  @override
  String get removeProductConfirm => 'هل أنت متأكد أنك تريد إزالة هذا المنتج؟';

  @override
  String get sizeSelection => 'اختيار المقاس';

  @override
  String get orderConfirmationTitle => 'تأكيد الطلب';

  @override
  String orderConfirmationMessage(String companyName) => 'هل أنت متأكد أنك تريد إتمام الطلب لصالح $companyName؟';

  @override
  String get confirm => 'تأكيد';

  @override
  String get orderDeletedSuccessfully => 'تم حذف الطلب بنجاح';

  @override
  String get orderUpdatedSuccessfully => 'تم تحديث الطلب بنجاح';

  @override
  String get orderUpdateError => 'حدث خطأ أثناء تحديث الطلب';

  @override
  String get orderCreatedSuccessfully => 'تم إنشاء الطلب بنجاح';

  @override
  String get orderCreateError => 'حدث خطأ أثناء إنشاء الطلب';

  @override
  String get productName => 'اسم المنتج';

  @override
  String get productCode => 'الرمز';

  @override
  String get size => 'المقاس';

  @override
  String get color => 'اللون';

  @override
  String get quantity => 'الكمية';

  @override
  String get price => 'السعر';

  @override
  String get total => 'المجموع';

  @override
  String get orderDetail => 'تفاصيل الطلب';

  @override
  String get noOrderDetail => 'لا تتوفر تفاصيل للطلب.';

  @override
  String get category => 'الفئة';

  @override
  String get all => 'الكل';

  @override
  String get priceRange => 'نطاق السعر';

  @override
  String get minPrice => 'السعر الأدنى';

  @override
  String get maxPrice => 'السعر الأقصى';

  @override
  String get applyFilter => 'تطبيق التصفية';

  @override
  String get clearFilter => 'مسح التصفية';

  @override
  String get sorting => 'ترتيب حسب';

  @override
  String get priceAscending => 'السعر من الأقل إلى الأعلى';

  @override
  String get priceDescending => 'السعر من الأعلى إلى الأقل';

  @override
  String get nameAscending => 'الاسم أ-ي';

  @override
  String get nameDescending => 'الاسم ي-أ';

  @override
  String get subCategories => 'الفئات الفرعية';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get description => 'الوصف';

  @override
  String get quantityTotal => 'إجمالي الكمية';

  @override
  String get orderTotalPrice => 'السعر الإجمالي للطلب';

  @override
  String get unitPrice => 'سعر الوحدة';

  @override
  String get amount => 'المبلغ';
}
