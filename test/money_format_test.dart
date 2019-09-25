/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 - 2019 LitGroup LLC
 *
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
  final jpy = Currency.withCodeAndPrecision('JPY', 0);
  final usd = Currency.withCodeAndPrecision('USD', 2);
  final bhd = Currency.withCodeAndPrecision('BHD', 3);

  final Money usd10d25 = Money.fromInt(1025, usd);
  final Money usd212d25 = Money.fromInt(21225, usd);
  final Money jpy101 = Money.fromInt(101, jpy);
  final Money bhd99d111 = Money.fromInt(99111, bhd);

  group('format', () {
    test('Simple USD', () {

      expect(usd10d25.format("##.##"), equals("10.25"));
      expect(usd10d25.format("##"), equals("10"));
    });

    test('Lead zero USD', () {
      expect(usd10d25.format("0##.##"), equals("010.25"));
      expect(usd10d25.format("0##"), equals("010"));
    });

    test('trailing zero USD', () {
      expect(usd10d25.format("##.##0"), equals("10.250"));
      expect(usd10d25.format("0##"), equals("010"));
    });

    test('Simple USD with sign', () {
      expect(usd10d25.format("S##.##"), equals("\$10.25"));
      expect(usd10d25.format("S##"), equals("\$10"));
      expect(usd10d25.format("S##"), equals("\$10"));
    });

    test('Simple USD with currency', () {
      expect(usd10d25.format("C##.##"), equals("U10.25"));
      expect(usd10d25.format("CC##.##"), equals("US10.25"));
      expect(usd10d25.format("CCC##.##"), equals("USD10.25"));
    });

    test('USD combos', () {
      expect(usd10d25.format("SCCC 00##.##"), equals("\$USD 0010.25"));
    });


    test('Invalid Patterns', () {
      expect(usd10d25.format("##0"), throwsA(IllegalPatternException));
    });
  });
}
