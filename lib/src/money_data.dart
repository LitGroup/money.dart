/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 - 2019 LitGroup LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'package:meta/meta.dart' show sealed, immutable;
import 'currency.dart';
import 'money.dart';

/// DTO for exchange of data between an instance of [Money] and [MoneyEncoder]
/// or [MoneyDecoder].
@sealed
@immutable
class MoneyData {
  /// Amount of money in the smallest units (e.g. cent for USD).
  final BigInt minorUnits;

  /// The currency
  final Currency currency;

  /// Creates a MoneyData from [MinorUnits] and a [Currency]
  MoneyData.from(this.minorUnits, this.currency) {
    if (minorUnits == null) {
      throw ArgumentError.notNull('minorUnits');
    }
    if (currency == null) {
      throw ArgumentError.notNull('currency');
    }
  }

  /// returns the major currency value of this
  /// MoneyData (e.g. the dollar amount)
  BigInt getMajorUnits() {
    return (minorUnits ~/ currency.minorDigitsFactor);
  }

  /// returns the minor currency value of this MoneyData (e.g. the cents amount)
  BigInt getMinorUnits() {
    return (minorUnits % currency.minorDigitsFactor);
  }
}
