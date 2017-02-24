// The MIT License (MIT)
//
// Copyright (c) 2016 - 2017 Roman Shamritskiy
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

part of money;

class Money implements Comparable<Money> {
  final int amount;
  final Currency currency;

  Money(this.amount, this.currency);

  /// Parses amount from string representation.
  ///
  /// [FormatException] will be thrown if string representation of amount is incorrect.
  ///
  /// Examples:
  ///     new Money.fromString('120', new Currency('USD');
  ///     new Money.fromString('120.00', new Currency('USD');
  ///     new Money.fromString('120.000', new Currency('IQD');
  ///
  factory Money.fromString(String amount, Currency currency) {
    final pattern = r'^(-?\d+)(?:\.(\d{' +
        currency.defaultFractionDigits.toString() +
        r'}))?$';
    final match = (new RegExp(pattern, multiLine: false)).firstMatch(amount);

    if (match == null) {
      throw new FormatException('String representation of amount is invalid.');
    }

    final integerPart = int.parse(match.group(1)) * currency.subUnit;
    final fractionPart =
        (match.group(2) != null) ? int.parse(match.group(2)) : 0;

    final intAmount = (integerPart > 0)
        ? (integerPart + fractionPart)
        : (integerPart - fractionPart);

    return new Money(intAmount, currency);
  }

  factory Money.fromDouble(double amount, Currency currency) {
    return new Money((amount * currency.subUnit).round(), currency);
  }

  /// String representation of the [amount].
  String get amountAsString {
    final integerPart = (amount ~/ currency.subUnit).toString();
    final fractionPart = amount.remainder(currency.subUnit).abs().toString();
    final buffer = new StringBuffer();

    buffer..write(integerPart)..write('.');

    for (var digits = fractionPart.length;
        digits < currency.defaultFractionDigits;
        digits++) {
      buffer.write('0');
    }

    buffer.write(fractionPart);

    return buffer.toString();
  }

  /// Negate operator.
  Money operator -() {
    return _newMoney(-amount);
  }

  /// Subtraction operator.
  Money operator -(Money other) {
    _assertSameCurrency(other);

    return _newMoney(amount - other.amount);
  }

  /// Addition operator.
  Money operator +(Money other) {
    _assertSameCurrency(other);

    return _newMoney(amount + other.amount);
  }

  /// Multiplication operator.
  Money operator *(num factor) {
    return _newMoney((amount * factor).round());
  }

  /// Allocate the monetary value represented by this Money object
  /// using a list of [ratios].
  List<Money> allocate(List<int> ratios) {
    var total = 0;
    for (var i = 0; i < ratios.length; i++) {
      total += ratios[i];
    }

    var remainder = amount;
    var results = new List<Money>(ratios.length);
    for (var i = 0; i < results.length; i++) {
      results[i] = _newMoney(amount * ratios[i] ~/ total);
      remainder -= results[i].amount;
    }

    for (var i = 0; i < remainder; i++) {
      results[i] = _newMoney(results[i].amount + 1);
    }

    return results;
  }

  /// Returns true if [amount] and [currency] of this object
  /// are equal to amount and currency of other.
  bool operator ==(Object other) {
    return (other is Money) &&
        (currency == other.currency) &&
        (amount == other.amount);
  }

  int get hashCode {
    var result = 66;
    result = 37 * result + amount.hashCode;
    result = 37 * result + currency.hashCode;

    return result;
  }

  /// Relational less than operator.
  bool operator <(Money other) {
    return compareTo(other) < 0;
  }

  /// Relational less than or equal operator.
  bool operator <=(Money other) {
    return compareTo(other) <= 0;
  }

  /// Relational greater than operator.
  bool operator >(Money other) {
    return compareTo(other) > 0;
  }

  /// Relational greater than or equal operator.
  bool operator >=(Money other) {
    return compareTo(other) >= 0;
  }

  int compareTo(Money other) {
    _assertSameCurrency(other);

    return amount.compareTo(other.amount);
  }

  /// Returns string representation of money.
  /// For example: "1.50 USD".
  String toString() {
    return '${amountAsString} ${currency.code}';
  }

  Money _newMoney(int amount) {
    return new Money(amount, currency);
  }

  void _assertSameCurrency(Money money) {
    if (money.currency != currency) {
      throw new ArgumentError('Money math mismatch. Currencies are different.');
    }
  }
}
