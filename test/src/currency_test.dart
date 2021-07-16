/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 - 2019 LitGroup LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('A currency', () {
    test('has a code and a precision', () {
      var currency = Currency.create('JPY', 0);
      expect(currency.code, equals('JPY'));
      expect(currency.precision, equals(0));

      currency = Currency.create('USD', 2);
      expect(currency.code, equals('USD'));
      expect(currency.precision, equals(2));
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
  });
}
