// ignore_for_file: sort_constructors_first

///Enums for Project Radiuses
enum ModuleRadius {
  ///5
  xxs(5),

  ///6
  xs(6),

  ///8
  s(8),

  ///10
  m(10),

  ///16
  l(16),

  ///20
  xl(20),

  ///30
  xxl(30),

  ///50
  xxxl(50);

  /// Gets the value of radius enum.
  final double value;
  const ModuleRadius(this.value);
}
