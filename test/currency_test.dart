// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

library money.test.currency;

import 'package:unittest/unittest.dart';
import 'package:money/money.dart';

void main() {
  group('Currency', () {
    
    group('factory', () {
    
      test('error-for-invalid-factory-argument', () {
        expect(() => new Currency('WTFCURENCY'), throwsArgumentError);
        expect(() => new Currency(null), throwsArgumentError);
      });

      test('create-from-uppercase-string', () {
        expect(new Currency('USD'), const isInstanceOf<Currency>());
      });
      
      test('create-from-lowercase-string', () {
        expect(new Currency('usd'), const isInstanceOf<Currency>());
      });
    });
    
    test('equality', () {
      var currency1 = new Currency('USD');
      var currency2 = new Currency('USD');
      var currency3 = new Currency('EUR');
      
      expect(currency1 == currency2, isTrue);
      expect(currency1.hashCode, equals(currency2.hashCode));
      expect(currency1 != currency3, isTrue);
      expect(currency1.hashCode, isNot(equals(currency3.hashCode)));
    });
    
    test('cust-to-string', () {
      var currency = new Currency('USD');
      
      expect(currency.toString(), equals('USD'));
    });
    
  });
}