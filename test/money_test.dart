// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

import 'package:test/test.dart';
import 'package:money/money.dart' show Money, Currency;

import 'round_examples.dart';
import 'allocation_examles.dart';

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

      test('(the first is less than the second)', () {
        final another = new Money(amount + 1, currency);
        expect(money.compareTo(another), equals(-1));
        expect(money < another, isTrue);
        expect(money <= another, isTrue);
        expect(money > another, isFalse);
        expect(money >= another, isFalse);
      });

      test('(the first is greater than  the second)', () {
        final another = new Money(amount - 1, currency);
        expect(money.compareTo(another), equals(1));
        expect(money < another, isFalse);
        expect(money <= another, isFalse);
        expect(money > another, isTrue);
        expect(money >= another, isTrue);
      });
    });

    test('throws an exception when currency is different during comparison', () {
      final another = new Money(amount, otherCurrency);
      expect(() => money.compareTo(another), throwsArgumentError);
      expect(() => money < another, throwsArgumentError);
      expect(() => money <= another, throwsArgumentError);
      expect(() => money > another, throwsArgumentError);
      expect(() => money >= another, throwsArgumentError);
    });

    test('throws an error if operand is null during comparison', () {
      expect(() => money.compareTo(null), throwsArgumentError);
      expect(() => money < null, throwsArgumentError);
      expect(() => money <= null, throwsArgumentError);
      expect(() => money > null, throwsArgumentError);
      expect(() => money >= null, throwsArgumentError);
    });

    test('adds an oher money', () {
      final result = new Money(amount, currency) + new Money(otherAmount, currency);
      expect(result, const isInstanceOf<Money>());
      expect(result.amount, equals(amount + otherAmount));
      expect(result.currency, equals(currency));
    });

    test('throws an error if operand is null during addition', () {
      expect(() => money + null, throwsArgumentError);
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

    test('throws an error if operand is null during substraction', () {
      expect(() => money - null, throwsArgumentError);
    });

    test('throws an error if currency is different during subtraction', () {
      expect(() => money - new Money(amount, otherCurrency), throwsArgumentError);
    });

    roundExamples.test('has a multiplication operator, which multiplies the amount with half-up rounding', (example) {
      final result = new Money(1, currency) * example.operand;
      expect(result, const isInstanceOf<Money>());
      expect(result.currency, same(currency));
      expect(result.amount, example.expectedResult);
    });

    test('throws an error when operand is null during multiplication', () {
      expect(() => money * null, throwsArgumentError);
    });

    roundExamples.test('has a division operator, which divides the amount with half-up rounding', (example) {
      final result = new Money(1, currency) / (1 / example.operand);
      expect(result, const isInstanceOf<Money>());
      expect(result.currency, same(currency));
      expect(result.amount, example.expectedResult);
    });

    test('throws an error when operand is null during division', () {
      expect(() => money / null, throwsArgumentError);
    });

    test('throws an error when divider is 0 during division', () {
      expect(() => money / 0, throwsArgumentError);
      expect(() => money / 0.0, throwsArgumentError);
    });

    allocationExamples.test('allocates amount', (example) {
      final allocated = new Money(example.amount, currency).allocate(example.ratios);

      expect(allocated.length, equals(example.allocatedAmounts.length));
      for (var i = 0; i < example.allocatedAmounts.length; ++i) {
        expect(allocated[i].currency, same(currency));
        expect(allocated[i].amount, equals(example.allocatedAmounts[i]));
      }
    });

    test('throws an error when allocate target is null', () {
      expect(() => money.allocate(null), throwsArgumentError);
    });

    test('throws an error when allocate target is empty', () {
      expect(() => money.allocate([]), throwsArgumentError);
    });

    test('throws an error when any of ratios is null during allocation', () {
      expect(() => money.allocate([1, null]), throwsArgumentError);
    });

    test('trows an error when any of ratios less than 0 during allocation', () {
      expect(() => money.allocate([4, -1]), throwsArgumentError);
    });

    test('throws an error when sum of ratios is 0', () {
      expect(() => money.allocate([0, 0]), throwsArgumentError);
    });
  });
}