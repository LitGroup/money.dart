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
import 'currency.dart';
import 'money_format.dart';

/// A value-type representing some money.
///
/// **NOTE: This is a value type, do not extend or re-implement it.**
///
/// Current implementation uses [BigInt] internally to represent an amount
/// in subunits.
@sealed
@immutable
class Money implements Comparable<Money> {
  final _Subunits _subunits;
  final Currency _currency;

  /* Instantiation ************************************************************/

  /// Creates an instance of [Money] with [amount] in the minimal subunits
  /// of [currency].
  factory Money.withSubunits(BigInt amount, Currency currency) {
    if (amount == null) {
      throw ArgumentError.notNull('amount');
    }
    if (currency == null) {
      throw ArgumentError.notNull('currency');
    }

    return Money._with(_Subunits.from(amount), currency);
  }

  /* Internal constructor *****************************************************/

  Money._with(this._subunits, this._currency);

  /* Encoding/Decoding ********************************************************/

  /// Returns a [Money] instance decoded from [value] by [decoder].
  ///
  /// Throws [FormatException] in case of invalid format of value.
  static Money decoding<S>(S value, MoneyDecoder<S> decoder) {
    final data = decoder.decode(value);

    return Money.withSubunits(data.subunits, data.currency);
  }

  /// Returns this money representation encoded by [encoder].
  T encodedBy<T>(MoneyEncoder<T> encoder) {
    return encoder.encode(MoneyData.from(_subunits.toBigInt(), _currency));
  }

  /* Amount predicates ********************************************************/

  /// Returns `true` when amount of this money is zero.
  bool get isZero => _subunits.isZero;

  /// Returns `true` when amount of this money is negative.
  bool get isNegative => _subunits.isNegative;

  /// Returns `true` when amount of this money is positive (greater than zero).
  ///
  /// **TIP:** If you need to check that this value is zero or greater,
  /// use expression `!money.isNegative` instead.
  bool get isPositive => _subunits.isPositive;

  /* Hash Code ****************************************************************/

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + _subunits.hashCode;
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

    return _subunits.compareTo(other._subunits);
  }

  /// Returns `true` if [other] is the same amount of money in the same currency.
  @override
  bool operator ==(other) =>
      other is Money &&
      isInSameCurrencyAs(other) &&
      other._subunits == _subunits;

  /// Returns `true` when this money is less than [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator <(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return _subunits < other._subunits;
  }

  /// Returns `true` when this money is less than or equal to [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator <=(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return _subunits <= other._subunits;
  }

  /// Returns `true` when this money is greater than [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator >(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return _subunits > other._subunits;
  }

  /// Returns `true` when this money is greater than or equal to [other].
  ///
  /// Both operands have to be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  bool operator >=(Money other) {
    _preconditionThatCurrencyTheSameFor(
        other, () => 'Cannot compare money in different currencies.');

    return _subunits >= other._subunits;
  }

  /* Allocation ***************************************************************/

  /// Returns allocation of this money according to `ratios`.
  ///
  /// A value of the parameter [ratios] must be a non-empty list, with
  /// not negative values and sum of these values must be greater than zero.
  List<Money> allocationAccordingTo(List<int> ratios) =>
      _subunits.allocationAccordingTo(ratios).map(_withAmount).toList();

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

    return _withAmount(_subunits + summand._subunits);
  }

  Money operator -() => _withAmount(-_subunits);

  /// Subtracts right operand from the left one.
  ///
  /// Both operands must be in same currency, [ArgumentError] will be thrown
  /// otherwise.
  Money operator -(Money subtrahend) {
    _preconditionThatCurrencyTheSameFor(subtrahend);

    return _withAmount(_subunits - subtrahend._subunits);
  }

  /// Returns [Money] multiplied by [multiplier], using schoolbook rounding.
  Money operator *(num multiplier) {
    return _withAmount(_subunits * multiplier);
  }

  /// Returns [Money] divided by [divisor], using schoolbook rounding.
  Money operator /(num divisor) {
    return _withAmount(_subunits / divisor);
  }

  /* ************************************************************************ */

  /// Creates new instance with the same currency and given [amount].
  Money _withAmount(_Subunits amount) => Money._with(amount, _currency);

  void _preconditionThatCurrencyTheSameFor(Money other, [String message()]) {
    String defaultMessage() =>
        'Cannot operate with money values in different currencies.';

    if (!isInSameCurrencyAs(other)) {
      throw ArgumentError((message ?? defaultMessage)());
    }
  }
}

