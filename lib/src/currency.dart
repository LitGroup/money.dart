// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

part of money;

/// Currency Value Object.
class Currency {
  /// The ISO 4217 currency code of this currency.
  final String code;

  /// The name that is suitable for displaying this currency.
  final String name;

  /// The ISO 4217 numeric code of this currency.
  final int numericCode;

  /// The default number of fraction digits used with this currency.
  final int defaultFractionDigits;
  final int subUnit;

  /// Constructs currency by ISO 4217 code.
  ///
  /// It throws [ArgumentError] if [code] is unregistered ISO code of currency.
  factory Currency(String code) {
    if (code == null || !_currencies.containsKey(code.toUpperCase())) {
      throw new ArgumentError.value(
          code, 'code', 'Unknown currency code "$code".');
    }

    return _currencies[code.toUpperCase()];
  }

  const Currency._private(this.code, this.name, this.numericCode,
      this.defaultFractionDigits, this.subUnit);

  /// Returns the ISO 4217 currency code of this currency.
  @override
  String toString() => code;
}