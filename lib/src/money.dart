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

import 'package:meta/meta.dart';

import 'currency.dart';
import 'money_arithmetic_error.dart';
import 'money_coding.dart';

@immutable
final class Money {
  // Construction
  // ---------------------------------------------------------------------------

  Money.withSubunits(BigInt amountInSubunits, Currency currency)
      : _amount = amountInSubunits,
        _currency = currency;

  /// The amount in subunits.
  final BigInt _amount;
  final Currency _currency;

  // Encoding & decoding
  // ---------------------------------------------------------------------------

  /// Creates self decoding the given [value] using the [decoder].
  ///
  /// Throws [MoneyFormatException] if decoding fails.
  static Money decoding<T>(T value, {required MoneyDecoder<T> decoder}) {
    final (:subunits, :currency) =
        decoder.decode(value); // throws MoneyFormatException

    return Money.withSubunits(subunits, currency);
  }

  /// Creates self decoding the given [value] using the [decoder].
  ///
  /// Returns `null` if decoding fails.
  static Money? decodingOrNull<T>(T value, {required MoneyDecoder<T> decoder}) {
    try {
      return decoding(value, decoder: decoder);
    } on MoneyFormatException {
      return null;
    }
  }

  T encodedBy<T>(MoneyEncoder<T> encoder) =>
      encoder.encode((subunits: _amount, currency: _currency));

  // Predicates
  // ---------------------------------------------------------------------------

  bool isSameCurrencyAs(Money other) => _currency == other._currency;

  bool isNotSameCurrencyAs(Money other) => !isSameCurrencyAs(other);

  // Comparison
  // ---------------------------------------------------------------------------

  @override
  int get hashCode => Object.hash(_currency, _amount);

  @override
  bool operator ==(Object other) =>
      other is Money &&
      other._currency == _currency &&
      other._amount == _amount;

  // Arithmetic
  // ---------------------------------------------------------------------------

  Money operator -() => _withSubunits(-_amount);

  Money operator -(Money other) {
    MoneyArithmeticError.checkForSubtractionOf(this, other);

    return _withSubunits(_amount - other._amount);
  }

  Money operator +(Money other) {
    MoneyArithmeticError.checkForAdditionOf(this, other);

    return _withSubunits(_amount + other._amount);
  }

  // Conversion to string
  // ---------------------------------------------------------------------------

  @override
  String toString() {
    // This is temporary implementation for debug only.
    // TODO: Implement expected production-ready conversion.

    return 'Money { subunits: $_amount, currency: ${_currency.code} }';
  }

  // Internal utility methods
  // ---------------------------------------------------------------------------

  /// Creates new money value with the given [amount] of subunits
  /// and the same currency.
  Money _withSubunits(BigInt amount) {
    return Money.withSubunits(amount, _currency);
  }
}
