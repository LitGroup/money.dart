/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'common_currencies.dart';

import 'currency.dart';
import 'money.dart';
import 'pattern_decoder.dart';

/// A factory for registering, parsing and finding [Currency] instances.
///
/// Money2 registers a default set of[CommonCurrencies] with the [Currencies]
/// class. This allows you to use the [Currencies.parse] method to parse
/// a Money amount with a currency code.
///
/// You can add additional [Currency] or replace existing [Currency]s
/// by calling [Currencies.register].
///
/// You don't need to register [Currency]s, you can just create [Currency]s
/// and use them as needed.
///
/// see:
///   [Currency]
///   [CommonCurrencies]

class Currencies {
  static final Currencies _self = Currencies._internal();

  factory Currencies() => _self;

  Currencies._internal() {
    for (final currency in CommonCurrencies().asList()) {
      _directory[currency.code] = currency;
    }
  }

  /// Register a Currency.
  ///
  /// Once a Currency has been registered the
  /// [Currencies.parse] method will be able to recognize
  /// the currencey code in String and return the correct type.
  /// ```dart
  /// Currency usd = Currency.create('USD', 2);
  /// Currencies.register(usd);
  /// final usdAmount = Currencies.parse(r'$USD1500.0');
  /// ```
  /// See:
  /// [Currencies.parse]
  /// [Currencies.registerAll]
  /// [Currencies.find]
  void register(Currency currency) {
    _self._directory[currency.code] = currency;
  }

  /// Register a list of currencies.
  ///
  /// Once a Currency has been registered the
  /// [Currencies.parse] method will be able to recognize
  /// the currencey code in String and return the correct type.
  ///
  /// ```dart
  /// Currency usd = Currency.create('USD', 2);
  /// Currency aud = Currency.create('AUD', 2);
  /// Currencies.registerAll([usd, aud]);
  /// final usdAmount = Currencies.parse(r'$USD1500.0');
  /// ```
  /// See:
  /// [Currencies.parse]
  /// [Currencies.register]
  /// [Currencies.find]
  void registerList(Iterable<Currency> currencies) {
    for (final currency in currencies) {
      _self._directory[currency.code] = currency;
    }
  }

  /// Maps a currency 'code' to its associated currency.
  final Map<String, Currency> _directory = {};

  /// Parses a string containing a money amount including a currency code.
  ///
  /// Provided the passed currency code is a [CommonCurrency] or belongs to a [Currency]
  /// that has been registered via [Currencies.register] or
  /// [Currencies.registerList] then this method will return a
  /// [Money] instance of that [Currency] type.

  /// An [UnknownCurrencyException] is thrown if the [monetaryAmount]
  /// does not contain a known currency.
  ///
  /// [monetaryAmount] is the monetary value that you want parsed.
  ///
  /// The [pattern] is the pattern to use when parsing the [monetaryAmount].
  /// The [pattern] is optional and if not passed then the default pattern
  /// registered with the [Currency] will be used to parse the [monetaryAmount].
  ///
  /// If the number of minorUnits in [monetaryAmountWithCode]
  /// exceeds the [Currency]s precision then excess digits will be ignored.
  ///
  /// A [MoneyParseException] is thrown if the [monetaryAmount]
  /// doesn't match the [pattern].
  ///
  /// ```dart
  /// Currency usd = Currency.create('USD', 2);
  /// Currency aud = Currency.create('AUD', 2);
  /// Currencies.registerAll([usd, aud]);
  /// final usdAmount = Currencies.parse(r'$USD1500.0');
  /// ```
  ///
  /// See:
  /// [Currencies.register]
  /// [Currencies.registerAll]
  /// [Currencies.find]
  Money parse(String monetaryAmountWithCode, {String? pattern}) {
    Currency? currency;
    if (pattern == null) {
      /// No pattern? so find the currency based on the currency
      /// code in the [monetaryAmount].
      currency = findByCode(monetaryAmountWithCode);
    } else {
      final codeLength = _getCodeLength(pattern);

      if (codeLength < 2) {
        throw MoneyParseException(
            'The Country Code length (e.g. CC) must be at '
            'least 2 characters long');
      }

      final code = _extractCode(monetaryAmountWithCode, codeLength);

      currency = find(code);
    }

    if (currency == null) {
      throw UnknownCurrencyException(monetaryAmountWithCode);
    }

    pattern ??= currency.pattern;

    var monetaryAmount = monetaryAmountWithCode;

    if (!_containsCode(pattern)) {
      /// The default patterns often don't contain a currency
      /// code so as a conveniencce we strip the code out of the
      /// [monetaryAmount]. I hope this is a good idea :)
      monetaryAmount = _stripCode(currency, monetaryAmountWithCode);
    }

    final decoder = PatternDecoder(currency, pattern);
    final moneyData = decoder.decode(monetaryAmount);

    return Money.fromFixedWithCurrency(moneyData.amount, currency);
  }

