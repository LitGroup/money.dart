/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('A currency', () {
    test('has a code and a precision', () {
      var currency = Currency.create('JPY', 0);
      expect(currency.code, equals('JPY'));
      expect(currency.scale, equals(0));

      currency = Currency.create('USD', 2);
      expect(currency.code, equals('USD'));
      expect(currency.scale, equals(2));
    });

    test('cannot be instantiated with empty code', () {
      expect(() => Currency.create('', 0), throwsArgumentError);
    });

    test('cannot be instantiated with negative precision', () {
      expect(() => Currency.create('SOME', -1), throwsArgumentError);
      expect(() => Currency.create('SOME', -2), throwsArgumentError);
    });

    test('is equatable', () {
      final usd = Currency.create('USD', 2);

      expect(usd, equals(Currency.create('USD', 2)));
      expect(usd, isNot(equals(Currency.create('EUR', 2))));
      expect(usd, isNot(equals(Currency.create('USD', 0))));
      expect(usd, isNot(equals(Currency.create('JPY', 0))));
    });

    test('is hashable', () {
      final usd = Currency.create('USD', 2);

      expect(usd.hashCode, equals(Currency.create('USD', 2).hashCode));
    });

    test('btc', () {
      /// proposed
      final t2 = Currency.create('BTC', 8, symbol: '₿', pattern: 'S0.########');

      expect(Money.parseWithCurrency('1', t2).toString(), equals('₿1'));
      expect(Money.parseWithCurrency('1.1', t2).toString(), equals('₿1.1'));
      expect(Money.parseWithCurrency('1.11', t2).toString(), equals('₿1.11'));
      expect(Money.parseWithCurrency('1.01', t2).toString(), equals('₿1.01'));
    });
  });
}
