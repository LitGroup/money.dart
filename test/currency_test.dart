/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 - 2018 Roman Shamritskiy
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'package:test/test.dart';
import 'package:money/money.dart';

void main() {
  group('Currency', () {

    group('default factory', () {
      test('must throw error if non-existent code given', () {
        expect(() => Currency('WTFCURRENCY'), throwsArgumentError);
        expect(() => Currency(null), throwsArgumentError);
      });

      test('create from uppercase code', () {
        final currency = Currency('USD');
        expect(currency, const TypeMatcher<Currency>());
        expect(currency.code, equals('USD'));
        expect(currency.name, equals('US Dollar'));
        expect(currency.numericCode, equals(840));
        expect(currency.defaultFractionDigits, equals(2));
        expect(currency.subUnit, equals(100));
      });

      test('create from lowercase string', () {
        final currency = Currency('usd');
        expect(currency, const TypeMatcher<Currency>());
        expect(currency.code, equals('USD'));
      });
    });

    test('==() and hashCcode', () {
      var currency1 = Currency('USD');
      var currency2 = Currency('USD');
      var currency3 = Currency('EUR');

      expect(currency1 == currency2, isTrue);
      expect(currency1.hashCode, equals(currency2.hashCode));

      expect(currency1 != currency3, isTrue);
    });

    test('toString()', () {
      var currency = Currency('USD');

      expect(currency.toString(), equals('USD'));
    });
  });
}
