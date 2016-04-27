// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

part of money;

abstract class Currency {
  /// The ISO 4217 currency code of this currency.
  String get code;
  /// The name that is suitable for displaying this currency.
  String get name;
  /// The ISO 4217 numeric code of this currency.
  int    get numericCode;
  /// The default number of fraction digits used with this currency.
  int    get defaultFractionDigits;
  int    get subUnit;

  factory Currency(String code) {
    if (code == null || !_currencies.containsKey(code.toUpperCase())) {
      throw new ArgumentError.value(code, 'code', 'Unknown currency code "$code".');
    }

    return _currencies[code.toUpperCase()];
  }

  /// Returns the ISO 4217 currency code of this currency.
  String toString();
}

class _Currency implements Currency {
  final String code;
  final String name;
  final int    numericCode;
  final int    defaultFractionDigits;
  final int    subUnit;

  const _Currency(
      this.code,
      this.name,
      this.numericCode,
      this.defaultFractionDigits,
      this.subUnit
  );

  String toString() => code;
}
