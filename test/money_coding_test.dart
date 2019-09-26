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

import 'package:money2/money2.dart';
import 'package:money2/src/encoders.dart';
import 'package:money2/src/money_data.dart';
import 'package:test/test.dart';

class _TestEncoder implements MoneyEncoder<String> {
  String encode(MoneyData data) {
    return '${data.currency.code} ${data.minorUnits}';
  }
}

class _TestDecoder implements MoneyDecoder<MoneyData> {
  MoneyData decode(MoneyData encoded) {
    return encoded;
  }
}

class _FailingDecoder implements MoneyDecoder<String> {
  MoneyData decode(String encoded) {
    throw FormatException();
  }
}

void main() {
  final usd = Currency.create('USD', 2);

  group('MoneyData', () {
    test('throws an error during instantiation with null minorUnits', () {
      expect(() => MoneyData.from(null, usd), throwsArgumentError);
    });

    test('throws an error during instantiation with null currency', () {
      expect(() => MoneyData.from(BigInt.from(100), null), throwsArgumentError);
    });

    test('has properties: minorUnits, currency', () {
      final minorUnits = BigInt.from(100);

      final data = MoneyData.from(minorUnits, usd);
      expect(data.minorUnits, equals(minorUnits));
      expect(data.currency, equals(usd));
    });
  });

  group('Money', () {
    test('encoding', () {
      final fiveDollars = Money.fromBigInt(BigInt.from(500), usd);

      expect(fiveDollars.encodedBy(_TestEncoder()), equals('USD 500'));
    });

    test('decoding', () {
      final money =
          Money.decoding(MoneyData.from(BigInt.from(500), usd), _TestDecoder());

      expect(money, equals(Money.fromBigInt(BigInt.from(500), usd)));
    });

    test('decoding exception', () {
      expect(() => Money.decoding('invalid data', _FailingDecoder()),
          throwsFormatException);
    });
  });
}
