import 'package:common/src/i10n/default_localization.dart';

///Localization File For English - EN
class EnLocalization extends AppLocalizationLabel {
  @override
  final String lanCode = 'en';

  @override
  final String localizationTitle = 'English';

  @override
  final String defaultErrorMessage =
      'An error occurred. Please try again later';
  @override
  final String noInternetErrorMessage =
      'Please check your internet connection.';
  @override
  final String unauthorizedErrorMessage =
      'You do not have authorization for this operation.';
  @override
  final String serverErrorMessage =
      'A server-side error occurred. Please try again later';
  @override
  final String cancelBtnText = 'Cancel';
  @override
  final String tryAgainBtnText = 'Try Again';

  @override
  String get timeoutErrorMessage => 'Connection timed out';

  @override
  String get unknownPageRouteMessageText => "You shouldn't be here :)";

  @override
  String get eMail => 'E-Mail';

  @override
  String get login => 'Log In';

  @override
  String get loginToYourAccount => 'Log in to Your Account';

  @override
  String get password => 'Password';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get document => 'Document';

  @override
  String get task => 'Tasks';

  @override
  String get transaction => 'Transactions';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get requiredText => 'This field is required';

  @override
  String atLeastLenghtText(int desiredLenght) =>
      'Please enter at least $desiredLenght char';

  @override
  String get invalidCreditCardCvvText => 'Please enter valid Credit Card CVV';

  @override
  String get invalidCreditCardDateText => 'Please enter valid Credit Card Date';

  @override
  String get invalidCreditCardNumberText =>
      'Please enter valid Credit Card Number';

  @override
  String get invalidMailText => 'Please enter valid E-mail';

  @override
  String get invalidNameText => 'Please enter valid Name';
  
  @override
  String get logout => 'Logout';
  
  @override
  String get succesfullyLoggedIn => 'Successfully logged in.';
  
  @override
  String get succesfullyLoggedOut => 'Succesfully logged out.';

  // Account Management
  @override
  String get accountSettings => 'Account Settings';
  @override
  String get language => 'Language';
  @override
  String get selectLanguage => 'Select Language';

  // Products Screen
  @override
  String get products => 'Products';
  @override
  String get filter => 'Filter';
  @override
  String get clearFilters => 'Clear Filters';
  @override
  String get searchTermRequired => 'Enter search term.';
  @override
  String get noProductsFound => 'No products found';
  @override
  String get searchAndSelect => 'Search and press enter...';
  @override
  String get accountInfo => 'Account Information';
  @override
  String get preferences => 'Preferences';
  @override
  String get accountManagement => 'Account Management';

  @override
  String get username => 'Username';
  @override
  String get fullName => 'Full Name';
  @override
  String get email => 'Email';
  @override
  String get darkMode => 'Dark Mode';
  @override
  String get deleteAccount => 'Delete Account';
  @override
  String get deleteAccountSubtitle => 'This action cannot be undone';
  @override
  String get deleteAccountDialogTitle => 'Delete Account Confirmation';
  @override
  String get deleteAccountDialogMessage => 'Are you sure you want to delete your account? This action cannot be undone.';
  @override
  String get cancel => 'Cancel';

  @override
  String get deleteAccountDescription => 'Are you sure you want to delete your account?';

  @override
  String get deleteAccountConfirmation => 'Delete Account';

  @override
  String get deleteAccountWarning => 'This action cannot be undone. All your data will be deleted.';

  @override
  String get delete => 'Delete';

  // Cart Screen
  @override
  String get cart => 'My Cart';
  @override
  String get clearCart => 'Clear Cart';
  @override
  String get clearCartConfirmation => 'Are you sure you want to remove all items from your cart?';
  @override
  String get clear => 'Clear';
  @override
  String get totalAmount => 'Total Amount:';
  @override
  String get orderNote => 'Order Note';
  @override
  String get addOrderNote => 'Add a note for your order...';
  @override
  String get completeOrder => 'Complete Order';
  @override
  String get updateOrder => 'Update Order';
  @override
  String get emptyCartMessage => 'No items in cart.\nAll items you add to cart will be listed here!';
  @override
  String get removeFromCart => 'Remove from Cart';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get updateCart => 'Update Cart';

