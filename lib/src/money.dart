// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of money;

class Money implements Comparable<Money> {
  final int      amount;
  final Currency currency;
  
  Money(this.amount, this.currency);
  
  Money operator -() {
      return _newMoney(-amount);
    }
  
  Money operator -(Money other) {
    _assertSameCurrency(other);

    return _newMoney(amount - other.amount);
  }
  
  Money operator +(Money other) {
     _assertSameCurrency(other);

    return _newMoney(amount + other.amount);
  }

  Money operator *(num factor) {
    return _newMoney((amount * factor).round());
  }

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

  bool operator ==(Money other) {
    return (currency == other.currency) && (amount == other.amount);
  }
    
  int get hashCode {
    return amount.hashCode;
  }
    
  int compareTo(Money other) {
    _assertSameCurrency(other);

    return amount.compareTo(other.amount);
  }
  
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