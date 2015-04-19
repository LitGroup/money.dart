// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

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