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

import 'package:money/money.dart';
import 'package:test/test.dart';

void main() {
  group('Currencies', () {
    final rur = Currency(CurrencyCode('RUR'), precision: 2);
    final usd = Currency(CurrencyCode('USD'), precision: 2);

    /// The currencies directory to be tested.
    late Currencies currencies;

    setUp(() => currencies = Currencies.from([rur, usd]));

    group('.findByCode()', () {
      test('returns found currency', () {
        expect(currencies.findByCode(rur.code), equals(rur));
        expect(currencies.findByCode(usd.code), equals(usd));
      });

      test('returns null if requested currency not registered', () {
        expect(currencies.findByCode(CurrencyCode('UNKNOWN')), isNull);
      });
    });
  });
}
