// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

library money.test.money;

import 'package:unittest/unittest.dart';
import 'package:money/money.dart';

class MockCurrency implements Currency {
  static const USD = const MockCurrency('USD', 'US Dollar', 840, 2, 100);
  static const EUR = const MockCurrency('EUR', 'Euro', 978, 2, 100);
  static const IQD = const MockCurrency('IQD', 'Iraqi Dinar', 368, 3, 1000);
  
  final String code;
  final String name;
  final int    numericCode;
  final int    defaultFractionDigits;
  final int    subUnit;
  
  const MockCurrency(
    this.code,
    this.name,
    this.numericCode,
    this.defaultFractionDigits,
    this.subUnit
  );

  String toString() => code;
}

void main() {
  group('Money', () {
    
    test('construction', () {
      final money = new Money(100, MockCurrency.USD);
      
      expect(money.amount, equals(100));
      expect(money.currency, same(MockCurrency.USD));
    });
    
    group('equality', () {
      
      test('with-same-amount-and-currencies', () {
        final money1 = new Money(1000, MockCurrency.USD);
        final money2 = new Money(1000, MockCurrency.USD);
        
        expect(money1 == money2, isTrue);
        expect(money1.hashCode == money2.hashCode, isTrue);
      });
      
      test('with-same-currency-and-different-amounts', () {
        final money1 = new Money(1000, MockCurrency.USD);
        final money2 = new Money(2000, MockCurrency.USD);
        
        expect(money1 == money2, isFalse);
        expect(money1.hashCode == money2.hashCode, isFalse);
      });
      
      test('with-same-amount-and-different-currencies', () {
        final money1 = new Money(1000, MockCurrency.USD);
        final money2 = new Money(1000, MockCurrency.EUR);
        
        expect(money1 == money2, isFalse);
      });
      
      test('with-different-amounts-and-currencies', () {
        final money1 = new Money(0, MockCurrency.USD);
        final money2 = new Money(1000, MockCurrency.EUR);
        
        expect(money1 == money2, isFalse);
      });
      
    });
    
    test('toString()', () {
      expect(new Money(0, MockCurrency.USD).toString(), '0.00 USD');
      expect(new Money(1, MockCurrency.USD).toString(), '0.01 USD');
      expect(new Money(10, MockCurrency.USD).toString(), '0.10 USD');
      expect(new Money(100, MockCurrency.USD).toString(), '1.00 USD');
      expect(new Money(101, MockCurrency.USD).toString(), '1.01 USD');
      expect(new Money(110, MockCurrency.USD).toString(), '1.10 USD');
      expect(new Money(-100, MockCurrency.USD).toString(), '-1.00 USD');
      
      expect(new Money(0, MockCurrency.IQD).toString(), '0.000 IQD');
      expect(new Money(1, MockCurrency.IQD).toString(), '0.001 IQD');
      expect(new Money(10, MockCurrency.IQD).toString(), '0.010 IQD');
      expect(new Money(100, MockCurrency.IQD).toString(), '0.100 IQD');
      expect(new Money(1000, MockCurrency.IQD).toString(), '1.000 IQD');
      expect(new Money(1001, MockCurrency.IQD).toString(), '1.001 IQD');
      expect(new Money(1110, MockCurrency.IQD).toString(), '1.110 IQD');
      expect(new Money(-1000, MockCurrency.IQD).toString(), '-1.000 IQD');
    });
    
  });
}