// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

library money.test.currency;

import 'package:test/test.dart';
import 'package:money/money.dart';

void main() {
  group('Currency', () {

    group('default factory', () {
      test('must throw error if non-existent code given', () {
        expect(() => new Currency('WTFCURRENCY'), throwsArgumentError);
        expect(() => new Currency(null), throwsArgumentError);
      });

      test('create from uppercase code', () {
        final currency = new Currency('USD');
        expect(currency, const isInstanceOf<Currency>());
        expect(currency.code, equals('USD'));
        expect(currency.name, equals('US Dollar'));
        expect(currency.numericCode, equals(840));
        expect(currency.defaultFractionDigits, equals(2));
        expect(currency.subUnit, equals(100));
      });

      test('create from lowercase string', () {
        final currency = new Currency('usd');
        expect(currency, const isInstanceOf<Currency>());
        expect(currency.code, equals('USD'));
      });
    });

    test('==() and hashCcode', () {
      var currency1 = new Currency('USD');
      var currency2 = new Currency('USD');
      var currency3 = new Currency('EUR');

      expect(currency1 == currency2, isTrue);
      expect(currency1.hashCode, equals(currency2.hashCode));

      expect(currency1 != currency3, isTrue);
    });

    test('toString()', () {
      var currency = new Currency('USD');

      expect(currency.toString(), equals('USD'));
    });
  });
}
