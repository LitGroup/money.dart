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

// import 'package:meta/meta.dart' show sealed, immutable;
import 'package:money2/src/pattern_decoder.dart';
import 'package:money2/src/pattern_encoder.dart';

import 'currency.dart';
import 'encoders.dart';
import 'minor_units.dart';
import 'money_data.dart';

/// Allows you to store, print and perform mathematically operations on money whilst maintaining precision.
///
/// **NOTE: This is a value type, do not extend or re-implement it.**
///
/// The [Money] class works with the [Currency] class to provide a simple means to define monetary values.
///
/// e.g.
///
/// ```dart
/// Currency aud = Currency.create('AUD', 2, pattern:"\$0.00");
/// Money costPrice = Money.fromInt(1000, aud);
/// costPrice.toString();
/// > $10.00
///
/// Money taxInclusive = costPrice * 1.1;
/// taxInclusive.toString();
/// > $11.00
///
/// taxInclusive.format("SCCC0.00");
/// > $AUD11.00
///
/// taxInclusive.format("SCCC0");
/// > $AUD11
/// ```
///
/// Money uses  [BigInt] internally to represent an amount in minorUnits (e.g. cents)
///

// @sealed
// @immutable
class Money implements Comparable<Money> {
  final MinorUnits _minorUnits;
  final Currency _currency;

  /* Instantiation ************************************************************/

  /// Creates an instance of [Money].
  /// [minorUnits] - the minimal minorUnits of the [currency], e.g (cents).
  ///
  /// e.g.
  /// USA dollars with 2 decimal places.
  ///
  /// final usd = Currency.withCodeAndPrecision('USD', 2);
  ///
  /// 500 cents is $5 USD.
  /// let fiveDollars = Money.fromMinorUnits(BigInt.from(500), usd);
  ///
  factory Money.fromBigInt(BigInt minorUnits, Currency currency) {
    if (minorUnits == null) {
      throw ArgumentError.notNull('minorUnits');
    }
    if (currency == null) {
      throw ArgumentError.notNull('currency');
    }

    return Money._from(MinorUnits.from(minorUnits), currency);
  }

  /// Creates an instance of [Money].
  ///
  /// [minorUnits] - the no. minorUnits of the [currency], e.g (cents).
  factory Money.fromInt(int minorUnits, Currency currency) {
    if (minorUnits == null) {
      throw ArgumentError.notNull('minorUnits');
    }
    return Money.fromBigInt(BigInt.from(minorUnits), currency);
  }

  ///
  /// Parses the passed [monetaryAmount] and returns a [Money] instance.
  ///
  /// The passed [monetaryAmount] must match the given [pattern] or
  /// if no pattern is supplied then the default pattern of the passed [currency].
  ///
  /// Throws an MoneyParseException if the [monetaryAmount] doesn't match the pattern.
  ///
  factory Money.fromString(String monetaryAmount, Currency currency,
      {String pattern}) {
    ArgumentError.checkNotNull(monetaryAmount, "monetaryValue");
    ArgumentError.checkNotNull(currency, "currency");

    if (pattern == null) pattern = currency.pattern;

    PatternDecoder decoder = PatternDecoder(currency, pattern);

    MoneyData data = decoder.decode(monetaryAmount);

    return Money.fromBigInt(data.minorUnits, currency);
  }

  ///
  /// Converts a [Money] instance into a new [Currency] using
  /// the provided [exchangeRate] which defines the target
  /// [Currency] and the exchange rate.
  /// e.g. 1 AUD = 0.68c USD
  /// Which means that for each Australian Dollar you will recieve
  /// 0.68 US cents. (AKA I'm not traveling to the USA this year).
  /// To do the above conversion:
  /// ```dart
  /// Currency aud = Currency.create("AUD", 2);
  /// Currency usd = Currency.create("USD", 2);
  /// Money invoiceAmount = Money.fromInt(1000, aud);
  /// Money auToUsExchangeRate = Money.fromInt(68, usd);
  /// Money usdAmount = invoiceAmount.exchangeTo(auToUsExchangeRate);
  /// ```
  Money exchangeTo(Money exchangeRate) {
    BigInt convertedUnits =
        (_minorUnits.toBigInt() * exchangeRate._minorUnits.toBigInt()) ~/
            BigInt.from(100);

    return Money.fromBigInt(convertedUnits, exchangeRate._currency);
  }

  /* Internal constructor *****************************************************/

  Money._from(this._minorUnits, this._currency);

  ///
  /// Provides a simple means of formating a [Money] instance as a string.
  ///
  /// [pattern] supports the following characters
  ///   * S outputs the currencies symbol e.g. $.
  ///   * C outputs part of the currency symbol e.g. USD. You can specify 1,2 or 3 C's
  ///       * C - U
  ///       * CC - US
  ///       * CCC - USD - outputs the full currency code regardless of length.
  ///   * &#35; denotes a digit.
  ///   * 0 denotes a digit and with the addition of defining leading and trailing zeros.
  ///   * , (comma) a placeholder for the grouping separtor
  ///   * . (period) a place holder fo rthe decimal separator
  ///
  /// Example:
  /// ```dart
  /// Currency aud = Currency.create('AUD', 2, pattern:"\$0.00");
  /// Money costPrice = Money.fromInt(1000, aud);
  /// costPrice.toString();
  /// > $10.00
  ///
  /// Money taxInclusive = costPrice * 1.1;
  /// taxInclusive.toString();
  /// > $11.00
  ///
  /// taxInclusive.format("SCCC0.00");
  /// > $AUD11.00
  ///
  /// taxInclusive.format("SCCC0");
  /// > $AUD11
  /// ```
  ///
  String format(String pattern) {
    return this.encodedBy(PatternEncoder(this, pattern));
  }