  @override
  String get inStock => 'In Stock';

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get selectColorAndSize => 'Please select color and size.';

  @override
  String get enterValidQuantity => 'Please enter a valid quantity.';

  @override
  String get productAddedToCart => 'Product added to cart';

  // Profile Screen
  @override
  String get profile => 'Profile';

  @override
  String get balance => 'Balance';

  @override
  String get pastOrders => 'Past Orders';

  @override
  String get pastOrdersDescription => 'View your past orders.';

  @override
  String get transactions => 'Transactions';

  @override
  String get transactionsDescription => 'View your past transactions.';

  @override
  String get support => 'Support';

  @override
  String get supportDescription => 'Contact support for assistance.';

  @override
  String get userAccountInfo => 'Account Info';

  @override
  String get userAccountInfoDescription => 'View your account information.';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutDescription => 'Sign out from your account.';

  // Order History Screen
  @override
  String get orderHistory => 'Order History';

  @override
  String get noOrders => 'No past orders found.';

  @override
  String get subAccount => 'Sub Account';

  @override
  String get orderNumber => 'Order';

  @override
  String get deleteOrder => 'Delete Order';

  @override
  String get deleteOrderConfirmation => 'Are you sure you want to delete this order?';

  @override
  String get details => 'Details';

  @override
  String get edit => 'Edit';

  @override
  String get downloadPdf => 'Download PDF';

  @override
  String get waiting => 'Waiting';

  @override
  String get completed => 'Completed';

  @override
  String get preparing => 'Preparing';

  // Transaction History Screen
  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get searchTransactions => 'Search transactions...';

  @override
  String get noTransactions => 'No transactions found.';

  // Product Detail Screen
  @override
  String get productDetail => 'Product Detail';

  @override
  String get productsInCart => 'Products in Cart';

  @override
  String get piece => 'pieces';

  @override
  String get removeProduct => 'Remove Product';

  @override
  String get removeProductConfirm => 'Are you sure you want to remove this product from cart?';

  @override
  String get remove => 'Remove';

  @override
  String get colorSelection => 'Color Selection';

  @override
  String get sizeSelection => 'Size Selection';

  @override
  String get noProductInCart => 'This product is not in your cart.';

  // Bottom Navigation Bar
  @override
  String get home => 'Home';

  @override
  String get orderConfirmationTitle => 'Order Confirmation';

  @override
  String orderConfirmationMessage(String companyName) => 'Are you sure you want to complete the order for $companyName?';

  @override
  String get confirm => 'Confirm';

  @override
  String get orderDeletedSuccessfully => 'Order successfully deleted';

  @override
  String get orderUpdatedSuccessfully => 'Order successfully updated';

  @override
  String get orderUpdateError => 'Error updating order';

  @override
  String get orderCreatedSuccessfully => 'Order successfully created';

  @override
  String get orderCreateError => 'Error creating order';

  @override
  String get productName => 'Product Name';

  @override
  String get productCode => 'Code';

  @override
  String get size => 'Size';

  @override
  String get color => 'Color';

  @override
  String get quantity => 'Quantity';

  @override
  String get price => 'Price';

  @override
  String get total => 'Total';

  @override
  String get orderDetail => 'Order Detail';

  @override
  String get noOrderDetail => 'No order detail available.';

  @override
  String get category => 'Category';

  @override
  String get all => 'All';

  @override
  String get priceRange => 'Price Range';

  @override
  String get minPrice => 'Min. Price';

  @override
  String get maxPrice => 'Max. Price';

  @override
  String get applyFilter => 'Apply Filter';

  @override
  String get clearFilter => 'Clear Filter';

  @override
  String get sorting => 'Sort By';

  @override
  String get priceAscending => 'Price Low to High';

  @override
  String get priceDescending => 'Price High to Low';

  @override
  String get nameAscending => 'Name A-Z';

  @override
  String get nameDescending => 'Name Z-A';

  @override
  String get subCategories => 'Sub Categories';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get description => 'Description';

  @override
  String get quantityTotal => 'Total Quantity';

  @override
  String get orderTotalPrice => 'Order Total Price';

  @override
  String get unitPrice => 'Unit Price';

  @override
  String get amount => 'Amount';
}
