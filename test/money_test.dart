// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

import 'package:test/test.dart';
import 'package:money/money.dart' show Money, Currency;

final amount = 1;
final currency = new Currency('USD');
final anotherCurrency = new Currency('EUR');

void main() {
  group('Money', () {
    Money money;

    setUp(() {
      money = new Money(amount, currency);
    });

    test('has an amount', () {
      expect(money.amount, equals(amount));
    });

    test('has a currency', () {
      expect(money.currency, same(currency));
    });

    test('should throw an error if amount is null', () {
      expect(() => new Money(null, currency), throwsArgumentError);
    });

    test('should throw an error if currency is null', () {
      expect(() => new Money(1, null), throwsArgumentError);
    });

    test('tests currency equality', () {
      expect(money.isSameCurrency(new Money(amount, currency)), isTrue);
      expect(money.isSameCurrency(new Money(amount, anotherCurrency)), isFalse);
    });

    test('equals to another money', () {
      expect(money == new Money(amount, currency), isTrue);
      expect(money == new Money(amount + 1, currency), isFalse);
      expect(money == new Money(amount, anotherCurrency), isFalse);
      expect(money == new Money(amount + 1, anotherCurrency), isFalse);
      expect(money == 'not a money', isFalse);
    });

    test('has a hashcode', () {
      expect(money.hashCode, const isInstanceOf<int>());
      expect(money.hashCode, equals(new Money(amount, currency).hashCode));
      expect(money.hashCode, isNot(equals(new Money(amount + 1, currency).hashCode)));
      expect(money.hashCode, isNot(equals(new Money(amount, anotherCurrency).hashCode)));
      expect(money.hashCode, isNot(equals(new Money(amount + 1, anotherCurrency).hashCode)));
    });
  });
}