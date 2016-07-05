// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

import 'package:test/test.dart';
import 'package:money/money.dart' show Money, Currency;

final currency = new Currency('USD');
final anotherCurrency = new Currency('EUR');

void main() {
  group('Money', () {
    test('should be constructed with amount and currency', () {
      final money = new Money(1, currency);
      expect(money.amount, same(1));
      expect(money.currency, same(currency));
    });

    test('constructor should throw an error if amount is null', () {
      expect(() => new Money(null, currency), throwsArgumentError);
    });

    test('constructor should throw an error if currency is null', () {
      expect(() => new Money(1, null), throwsArgumentError);
    });
  });
}