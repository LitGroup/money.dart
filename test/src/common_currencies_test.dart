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
  group('CommonCurrency', () {
    test('has a code and a precision', () {
      // Check common currencies are registered.
      expect(Currencies().find('USD'), equals(CommonCurrencies().usd));

      var value = Currencies().parse(r'$USD10.50');
      expect(value, equals(Money.fromInt(1050, code: 'USD')));

      // register all common currencies.
      value = Currencies().parse(r'$NZD10.50');
      expect(value, equals(Money.fromInt(1050, code: 'NZD')));
      
      //Test for newly added currency
      value = Currencies().parse(r'₦NGN4.50');
      expect(value, equals(Money.fromInt(450, code: 'NGN')));

      value = Currencies().parse(r'₵GHS4.50');
      expect(value, equals(Money.fromInt(450, code: 'GHS')));

    });

    test('Test Default Formats', () {
      expect(Currencies().find('AUD')!.parse(r'$1234.56').toString(),
          equals(r'$1234.56'));

      expect(Currencies().find('INR')!.parse(r'₹1234.56').toString(),
          equals(r'₹1234.56'));
    });

    test('Test 1000 separator', () {
      expect(
          Currencies()
              .find('AUD')!
              .copyWith(pattern: r'S#,###.##')
              .parse(r'$1234.56')
              .toString(),
          equals(r'$1,234.56'));

      expect(
          Currencies()
              .find('INR')!
              .copyWith(pattern: r'S#,###.##')
              .parse(r'₹1234.56')
              .toString(),
          equals(r'₹1,234.56'));

      expect(
          Currencies()
              .find('INR')!
              .copyWith(pattern: r'S##,##,###.##')
              .parse(r'₹1234567.89')
              .toString(),
          equals(r'₹12,34,567.89'));
    });
  });
}
