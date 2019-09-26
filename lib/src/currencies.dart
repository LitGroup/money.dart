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

/// Money2 does not create a default set of currencies instead you need to explicitly
/// create each currency type you want to use.
///
/// The Currency directory lets you register
///
///
/// An interface of currency directory.
class Currencies {
  static Currencies _self = Currencies._internal();

  final Map<String, Currency> _directory;

  factory Currencies() {
    _self = Currencies._internal();
    return _self;
  }

  Currencies._internal() : _directory = Map();

  void register(Currency currency) {
    _directory[currency.code] = currency;
  }

  /// Creates a directory of currencies initialized by [currencies].
  void registerList(Iterable<Currency> currencies) {
    currencies.forEach((currency) {
      _directory[currency.code] = currency;
    });
  }

  /* Protocol *****************************************************************/

  /// Returns a [Currency] if found or `null`.
  Currency find(String code) {
    return _directory[code];
  }
}
