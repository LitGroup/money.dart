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

/// An interface of currency directory.
abstract class Currencies {
  /* Factories ****************************************************************/

  /// Creates a directory of currencies initialized by [currencies].
  factory Currencies.from(Iterable<Currency> currencies) =>
      _MapBackedCurrencies(currencies);

  /// Creates a currency directory aggregating given [directories].
  factory Currencies.aggregating(Iterable<Currencies> directories) =>
      _AggregatedCurrencies(directories);

  /* Protocol *****************************************************************/

  /// Returns a [Currency] if found or `null`.
  Currency find(String code);
}

class _MapBackedCurrencies implements Currencies {
  final Map<String, Currency> _currencies;

  _MapBackedCurrencies(Iterable<Currency> currencies)
      : _currencies = Map.fromIterable(currencies,
            key: (currency) => (currency as Currency).code);

  Currency find(String code) {
    return _currencies[code];
  }
}

class _AggregatedCurrencies implements Currencies {
  final List<Currencies> _directories;

  _AggregatedCurrencies(Iterable<Currencies> directories)
      : _directories = directories.toList(growable: false);

  Currency find(String code) {
    for (final directory in _directories) {
      final currency = directory.find(code);
      if (currency != null) {
        return currency;
      }
    }

    return null;
  }
}
