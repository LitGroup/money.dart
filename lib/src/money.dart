// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of money;

class Money implements Comparable<Money> {
  final int      amount;
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
    final pattern = r'^(-?\d+)(?:\.(\d{' + currency.defaultFractionDigits.toString() + r'}))?$';
    final match = (new RegExp(pattern, multiLine: false)).firstMatch(amount);

    if (match == null) {
      throw new FormatException('String representation of amount is invalid.');
    }

    final integerPart = int.parse(match.group(1)) * currency.subUnit;
    final fractionPart = (match.group(2) != null)
                           ? int.parse(match.group(2))
                           : 0;

    final intAmount = (integerPart > 0)
                        ? (integerPart + fractionPart)
                        : (integerPart - fractionPart);

    return new Money(intAmount, currency);
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
  bool operator ==(Money other) {
    return (currency == other.currency) && (amount == other.amount);
  }
    
  int get hashCode {
    return amount.hashCode;
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
    return '${_amountToString()} ${currency.code}';
  }
  
  Money _newMoney(int amount) {
    return new Money(amount, currency);
  }

  String _amountToString() {
    return (amount / currency.subUnit).toStringAsFixed(currency.defaultFractionDigits);
  }
  
  void _assertSameCurrency(Money money) {
    if (money.currency != currency) {
      throw new ArgumentError('Money math mismatch. Currencies are different.');
    }
  }
}