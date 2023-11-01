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
  group('CurrencyCode', () {
    test('construction', () {
      expect(() => CurrencyCode('RUR'), returnsNormally);
    });

    test('.toString()', () {
      expect(CurrencyCode('RUR').toString(), equals('RUR'));
      expect(CurrencyCode('rur').toString(), equals('rur'));
    });

    test('.==() provides case insensitive comparison', () {
      expect(CurrencyCode('RUR') == CurrencyCode('RUR'), isTrue);
      expect(CurrencyCode('RUR') == CurrencyCode('rur'), isTrue);
      expect(CurrencyCode('rur') == CurrencyCode('RUR'), isTrue);
      expect(CurrencyCode('RUR') == CurrencyCode('USD'), isFalse);
    });

    test('.hashCode', () {
      expect(
          CurrencyCode('RUR').hashCode, equals(CurrencyCode('RUR').hashCode));
      expect(
          CurrencyCode('RUR').hashCode, equals(CurrencyCode('rur').hashCode));
    });
  });
}
