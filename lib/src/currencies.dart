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

import 'package:money2/src/pattern_decoder.dart';

import 'currency.dart';
import 'money.dart';

/// A factory for registering and accessing [Currency] instances.
///
/// The [Currencies] class is a convenience class that you aren't required to use.
///
/// Money2 does not create a default set of currencies instead you need to explicitly
/// create each currency.
///
/// The [Currencies] class lets you register each [Currency] for easy reuse and access from this singleton.
///
/// You don't need to register [Currency]s, you can just create [Currency]s and use
/// them as needed.

class Currencies {
  // static Currencies _self = Currencies._internal();

  static final Map<String, Currency> _directory = {};

  /// Register a Currency
  static void register(Currency currency) {
    _directory[currency.code] = currency;
  }

  /// Register a list of currencies.
  static void registerList(Iterable<Currency> currencies) {
    currencies.forEach((currency) {
      _directory[currency.code] = currency;
    });
  }

  ///
  /// Parses a string containing a money amount including a currency code.
  /// Provided the passed currency code belongs to a [Currency]
  /// that has been registered via [Currencies.register] or
  /// [Currencies.registerList] thenthis method will return a
  /// [Money] instance of that [Currency] type.
  ///
  /// A [MoneyParseException] is thrown if the [monetaryAmount]
  /// doesn't match the [pattern].
  ///
  /// An [UnknownCurrencyException] is thrown if the [monetaryAmount]
  /// does not contain a known currency.
  ///
  static Money parse(String monetaryAmount, String pattern) {
    var codeLength = _getCodeLength(pattern);

    if (codeLength < 2) {
      throw MoneyParseException(
          'The Country Code length (e.g. CC) must be at least 2 characters long');
    }

    var code = _extractCode(monetaryAmount, codeLength);

    var currency = find(code);

    if (currency == null) {
      throw UnknownCurrencyException(code);
    }

    var decoder = PatternDecoder(currency, pattern);
    var moneyData = decoder.decode(monetaryAmount);

    return Money.fromBigInt(moneyData.minorUnits, currency);
  }

  //
  /// @deprecated - use [Currencies.parse())]
  ///
  static Money fromString(String monetaryAmount, String pattern) {
    return Currencies.parse(monetaryAmount, pattern);
  }

  /* Protocol *****************************************************************/

  /// Searches the list of registered [Currency]s.
  ///
  /// Returns the [Currency] that matches [code] or `null` if no matching [code] is found.
  static Currency find(String code) {
    return _directory[code];
  }

  /// Counts the number of 'C' in a pattern
  static int _getCodeLength(String pattern) {
    var count = 0;
    for (var i = 0; i < pattern.length; i++) {
      if (pattern[i] == 'C') count++;
    }
    return count;
  }

  static String _extractCode(String monetaryValue, int codeLength) {
    var regEx = RegExp('[A-Za-z]' * codeLength);

    var matches = regEx.allMatches(monetaryValue);
    if (matches.isEmpty) {
      throw MoneyParseException(
          'No currency code found in the pattern: $monetaryValue');
    }

    if (matches.length > 1) {
      throw MoneyParseException(
          'More than one currency code found in the pattern: $monetaryValue');
    }

    return monetaryValue.substring(matches.first.start, matches.first.end);
  }
}

class UnknownCurrencyException implements Exception {
  String code;
  UnknownCurrencyException(this.code);

  @override
  String toString() {
    return "An unknown currency '$code' was passed. Register the currency via [Currencies.register()] and try again.";
  }
}
