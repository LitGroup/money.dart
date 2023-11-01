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
  group('Money', () {
    final rur = Currency(CurrencyCode('RUR'), precision: 2);
    final usd = Currency(CurrencyCode('USD'), precision: 2);

    test('construction with subunits', () {
      expect(() => Money.withSubunits(BigInt.from(100), rur), returnsNormally);
    });

    // Comparison:

    test('.sameCurrencyAs()', () {
      final twoRubles = Money.withSubunits(BigInt.from(200), rur);
      final fiveRubles = Money.withSubunits(BigInt.from(500), rur);
      final twoDollars = Money.withSubunits(BigInt.from(200), usd);

      expect(twoRubles.isSameCurrencyAs(fiveRubles), isTrue);
      expect(twoRubles.isSameCurrencyAs(twoDollars), isFalse);
    });

    test('.notSameCurrencyAs()', () {
      final twoRubles = Money.withSubunits(BigInt.from(200), rur);
      final fiveRubles = Money.withSubunits(BigInt.from(500), rur);
      final twoDollars = Money.withSubunits(BigInt.from(200), usd);

      expect(twoRubles.isNotSameCurrencyAs(twoDollars), isTrue);
      expect(twoRubles.isNotSameCurrencyAs(fiveRubles), isFalse);
    });

    test('.hashCode', () {
      final fiveRubles = Money.withSubunits(BigInt.from(500), rur);
      final fiveMoreRubles = Money.withSubunits(BigInt.from(500), rur);

      expect(fiveRubles.hashCode, equals(fiveMoreRubles.hashCode));
    });

    test('.==()', () {
      final fiveRubles = Money.withSubunits(BigInt.from(500), rur);
      final sixRubles = Money.withSubunits(BigInt.from(600), rur);
      final fiveDollars = Money.withSubunits(BigInt.from(500), usd);

      expect(fiveRubles == fiveRubles, isTrue);
      expect(fiveRubles == Money.withSubunits(BigInt.from(500), rur), isTrue);

      expect(fiveRubles == sixRubles, isFalse,
          reason: 'The same currency but different amount.');
      expect(fiveRubles == fiveDollars, isFalse,
          reason: 'The same amount but different currencies.');
    });

    // Arithmetics:

    test('.-() unary', () {
      final zeroRubles = Money.withSubunits(BigInt.from(0), rur);

      expect(-zeroRubles, equals(zeroRubles));

      final fiveRubles = Money.withSubunits(BigInt.from(500), rur);
      final minusFiveRubles = Money.withSubunits(BigInt.from(-500), rur);

      expect(-fiveRubles, equals(minusFiveRubles));
      expect(-minusFiveRubles, equals(fiveRubles));
    });

    test('.-()', () {
      final fiveRubles = Money.withSubunits(BigInt.from(500), rur);
      final threeRubles = Money.withSubunits(BigInt.from(300), rur);
      final twoRubles = Money.withSubunits(BigInt.from(200), rur);

      expect(fiveRubles - threeRubles, equals(twoRubles));
      expect(threeRubles - fiveRubles, equals(-twoRubles));
    });

    test('.-() fails for operands of different currencies', () {
      final fiveRubbles = Money.withSubunits(BigInt.from(500), rur);
      final fiveDollars = Money.withSubunits(BigInt.from(500), usd);
      expect(() => fiveRubbles - fiveDollars,
          throwsA(isA<MoneyArithmeticError>()));
    });

    test('.+()', () {
      final fiveRubles = Money.withSubunits(BigInt.from(500), rur);
      final threeRubles = Money.withSubunits(BigInt.from(300), rur);
      final twoRubles = Money.withSubunits(BigInt.from(200), rur);

      expect(twoRubles + threeRubles, equals(fiveRubles));
      expect(-threeRubles + fiveRubles, equals(twoRubles));
    });

    test('.+() fails for operands of different currencies', () {
      final fiveRubbles = Money.withSubunits(BigInt.from(500), rur);
      final fiveDollars = Money.withSubunits(BigInt.from(500), usd);

      expect(() => fiveRubbles + fiveDollars,
          throwsA(isA<MoneyArithmeticError>()));
    });
  });
}
