// ignore_for_file: sort_constructors_first

///Enums for Project Padding
enum ModulePadding {
  ///4
  xxxs(4),

  ///8
  xxs(8),

  ///12
  xs(12),

  ///16
  s(16),

  ///20
  m(20),

  ///24
  l(24),

  ///28
  xl(28),

  ///32
  xxl(32),

  ///36
  xxxl(36),

  ///64
  xxxxl(64);

  /// Gets the value of padding enum.
  final double value;
  const ModulePadding(this.value);
}
