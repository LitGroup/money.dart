// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

import 'package:test/test.dart';
import 'package:money/money.dart' show Money, Currency;

final amount = 10;
final otherAmount = 5;
final currency = new Currency('USD');
final otherCurrency = new Currency('EUR');
final money = new Money(amount, currency);

void main() {
  group('Money', () {
    test('has an amount', () {
      expect(money.amount, equals(amount));
    });

    test('has a currency', () {
      expect(money.currency, same(currency));
    });

    test('throws an error if amount is null', () {
      expect(() => new Money(null, currency), throwsArgumentError);
    });

    test('throws an error if currency is null', () {
      expect(() => new Money(1, null), throwsArgumentError);
    });

    test('tests currency equality', () {
      expect(money.isSameCurrency(new Money(amount, currency)), isTrue);
      expect(money.isSameCurrency(new Money(amount, otherCurrency)), isFalse);
    });

    test('equals to another money', () {
      expect(money == new Money(amount, currency), isTrue);
      expect(money == new Money(amount + 1, currency), isFalse);
      expect(money == new Money(amount, otherCurrency), isFalse);
      expect(money == new Money(amount + 1, otherCurrency), isFalse);
      expect(money == 'not a money', isFalse);
    });

    test('has a hashcode', () {
      expect(money.hashCode, const isInstanceOf<int>());
      expect(money.hashCode, equals(new Money(amount, currency).hashCode));
      expect(money.hashCode, isNot(equals(new Money(amount + 1, currency).hashCode)));
      expect(money.hashCode, isNot(equals(new Money(amount, otherCurrency).hashCode)));
      expect(money.hashCode, isNot(equals(new Money(amount + 1, otherCurrency).hashCode)));
    });

    group('compares two amounts', () {
      test('(both are equal)', () {
        final another = new Money(amount, currency);
        expect(money.compareTo(another), equals(0));
        expect(money < another, isFalse);
        expect(money <= another, isTrue);
        expect(money > another, isFalse);
        expect(money >= another, isTrue);
      });

      test('(one less than another)', () {
        final another = new Money(amount + 1, currency);
        expect(money.compareTo(another), equals(-1));
        expect(money < another, isTrue);
        expect(money <= another, isTrue);
        expect(money > another, isFalse);
        expect(money >= another, isFalse);
      });

      test('(one greater than another)', () {
        final another = new Money(amount - 1, currency);
        expect(money.compareTo(another), equals(1));
        expect(money < another, isFalse);
        expect(money <= another, isFalse);
        expect(money > another, isTrue);
        expect(money >= another, isTrue);
      });
    });

    test('shold throw an exception when currency is different during comparison', () {
      final another = new Money(amount, otherCurrency);
      expect(() => money.compareTo(another), throwsArgumentError);
      expect(() => money < another, throwsArgumentError);
      expect(() => money <= another, throwsArgumentError);
      expect(() => money > another, throwsArgumentError);
      expect(() => money >= another, throwsArgumentError);
    });

    test('adds an another money', () {
      final result = new Money(amount, currency) + new Money(otherAmount, currency);
      expect(result, const isInstanceOf<Money>());
      expect(result.amount, equals(amount + otherAmount));
      expect(result.currency, equals(currency));
    });

    test('throws an error if currency is different during addition', () {
      expect(() => money + new Money(amount, otherCurrency), throwsArgumentError);
    });

    test('subtracts an another money', () {
      final result = new Money(amount, currency) - new Money(otherAmount, currency);
      expect(result, const isInstanceOf<Money>());
      expect(result.amount, equals(amount - otherAmount));
      expect(result.currency, equals(currency));
    });

    test('throws an error if currency is different during subtraction', () {
      expect(() => money - new Money(amount, otherCurrency), throwsArgumentError);
    });


  });
}