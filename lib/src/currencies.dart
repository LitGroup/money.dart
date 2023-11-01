// Copyright (c) 2023 LLC "LitGroup"
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is furnished
// to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import 'package:money/money.dart';

//------------------------------------------------------------------------------
// Currencies abstract class
//------------------------------------------------------------------------------

/// The interface/abstract class of the currency directory.
///
/// ## Built-in implementations
///
/// The factory method [from()] creates an instance of `Currencies` with
/// the given collection of values:
///
/// ```dart
/// final currencies = Currencies.from([
///   Currency(CurrencyCode('RUR'), precision: 2),
///   Currency(CurrencyCode('BTC'), precision: 8),
/// ]);
/// ```
///
/// The factory method [aggregating()] creates an instance that aggregates
/// the given instances of `Currencies`:
///
/// ```dart
/// final currencies = Currencies.aggregating([
///     Currencies.from([(CurrencyCode('RUR'), precision: 2)]),
///     Currencies.from([(CurrencyCode('BTC'), precision: 8)]),
/// ]);
///
/// assert(currencies.findByCoed(CurrencyCode('RUR')) != null);
/// assert(currencies.findByCoed(CurrencyCode('BTC')) != null);
/// ```
abstract class Currencies {
  /// Creates an instance of `Currencies` from the collection of currencies.
  ///
  /// Duplicates in the given collection will be ignored.
  static Currencies from(Iterable<Currency> currencies) {
    return _MapBackedCurrencies(currencies);
  }

  /// Creates an instance of `Currencies` which aggregates the provided instances.
  static Currencies aggregating<T extends Iterable<Currencies>>(T directories) {
    return _AggregatingCurrencies(directories);
  }

  /// Returns the found currency with the specified code;
  /// returns `null` if nothing is found.
  Currency? findByCode(CurrencyCode code);
}

//------------------------------------------------------------------------------
// Map backed implementation of Currencies
//------------------------------------------------------------------------------

class _MapBackedCurrencies extends Currencies {
  _MapBackedCurrencies(Iterable<Currency> currencyList)
      : _currencies = {
          for (final currency in currencyList) currency.code: currency
        };

  final Map<CurrencyCode, Currency> _currencies;

  @override
  Currency? findByCode(CurrencyCode code) => _currencies[code];
}

//------------------------------------------------------------------------------
// Aggregating implementation of Currencies
//------------------------------------------------------------------------------

class _AggregatingCurrencies extends Currencies {
  _AggregatingCurrencies(Iterable<Currencies> directories)
      : _directories = List.of(directories, growable: false);

  final List<Currencies> _directories;

  @override
  Currency? findByCode(CurrencyCode code) => _directories
      .map((directory) => directory.findByCode(code))
      .where((code) => code != null)
      .firstOrNull;
}
