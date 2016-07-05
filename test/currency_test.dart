// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

import 'package:test/test.dart';
import 'package:money/money.dart' show Currency;

final currency = new Currency('USD');
final anotherCurrency = new Currency('EUR');

void main() {
  group('Currency', () {
    test('has a code', () {
      expect(currency.code, same('USD'));
    });

    test('should throw an error if code is NULL', () {
      expect(() => new Currency(null), throwsArgumentError);
    });

    test('should throw an error if code is empty string', () {
      expect(() => new Currency(''), throwsArgumentError);
      expect(() => new Currency('  '), throwsArgumentError);
    });

    test('equals to another currency', () {
      expect(currency == currency, isTrue);
      expect(currency == anotherCurrency, isFalse);
    });

    test('has a hashcode', () {
      expect(currency.hashCode, const isInstanceOf<int>());
      expect(currency.hashCode, equals(new Currency('USD').hashCode));
      expect(currency.hashCode, isNot(equals(new Currency('EUR').hashCode)));
    });
  });
}