class _Subunits implements Comparable<_Subunits> {
  final BigInt _value;

  _Subunits.from(BigInt value) : _value = value {
    assert(value != null);
  }

  bool get isZero => _value == BigInt.zero;

  bool get isNegative => _value < BigInt.zero;

  bool get isPositive => _value > BigInt.zero;

  int compareTo(_Subunits other) => _value.compareTo(other._value);

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(other) => other is _Subunits && _value == other._value;

  bool operator <(_Subunits other) => _value < other._value;

  bool operator <=(_Subunits other) => _value <= other._value;

  bool operator >(_Subunits other) => _value > other._value;

  bool operator >=(_Subunits other) => _value >= other._value;

  /* Allocation ***************************************************************/

  List<_Subunits> allocationAccordingTo(List<int> ratios) {
    if (ratios.isEmpty) {
      throw ArgumentError.value(ratios, 'ratios',
          'List of ratios must not be empty, cannot allocate to nothing.');
    }

    return _doAllocationAccordingTo(ratios.map((ratio) {
      if (ratio < 0) {
        throw ArgumentError.value(
            ratios, 'ratios', 'Ratio must not be negative.');
      }

      return BigInt.from(ratio);
    }).toList());
  }

  List<_Subunits> _doAllocationAccordingTo(List<BigInt> ratios) {
    final totalVolume = ratios.reduce((a, b) => a + b);

    if (totalVolume == BigInt.zero) {
      throw ArgumentError(
          'Sum of ratios must be greater than zero, cannot allocate to nothing.');
    }

    final absoluteValue = _value.abs();
    var remainder = absoluteValue;

    var shares = ratios.map((ratio) {
      final share = absoluteValue * ratio ~/ totalVolume;
      remainder -= share;

      return share;
    }).toList();

    for (var i = 0; remainder > BigInt.zero && i < shares.length; ++i) {
      if (ratios[i] > BigInt.zero) {
        shares[i] += BigInt.one;
        remainder -= BigInt.one;
      }
    }

    return shares
        .map((share) => _Subunits.from(_value.isNegative ? -share : share))
        .toList();
  }

  /* Arithmetic ***************************************************************/

  _Subunits operator +(_Subunits summand) =>
      _Subunits.from(_value + summand._value);

  _Subunits operator -() => _Subunits.from(-_value);

  _Subunits operator -(_Subunits subtrahend) =>
      _Subunits.from(_value - subtrahend._value);

  _Subunits operator *(num multiplier) {
    if (multiplier is int) {
      return _Subunits.from(_value * BigInt.from(multiplier));
    }

    if (multiplier is double) {
      const floatingDecimalFactor = 1e14;
      final decimalFactor = BigInt.from(100000000000000); // 1e14
      final roundingFactor = BigInt.from(50000000000000); // 5 * 1e14

      final product = _value *
          BigInt.from((multiplier.abs() * floatingDecimalFactor).round());

      var result = product ~/ decimalFactor;
      if (product.remainder(decimalFactor) >= roundingFactor) {
        result += BigInt.one;
      }
      if (multiplier.isNegative) {
        result *= -BigInt.one;
      }

      return _Subunits.from(result);
    }

    throw UnsupportedError(
        'Unsupported type of multiplier: "${multiplier.runtimeType}", '
        '(int or double are expected)');
  }

  _Subunits operator /(num divisor) {
    return this * (1.0 / divisor.toDouble());
  }

  /* Type Conversion **********************************************************/

  BigInt toBigInt() => _value;
}
