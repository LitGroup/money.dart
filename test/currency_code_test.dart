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
    group('creation from string', () {
      test('succeeds', () {
        expect(() => CurrencyCode.tryFrom('ABC'), returnsNormally);
        expect(() => CurrencyCode.tryFrom('DEF'), returnsNormally);
        expect(() => CurrencyCode.tryFrom('GHIJKLMNOP'), returnsNormally);
        expect(() => CurrencyCode.tryFrom('QRSTUVWXYZ'), returnsNormally);
      });

      test('throws error for invalid string', () {
        expect(() => CurrencyCode.from(''), throwsArgumentError);
        expect(() => CurrencyCode.from('XX'), throwsArgumentError);
      });
    });

    group('failable creation from string', () {
      // Currency code:
      // 1. Contains uppercase latin letters;
      // 2. Has length from 3 to 10 letters.

      test('succeeds', () {
        expect(CurrencyCode.tryFrom('ABC'), isNotNull);
        expect(CurrencyCode.tryFrom('DEF'), isNotNull);
        expect(CurrencyCode.tryFrom('GHIJKLMNOP'), isNotNull);
        expect(CurrencyCode.tryFrom('QRSTUVWXYZ'), isNotNull);
      });

      test('returns null for invalid string', () {
        expect(CurrencyCode.tryFrom(''), isNull,
            reason: 'Empty string is not allowed.');
        expect(CurrencyCode.tryFrom('abc'), isNull,
            reason: 'Currency code can contain uppercase letters only.');
        expect(CurrencyCode.tryFrom(/* Cyrillic */ 'РУБ'), isNull,
            reason: 'Currency code can contain latin letters only.');

        expect(CurrencyCode.tryFrom('XX'), isNull,
            reason: 'Min allowed length of the currency code is 3.');
        expect(CurrencyCode.tryFrom('XXXXXXXXXXZ'), isNull,
            reason: 'Max allowed length of the currency code is 10.');

        // Additional check to detect common regular expression mistakes:
        expect(CurrencyCode.tryFrom('ABC\n'), isNull);
        expect(CurrencyCode.tryFrom('ABC\nABC'), isNull);
        expect(CurrencyCode.tryFrom('\nABC'), isNull);
        expect(CurrencyCode.tryFrom('ABC '), isNull);
        expect(CurrencyCode.tryFrom('ABC ABC'), isNull);
        expect(CurrencyCode.tryFrom(' ABC'), isNull);
      });
    });

    test('conversion to string', () {
      expect(CurrencyCode.from('RUR').toString(), equals('RUR'));
    });

    test('equality & hashing', () {
      expect(CurrencyCode.from('RUR'), equals(CurrencyCode.from('RUR')));
      expect(CurrencyCode.from('RUR').hashCode,
          equals(CurrencyCode.from('RUR').hashCode),
          reason: 'Equal values must have equal hashes.');

      expect(CurrencyCode.from('RUR'), isNot(CurrencyCode.from('USD')));
    });
  });
}
