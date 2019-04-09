/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 - 2019 LitGroup LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'package:meta/meta.dart' show sealed, immutable;

/// Value-type representing a currency.
///
/// **NOTE: This is a value type, do not extend or re-implement it.**
@sealed
@immutable
class Currency {
  /// The code of the currency (e.g. 'USD').
  final String code;

  /// The number of decimals for the currency (zero or more).
  final int precision;

  /// Creates a currency with a given [code] and [precision].
  Currency.withCodeAndPrecision(this.code, this.precision) {
    if (code == null || code.isEmpty) {
      throw ArgumentError.value(code, 'code', 'Must be a non-empty string.');
    }
    if (precision == null || precision.isNegative) {
      throw ArgumentError.value(
          precision, 'precision', 'Must be a non-negative value.');
    }
  }

  @override
  int get hashCode => code.hashCode;

  @override
  bool operator ==(other) =>
      other is Currency && code == other.code && precision == other.precision;
}
