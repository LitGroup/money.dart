// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

import 'package:test/test.dart';
import 'package:money/money.dart' show Currency;

void main() {
  group('Currency', () {
    test('should have a code', () {
      final currency = new Currency('USD');

      expect(currency.code, same('USD'));
    });

    test('should throw an error if code is NULL', () {
      expect(() => new Currency(null), throwsArgumentError);
    });

    test('should throw an error if code is empty string', () {
      expect(() => new Currency(''), throwsArgumentError);
      expect(() => new Currency('  '), throwsArgumentError);
    });

    test('should be equal to another Currency with the same code', () {
      final a = new Currency('USD');
      final b = new Currency('USD');
      final c = new Currency('EUR');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a.hashCode, const isInstanceOf<int>());

      expect(a, isNot(equals(c)));
      expect(a.hashCode, isNot(equals(c.hashCode)));

      expect(a, isNot(equals('not a currency')));
    });
  });
}