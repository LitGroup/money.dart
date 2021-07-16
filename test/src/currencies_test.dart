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
  group('Currencies Register', () {
    final usd = Currency.create('USD', 2);
    final eur = Currency.create('EUR', 2);

    setUp(() {
      Currencies.registerList([usd, eur]);
    });

    test('returns a currency identified by code', () {
      expect(Currencies.find('USD'), equals(usd));
      expect(Currencies.find('EUR'), equals(eur));
    });

    test('returns null if a currency cannot be found', () {
      expect(Currencies.find('BTC'), isNull);
    });

    test('returns all currencies correctly', () {
      expect(Currencies.getRegistered(), [usd, eur]);
      expect(Currencies.getRegistered().map((c) => c.code), ['USD', 'EUR']);
    });
  });
}
