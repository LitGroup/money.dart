// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of money;

class Money implements Comparable<Money> {
  
  final int      amount;
  final Currency currency;
  
  Money(this.amount, this.currency);
  
  Money operator +(Money other) {
    _assertSameCurrency(other);
    // TODO: Not implemented yet.
  }
  
  Money operator -(Money other) {
    _assertSameCurrency(other);
    // TODO: Not implemented yet.
  }
  
  Money operator -() {
    // TODO: Not implemented yet.
  }
  
  int compareTo(Money other) {
    _assertSameCurrency(other);
    // TODO: Not implemented yet.
  }
  
  bool operator ==(Money other) {
    _assertSameCurrency(other);
    // TODO: Not implemented yet.
  }
  
  int get hashCode {
    // TODO: Not implemented yet.
  }
  
  String toString() {
      var integerPart  = (amount ~/ currency.subUnit).toString();
      var fractionPart = (amount % currency.subUnit).toString();
      
      while (fractionPart.length < currency.defaultFractionDigits) {
        fractionPart = '0' + fractionPart;
      }
      
      return '${integerPart}.${fractionPart} ${currency.code}';
    }
  
  void _assertSameCurrency(Money money) {
    if (money.currency != currency) {
      throw new ArgumentError('Money math mismatch. Currencies are different.');
    }
  }
}