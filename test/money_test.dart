// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

library money.test.money;

import 'package:unittest/unittest.dart';
import 'package:money/money.dart';

class MockCurrency implements Currency {
  static const usd = const MockCurrency('USD', 'US Dollar', 840, 2, 100);
  static const eur = const MockCurrency('EUR', 'Euro', 978, 2, 100);
  static const iqd = const MockCurrency('IQD', 'Iraqi Dinar', 368, 3, 1000);
  
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
      final money = new Money(100, MockCurrency.usd);
      
      expect(money.amount, equals(100));
      expect(money.currency, same(MockCurrency.usd));
    });
    
    group('==()', () {
      test('the same amount and currencies', () {
        final money1 = new Money(1000, MockCurrency.usd);
        final money2 = new Money(1000, MockCurrency.usd);
        
        expect(money1 == money2, isTrue);
        expect(money1.hashCode == money2.hashCode, isTrue);
      });
      
      test('the same currency but different amounts', () {
        final money1 = new Money(1000, MockCurrency.usd);
        final money2 = new Money(2000, MockCurrency.usd);
        
        expect(money1 == money2, isFalse);
        expect(money1.hashCode == money2.hashCode, isFalse);
      });
      
      test('the same amount but different currencies', () {
        final money1 = new Money(1000, MockCurrency.usd);
        final money2 = new Money(1000, MockCurrency.eur);
        
        expect(money1 == money2, isFalse);
      });
      
      test('different amounts and currencies', () {
        final money1 = new Money(0, MockCurrency.usd);
        final money2 = new Money(1000, MockCurrency.eur);
        
        expect(money1 == money2, isFalse);
      });
    });
    
    group('unary -()', () {
      test('amount is zero', () {
        final money = new Money(0, MockCurrency.usd);
        
        expect(-money, equals(new Money(0, MockCurrency.usd)));
      });
      
      test('positive amount', () {
        final money = new Money(100, MockCurrency.usd);
        
        expect(-money, equals(new Money(-100, MockCurrency.usd)));
      });
      
      test('negative amount', () {
        final money = new Money(-100, MockCurrency.usd);
        
        expect(-money, new Money(100, MockCurrency.usd));
      });
    });
    
    group('-()', () {
      
    });
    test('toString()', () {
      expect(new Money(0, MockCurrency.usd).toString(), '0.00 USD');
      expect(new Money(1, MockCurrency.usd).toString(), '0.01 USD');
      expect(new Money(10, MockCurrency.usd).toString(), '0.10 USD');
      expect(new Money(100, MockCurrency.usd).toString(), '1.00 USD');
      expect(new Money(101, MockCurrency.usd).toString(), '1.01 USD');
      expect(new Money(110, MockCurrency.usd).toString(), '1.10 USD');
      expect(new Money(-100, MockCurrency.usd).toString(), '-1.00 USD');
      
      expect(new Money(0, MockCurrency.iqd).toString(), '0.000 IQD');
      expect(new Money(1, MockCurrency.iqd).toString(), '0.001 IQD');
      expect(new Money(10, MockCurrency.iqd).toString(), '0.010 IQD');
      expect(new Money(100, MockCurrency.iqd).toString(), '0.100 IQD');
      expect(new Money(1000, MockCurrency.iqd).toString(), '1.000 IQD');
      expect(new Money(1001, MockCurrency.iqd).toString(), '1.001 IQD');
      expect(new Money(1110, MockCurrency.iqd).toString(), '1.110 IQD');
      expect(new Money(-1000, MockCurrency.iqd).toString(), '-1.000 IQD');
    });
  });
}