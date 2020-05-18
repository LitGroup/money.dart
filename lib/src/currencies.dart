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
import 'money.dart';
import 'pattern_decoder.dart';

// TODO: consider converting to a factory.
// ignore: avoid_classes_with_only_static_members
/// A factory for registering and accessing [Currency] instances.
///
/// The [Currencies] class is a convenience class that you aren't required to
/// use.
///
/// Money2 does not register a default set of currencies instead you need to
/// explicitly create each currency or register one or more of the [Currency]s
/// from the list of [CommonCurrencies]s.
///
/// The [Currencies] class lets you register each [Currency] for easy
/// reuse and access from this singleton.
///
/// You don't need to register [Currency]s, you can just create [Currency]s
/// and use them as needed.
///
/// see:
///   [Currency]
///   [CommonCurrencies]

// TODO: consider converting to a factory.
// ignore: avoid_classes_with_only_static_members
class Currencies {
  // static Currencies _self = Currencies._internal();

  /// Maps a currency 'code' to its associated currency.
  static final Map<String, Currency> _directory = {};

  /// Register a Currency
  static void register(Currency currency) {
    _directory[currency.code] = currency;
  }

  /// Register a list of currencies.
  static void registerList(Iterable<Currency> currencies) {
    for (var currency in currencies) {
      _directory[currency.code] = currency;
    }
  }

  ///
  /// Parses a string containing a money amount including a currency code.
  ///
  /// Provided the passed currency code belongs to a [Currency]
  /// that has been registered via [Currencies.register] or
  /// [Currencies.registerList] then this method will return a
  /// [Money] instance of that [Currency] type.
  ///
  /// [monetaryAmount] is the monetary value that you want parsed.
  ///
  /// The [pattern] is the pattern to use when parsing the [monetaryAmount].
  /// The [pattern] is optional and if not passed then the default pattern
  /// registered with the [Currency] will be used to parse the [monetaryAmount].
  ///
  ///
  /// A [MoneyParseException] is thrown if the [monetaryAmount]
  /// doesn't match the [pattern].
  ///
  /// An [UnknownCurrencyException] is thrown if the [monetaryAmount]
  /// does not contain a known currency.
  ///
  static Money parse(String monetaryAmount, [String pattern]) {
    Currency currency;
    if (pattern == null) {
      /// No pattern? so find the currency based on the currency
      /// code in the [monetaryAmount].
      currency = findByCode(monetaryAmount);

      /// The default patterns often don't contain a currency
      /// code so as a conveience we strip the code out of the
      /// [monetaryAmount]. I hope this is a good idea :)
      monetaryAmount = _stripCode(currency, monetaryAmount);
    } else {
      var codeLength = _getCodeLength(pattern);

      if (codeLength < 2) {
        throw MoneyParseException(
            'The Country Code length (e.g. CC) must be at '
            'least 2 characters long');
      }

      var code = _extractCode(monetaryAmount, codeLength);

      currency = find(code);
    }

    if (currency == null) {
      throw UnknownCurrencyException(monetaryAmount);
    }

    pattern ??= currency.pattern;

    var decoder = PatternDecoder(currency, pattern);
    var moneyData = decoder.decode(monetaryAmount);

    return Money.fromBigInt(moneyData.minorUnits, currency);
  }

  /// Strips the currency code out of a [monetaryAmount]
  /// e.g.
  /// $USD10.00 becomes $10.00
  static String _stripCode(Currency currency, String monetaryAmount) {
    if (currency != null && !containsCode(currency.pattern)) {
      var code = _extractCode(monetaryAmount, currency.code.length);

      /// Remove the currency code
      monetaryAmount = monetaryAmount.replaceFirst(code, '');
    }
    return monetaryAmount;
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
  /// Returns the [Currency] that matches [code] or `null` if
  /// no matching [code] is found.
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

  /// Extracts the currency code from a [monetaryValue] on that
  /// assumption that it is [codeLength] long.
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

  /// Searches for the matching registered Currency by comparing
  /// the currency codes in a monetaryAmount.
  static Currency findByCode(String monetaryAmount) {
    Currency match;
    var longToShort = <Currency>[];

    longToShort = _directory.values.toList();
    longToShort.sort((lhs, rhs) => lhs.code.length - rhs.code.length);

    for (var currency in longToShort) {
      if (monetaryAmount.contains(currency.code)) {
        match = currency;
        break;
      }
    }
    return match;
  }

  /// tests a pattern to see if it contains a currency code.
  static bool containsCode(String pattern) {
    return pattern.contains('C');
  }
}

/// Throw if the currency is not registered.
class UnknownCurrencyException implements Exception {
  /// The code or monetary amount that contained the unknow currency
  String code;

  ///
  UnknownCurrencyException(this.code);

  @override
  String toString() {
    return "An unknown currency '$code' was passed. Register the currency"
        " via [Currencies.register()] and try again.";
  }
}