  /* Protocol *****************************************************************/

  /// Searches the list of registered [Currency]s.
  ///
  /// Returns the [Currency] that matches [code] or `null` if
  /// no matching [code] is found.
  /// ```dart
  /// final usdAmount = Currencies.parse(r'$USD1500.0');
  /// ```
  ///
  /// See:
  /// [Currencies.register]
  /// [Currencies.registerAll]
  Currency? find(String code) {
    return _directory[code];
  }

  /// Short hand method to [find] a currency based on its code.
  /// Throw [UnknownCurrencyException] if the [code] hasn't been
  /// registered and is not a [CommonCurrency].
  /// ```dart
  /// final usd = Currencies()['USD'];
  /// ```
  Currency? operator [](String code) => find(code);

  /// Short hand method to [register] a [Currency].
  ///
  /// ```dart
  /// Currencies['USD'] = Currency.create('USD', ....);
  /// ```
  void operator []=(String code, Currency currency) => register(currency);

  /// Returns all currently registered [Currency]s
  ///
  /// ```dart
  /// final usd = Currency.create('USD', 2);
  /// final eur = Currency.create('EUR', 2);
  /// Currencies.registerList([usd, eur]);
  /// expect(Currencies.getRegistered(), [usd, eur]);
  /// expect(Currencies.getRegistered().map((c) => c.code), ['USD', 'EUR']);
  /// ```
  ///
  /// see:
  /// [Currency.register]
  /// [Currency.registerList]
  Iterable<Currency> getRegistered() {
    return _directory.values;
  }

  /// Searches for the matching registered Currency by comparing
  /// the currency codes in a monetaryAmount.
  Currency? findByCode(String monetaryAmount) {
    Currency? match;
    var longToShort = <Currency>[];

    longToShort = _directory.values.toList();
    longToShort.sort((lhs, rhs) => lhs.code.length - rhs.code.length);

    for (final currency in longToShort) {
      if (monetaryAmount.contains(currency.code)) {
        match = currency;
        break;
      }
    }
    return match;
  }

  /// tests a pattern to see if it contains a currency code.
  bool _containsCode(String pattern) {
    return pattern.contains('C');
  }

  /// Strips the currency code out of a [monetaryAmount]
  /// e.g.
  /// $USD10.00 becomes $10.00
  String _stripCode(Currency? currency, String monetaryAmountWithCode) {
    String monetaryAmount;
    if (currency != null && !_containsCode(currency.pattern)) {
      final code = _extractCode(monetaryAmountWithCode, currency.code.length);

      /// Remove the currency code
      monetaryAmount = monetaryAmountWithCode.replaceFirst(code, '');
    } else {
      monetaryAmount = monetaryAmountWithCode;
    }
    return monetaryAmount;
  }

  /// Counts the number of 'C' in a pattern
  int _getCodeLength(String pattern) {
    var count = 0;
    for (var i = 0; i < pattern.length; i++) {
      if (pattern[i] == 'C') count++;
    }
    return count;
  }

  /// Extracts the currency code from a [monetaryValue] on that
  /// assumption that it is [codeLength] long.
  String _extractCode(String monetaryValue, int codeLength) {
    final regEx = RegExp('[A-Za-z]' * codeLength);

    final matches = regEx.allMatches(monetaryValue);
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

/// Thrown if the currency is not registered.
class UnknownCurrencyException implements MoneyException {
  /// The code or monetary amount that contained the unknow currency
  String code;

  /// Thrown if the currency is not registered.
  UnknownCurrencyException(this.code);

  @override
  String toString() {
    return "An unknown currency '$code' was passed. Register the currency"
        ' via [Currencies().register()] and try again.';
  }
}

/// Thrown if an exchange is attempted with a [Money] has a [Currency] which
/// doesn't match the exchange rate.
class MismatchedCurrencyException extends MoneyException {
  /// Thrown if an exchange is attempted with a [Money] has a [Currency] which
  /// doesn't match the exchange rate.
  MismatchedCurrencyException(
      {required String expected, required String actual}) {
    message =
        "The exchange rate 'fromCurrency' of $expected is not the same as the Money's currency $actual";
  }
  late final String message;
}
