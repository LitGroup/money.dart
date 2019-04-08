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

import 'currency.dart';

/// DTO for exchange of data between an instance of [Money] and [MoneyEncoder]
/// or [MoneyDecoder].
class MoneyData {
  /// Amount of money in the smallest units (like cent for USD).
  final BigInt subunits;

  /// The currency of the subunits.
  final Currency currency;

  MoneyData.from(this.subunits, this.currency) {
    if (subunits == null) {
      throw ArgumentError.notNull('subunits');
    }
    if (currency == null) {
      throw ArgumentError.notNull('currency');
    }
  }
}

abstract class MoneyEncoder<T> {
  /// Returns encoded representation of money data.
  T encode(MoneyData data);
}

abstract class MoneyDecoder<S> {
  /// Returns decoded [MoneyData] or throws a [FormatException].
  MoneyData decode(S encoded);
}
