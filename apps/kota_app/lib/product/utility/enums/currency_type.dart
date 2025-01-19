/// Currency types enum that corresponds to DovizTuru in .NET backend
enum CurrencyType {
  /// Turkish Lira (TL)
  tl(1, 'TL'),

  /// US Dollar
  dollar(2, 'Dolar'),

  /// Euro
  euro(3, 'Euro'),

  /// British Pound Sterling
  sterling(4, 'Sterlin');

  const CurrencyType(this.value, this.description);
  
  /// Numeric value of the currency type
  final int value;
  
  /// Description of the currency type in Turkish
  final String description;

  /// Get CurrencyType from integer value
  static CurrencyType? fromValue(int value) {
    return CurrencyType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => tl,
    );
  }
}
