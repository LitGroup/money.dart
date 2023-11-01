// Copyright (c) 2023 LLC "LitGroup"
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is furnished
// to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import 'package:test/test.dart';

import 'package:money/money.dart';

void main() {
  group('Currency', () {
    final rurCode = CurrencyCode('RUR');
    final usdCode = CurrencyCode('USD');
    final jpyCode = CurrencyCode('JPY');

    group('construction', () {
      test('succeeds', () {
        var currency = Currency(rurCode, precision: 2);
        expect(currency.code, equals(rurCode));
        expect(currency.precision, equals(2));

        currency = Currency(jpyCode, precision: 0);
        expect(currency.code, equals(jpyCode));
        expect(currency.precision, equals(0));
      });

      test('fails if `precision` is negative', () {
        expect(() => Currency(jpyCode, precision: -1), throwsArgumentError);
      });
    });

    test('.==()', () {
      final rur = Currency(rurCode, precision: 2);
      final anotherRur = Currency(rurCode, precision: 2);
      final usd = Currency(usdCode, precision: 2);

      expect(rur == rur, isTrue);
      expect(rur == anotherRur, isTrue);
      expect(rur == usd, isFalse);
    });

    test('.hashCode', () {
      final rur = Currency(rurCode, precision: 2);
      final anotherRur = Currency(rurCode, precision: 2);

      expect(rur.hashCode, equals(anotherRur.hashCode));
    });

    test('.toString()', () {
      final rur = Currency(rurCode, precision: 2);

      expect(rur.toString(), equals(rurCode.toString()));
    });
  });
}