  String toString() {
    return this.encodedBy(PatternEncoder(this, _currency.pattern));
  }

  /* Encoding/Decoding ********************************************************/

  /// Returns a [Money] instance decoded from [value] by [decoder].
  ///
  /// Create your own [decoder]s to convert from any type to a [Money] instance.
  ///
  /// <T> - the type you are decoding from.
  ///
  /// Throws [FormatException] when the passed value contains an invalid format.
  static Money decoding<T>(T value, MoneyDecoder<T> decoder) {
    final data = decoder.decode(value);

    return Money.fromBigInt(data.minorUnits, data.currency);
  }

  /// Encodes a [Money] instance as a <T>.
  ///
  /// Create your own encoders to convert a Money instance to
  /// any other type.

  /// You can use this to format a [Money] instance as a string.
  ///
  /// <T> - the type you want to encode the [Money]
  /// Returns this money representation encoded by [encoder].
  T encodedBy<T>(MoneyEncoder<T> encoder) {
    return encoder.encode(MoneyData.from(_minorUnits.toBigInt(), _currency));
  }

  /* Amount predicates ********************************************************/

  /// Returns `true` when amount of this money is zero.
  bool get isZero => _minorUnits.isZero;

  /// Returns `true` when amount of this money is negative.
  bool get isNegative => _minorUnits.isNegative;

  /// Returns `true` when amount of this money is positive (greater than zero).
  ///
  /// **TIP:** If you need to check that this value is zero or greater,
  /// use expression `!money.isNegative` instead.
  bool get isPositive => _minorUnits.isPositive;

  /* Hash Code ****************************************************************/

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + _minorUnits.hashCode;
    result = 37 * result + _currency.hashCode;

    return result;
  }

  /* Comparison ***************************************************************/

  /// Returns `true` if this money value is in the specified [currency].
  bool isInCurrency(Currency currency) => _currency == currency;

  /// Returns `true` if this money value is in same currency as [other].
  bool isInSameCurrencyAs(Money other) => isInCurrency(other._currency);

  /// Compares this to [other].
  ///
  /// [other] has to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  int compareTo(Money other) {
    _preconditionThatCurrencyTheSameFor(other);

    return _minorUnits.compareTo(other._minorUnits);
  }

  /// Returns `true` if [other] is the same amount of money in the same currency.
  @override
  bool operator ==(dynamic other) =>
      other is Money &&
      isInSameCurrencyAs(other) &&
      other._minorUnits == _minorUnits;

  /// Returns `true` when this money is less than [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator <(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return _minorUnits < other._minorUnits;
  }

  /// Returns `true` when this money is less than or equal to [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator <=(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return _minorUnits <= other._minorUnits;
  }

  /// Returns `true` when this money is greater than [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator >(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return _minorUnits > other._minorUnits;
  }

  /// Returns `true` when this money is greater than or equal to [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator >=(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return _minorUnits >= other._minorUnits;
  }

  /* Allocation ***************************************************************/

  /// Returns allocation of this money according to `ratios`.
  ///
  /// A value of the parameter [ratios] must be a non-empty list, with
  /// not negative values and sum of these values must be greater than zero.
  List<Money> allocationAccordingTo(List<int> ratios) =>
      _minorUnits.allocationAccordingTo(ratios).map(_withAmount).toList();

  /// Returns allocation of this money to N `targets`.
  ///
  /// A value of the parameter [targets] must be greater than zero.
  List<Money> allocationTo(int targets) {
    if (targets < 1) {
      throw ArgumentError.value(targets, 'targets',
          'Number of targets must not be less than one, cannot allocate to nothing.');
    }

    return allocationAccordingTo(List<int>.filled(targets, 1));
  }

  /* Arithmetic ***************************************************************/

  /// Adds operands.
  ///
  /// Both operands must be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  Money operator +(Money summand) {
    _preconditionThatCurrencyTheSameFor(summand);

    return _withAmount(_minorUnits + summand._minorUnits);
  }

  Money operator -() => _withAmount(-_minorUnits);

  /// Subtracts right operand from the left one.
  ///
  /// Both operands must be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  Money operator -(Money subtrahend) {
    _preconditionThatCurrencyTheSameFor(subtrahend);

    return _withAmount(_minorUnits - subtrahend._minorUnits);
  }

  /// Returns [Money] multiplied by [multiplier], using schoolbook rounding.
  Money operator *(num multiplier) {
    return _withAmount(_minorUnits * multiplier);
  }

  /// Returns [Money] divided by [divisor], using schoolbook rounding.
  Money operator /(num divisor) {
    return _withAmount(_minorUnits / divisor);
  }

  /* ************************************************************************ */

  /// Creates new instance with the same currency and given [amount].
  Money _withAmount(MinorUnits amount) => Money._from(amount, _currency);

  void _preconditionThatCurrencyTheSameFor(Money other, [String message()]) {
    String defaultMessage() =>
        'Cannot operate with money values in different currencies.';

    if (!isInSameCurrencyAs(other)) {
      throw ArgumentError((message ?? defaultMessage)());
    }
  }
}

class MoneyParseException implements Exception {
  String message;

  MoneyParseException(this.message);

  factory MoneyParseException.fromValue(
      String pattern, int i, String monetaryValue, int monetaryIndex) {
    String message =
        """monetaryValue contained an unexpected character '${monetaryValue[monetaryIndex]}' at pos $monetaryIndex 
        when a match for pattern character ${pattern[i]} at pos $i was expected.""";
    return MoneyParseException(message);
  }
}
