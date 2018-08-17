/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 - 2018 Roman Shamritskiy
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

class MockCurrency implements Currency {
  static const usd = const MockCurrency('USD', 'US Dollar', 840, 2, 100);
  static const eur = const MockCurrency('EUR', 'Euro', 978, 2, 100);
  static const iqd = const MockCurrency('IQD', 'Iraqi Dinar', 368, 3, 1000);

  final String code;
  final String name;
  final int    numericCode;
  final int    defaultFractionDigits;
  final int    subUnit;

  const MockCurrency(
    this.code,
    this.name,
    this.numericCode,
    this.defaultFractionDigits,
    this.subUnit
  );

  String toString() => code;
}

void main() {
  group('Money', () {
    test('Money()', () {
      final money = Money(100, MockCurrency.usd);

      expect(money.amount, equals(100));
      expect(money.currency, same(MockCurrency.usd));
    });

    group('Money.fromString()', () {
      test('for "120" and USD currency', () {
        final money = Money.fromString('120', MockCurrency.usd);

        expect(money.amount, 12000);
        expect(money.currency, MockCurrency.usd);
      });

      test('for "120.00" and USD currency', () {
        final money = Money.fromString('120.00', MockCurrency.usd);

        expect(money.amount, 12000);
        expect(money.currency, MockCurrency.usd);
      });

      test('for "120.10" and USD currency', () {
        final money = Money.fromString('120.10', MockCurrency.usd);

        expect(money.amount, 12010);
        expect(money.currency, MockCurrency.usd);
      });

      test('for "-120.00" and USD currency', () {
        final money = Money.fromString('-120.00', MockCurrency.usd);

        expect(money.amount, -12000);
        expect(money.currency, MockCurrency.usd);
      });

      test('for "-120.10" and USD currency', () {
        final money = Money.fromString('-120.10', MockCurrency.usd);

        expect(money.amount, -12010);
        expect(money.currency, MockCurrency.usd);
      });

      test('for "120.010" and IQD currency', () {
        final money = Money.fromString('120.010', MockCurrency.iqd);

        expect(money.amount, 120010);
        expect(money.currency, MockCurrency.iqd);
      });

      test('for 0.30 and USD currency', () {
        final money = Money.fromString('0.30', MockCurrency.usd);

        expect(money.amount, 30);
        expect(money.currency, MockCurrency.usd);
      });

      test('for -0.30 and USD currency', () {
        final money = Money.fromString('-0.30', MockCurrency.usd);

        expect(money.amount, -30);
        expect(money.currency, MockCurrency.usd);
      });

      test('throws FormatException for "120.00" and IQD currency (3 fraction digits should be)', () {
        expect(
          () => Money.fromString('120.00', MockCurrency.iqd),
          throwsA(const TypeMatcher<FormatException>())
        );
      });

      test('throws FormatEception for incorrect strings', () {
        final values = [
          '',
          'not a numeric',
          '100abc',
          'abc100',
        ];

        for (var value in values) {
          expect(() => Money.fromString(value, MockCurrency.usd), throwsA(const TypeMatcher<FormatException>()));
        }
      });
    });

    group('Money.fromDouble()', () {
      test('for 0.0 and USD currency', () {
        final money = Money.fromDouble(0.0, MockCurrency.usd);

        expect(money.amount, equals(0));
        expect(money.currency, same(MockCurrency.usd));
      });

      test('for 10.01 and USD currency', () {
        final money = Money.fromDouble(10.01, MockCurrency.usd);

        expect(money.amount, equals(1001));
        expect(money.currency, same(MockCurrency.usd));
      });

      test('for 10.99 and USD currency', () {
        final money = Money.fromDouble(10.99, MockCurrency.usd);

        expect(money.amount, equals(1099));
        expect(money.currency, same(MockCurrency.usd));
      });

      test('for -10.50 and USD currency', () {
        final money = Money.fromDouble(-10.50, MockCurrency.usd);

        expect(money.amount, equals(-1050));
        expect(money.currency, same(MockCurrency.usd));
      });

      test('for 10.001 and IQD currency', () {
        final money = Money.fromDouble(10.001, MockCurrency.iqd);

        expect(money.amount, equals(10001));
        expect(money.currency, same(MockCurrency.iqd));
      });

      test('for 10.995 and USD currecy', () {
        final money = Money.fromDouble(10.995, MockCurrency.usd);

        expect(money.amount, equals(1100));
        expect(money.currency, same(MockCurrency.usd));
      });

      test('for 10.994 and USD currecy', () {
        final money = Money.fromDouble(10.994, MockCurrency.usd);

        expect(money.amount, equals(1099));
        expect(money.currency, same(MockCurrency.usd));
      });
    });

    group('get amountAsString', () {
      test('0.00 USD', () {
        final money = Money(0, MockCurrency.usd);

        expect(money.amountAsString, equals('0.00'));
      });

      test('10.50 USD', () {
        final money = Money(1050, MockCurrency.usd);

        expect(money.amountAsString, equals('10.50'));
      });

      test('-10.00 USD', () {
        final money = Money(-1000, MockCurrency.usd);

        expect(money.amountAsString, equals('-10.00'));
      });

      test('5.300 IQD', () {
        final money = Money(5300, MockCurrency.iqd);

        expect(money.amountAsString, equals('5.300'));
      });
    });

    group('==()', () {
      test('the same amount and currencies', () {
        final money1 = Money(1000, MockCurrency.usd);
        final money2 = Money(1000, MockCurrency.usd);

        expect(money1 == money2, isTrue);
        expect(money1.hashCode == money2.hashCode, isTrue);
      });

      test('the same currency but different amounts', () {
        final money1 = Money(1000, MockCurrency.usd);
        final money2 = Money(2000, MockCurrency.usd);

        expect(money1 == money2, isFalse);
        expect(money1.hashCode == money2.hashCode, isFalse);
      });

      test('the same amount but different currencies', () {
        final money1 = Money(1000, MockCurrency.usd);
        final money2 = Money(1000, MockCurrency.eur);

        expect(money1 == money2, isFalse);
      });

      test('different amounts and currencies', () {
        final money1 = Money(0, MockCurrency.usd);
        final money2 = Money(1000, MockCurrency.eur);

        expect(money1 == money2, isFalse);
      });
    });

    group('unary -()', () {
      test('amount is zero', () {
        final money = Money(0, MockCurrency.usd);

        expect(-money, equals(Money(0, MockCurrency.usd)));
      });

      test('positive amount', () {
        final money = Money(100, MockCurrency.usd);

        expect(-money, equals(Money(-100, MockCurrency.usd)));
      });

      test('negative amount', () {
        final money = Money(-100, MockCurrency.usd);

        expect(-money, Money(100, MockCurrency.usd));
      });
    });

    group('-()', () {
      test('error for different currencies', () {
        final minuend = Money(100, MockCurrency.usd);
        final subtrahend = Money(100, MockCurrency.eur);

        expect(() => minuend - subtrahend, throwsArgumentError);
      });

      test('0.00 USD - 0.00 USD', () {
        final a = Money(0, MockCurrency.usd);
        final b = Money(0, MockCurrency.usd);

        expect(a - b, equals(Money(0, MockCurrency.usd)));
      });

      test('0.00 USD - 1.00 USD', () {
        final a = Money(0, MockCurrency.usd);
        final b = Money(100, MockCurrency.usd);

        expect(a - b, equals(Money(-100, MockCurrency.usd)));
      });

      test('2.00 USD - 1.00 USD', () {
        final a = Money(200, MockCurrency.usd);
        final b = Money(100, MockCurrency.usd);

        expect(a - b, equals(Money(100, MockCurrency.usd)));
      });

      test('-2.00 USD - 1.00 USD', () {
        final a = Money(-200, MockCurrency.usd);
        final b = Money(100, MockCurrency.usd);

        expect(a - b, equals(Money(-300, MockCurrency.usd)));
      });
    });

    group('+()', () {
      test('error for different currencies', () {
        final a = Money(100, MockCurrency.usd);
        final b = Money(100, MockCurrency.eur);

        expect(() => a + b, throwsArgumentError);
      });

      test('0.00 USD + 0.00 USD', () {
        final a = Money(0, MockCurrency.usd);
        final b = Money(0, MockCurrency.usd);

        expect(a + b, equals(Money(0, MockCurrency.usd)));
      });

      test('0.00 USD + 1.00 USD', () {
        final a = Money(0, MockCurrency.usd);
        final b = Money(100, MockCurrency.usd);

        expect(a + b, equals(Money(100, MockCurrency.usd)));
      });

      test('1.00 USD + 0.00 USD', () {
        final a = Money(100, MockCurrency.usd);
        final b = Money(0, MockCurrency.usd);

        expect(a + b, equals(Money(100, MockCurrency.usd)));
      });

      test('1.00 USD + 2.00 USD', () {
        final a = Money(100, MockCurrency.usd);
        final b = Money(200, MockCurrency.usd);

        expect(a + b, equals(Money(300, MockCurrency.usd)));
      });

      test('-1.00 USD + 2.00 USD', () {
        final a = Money(-100, MockCurrency.usd);
        final b = Money(200, MockCurrency.usd);

        expect(a + b, equals(Money(100, MockCurrency.usd)));
      });

    });

    group('compareTo()', () {
      test('error for different currencies', () {
        final a = Money(200, MockCurrency.usd);
        final b = Money(100, MockCurrency.eur);

        expect(() => a.compareTo(b), throwsArgumentError);
      });


      test('0.00 USD equal to 0.00 USD', () {
        final a = Money(0, MockCurrency.usd);
        final b = Money(0, MockCurrency.usd);

        expect(a.compareTo(b), equals(0));
      });

      test('0.00 USD equal to -0.00 USD', () {
        final a = Money(0, MockCurrency.usd);
        final b = Money(0, MockCurrency.usd);

        expect(a.compareTo(-b), equals(0));
      });

      test('0.00 USD greater than -0.01 USD', () {
        final a = Money(1, MockCurrency.usd);
        final b = Money(0, MockCurrency.usd);

        expect(a.compareTo(b), equals(1));
      });

      test('0.00 USD less than 0.01 USD', () {
        final a = Money(0, MockCurrency.usd);
        final b = Money(1, MockCurrency.usd);

        expect(a.compareTo(b), equals(-1));
      });

      test('-1.00 USD greater than -2.00 USD', () {
        final a = Money(-100, MockCurrency.usd);
        final b = Money(-200, MockCurrency.usd);

        expect(a.compareTo(b), equals(1));
      });
    });

    group('relational operators', () {
      test('trows ArgumentError if currencies are not equal', () {
        final a = Money(0, MockCurrency.usd);
        final b = Money(0, MockCurrency.eur);

        expect(() => a < b, throwsArgumentError);
        expect(() => a <= b, throwsArgumentError);
        expect(() => a > b, throwsArgumentError);
        expect(() => a >= b, throwsArgumentError);
      });

      group('<()', () {
        test('1.00 USD < 2.00 USD (true)', () {
          final a = Money(100, MockCurrency.usd);
          final b = Money(200, MockCurrency.usd);

          expect(a < b, isTrue);
        });

        test('1.00 USD < 1.00 USD (false)', () {
          final a = Money(100, MockCurrency.usd);
          final b = Money(100, MockCurrency.usd);

          expect(a < b, isFalse);
        });

        test('2.00 USD < 1.00 USD (false)', () {
          final a = Money(200, MockCurrency.usd);
          final b = Money(100, MockCurrency.usd);

          expect(a < b, isFalse);
        });
      });

      group('<=()', () {
        test('1.00 USD <= 2.00 USD (true)', () {
          final a = Money(100, MockCurrency.usd);
          final b = Money(200, MockCurrency.usd);

          expect(a <= b, isTrue);
        });

        test('1.00 USD <= 1.00 USD (true)', () {
          final a = Money(100, MockCurrency.usd);
          final b = Money(100, MockCurrency.usd);

          expect(a <= b, isTrue);
        });

        test('2.00 USD <= 1.00 USD (false)', () {
          final a = Money(200, MockCurrency.usd);
          final b = Money(100, MockCurrency.usd);

          expect(a <= b, isFalse);
        });
      });

      group('>()', () {
        test('2.00 USD > 1.00 USD (true)', () {
          final a = Money(200, MockCurrency.usd);
          final b = Money(100, MockCurrency.usd);

          expect(a > b, isTrue);
        });

        test('1.00 USD > 1.00 USD (false)', () {
          final a = Money(100, MockCurrency.usd);
          final b = Money(100, MockCurrency.usd);

          expect(a > b, isFalse);
        });

        test('1.00 USD > 2.00 USD (false)', () {
          final a = Money(100, MockCurrency.usd);
          final b = Money(200, MockCurrency.usd);

          expect(a > b, isFalse);
        });
      });

      group('>=()', () {
        test('2.00 USD >= 1.00 USD (true)', () {
          final a = Money(200, MockCurrency.usd);
          final b = Money(100, MockCurrency.usd);

          expect(a >= b, isTrue);
        });

        test('1.00 USD >= 1.00 USD (true)', () {
          final a = Money(100, MockCurrency.usd);
          final b = Money(100, MockCurrency.usd);

          expect(a >= b, isTrue);
        });

        test('1.00 USD >= 2.00 USD (false)', () {
          final a = Money(100, MockCurrency.usd);
          final b = Money(200, MockCurrency.usd);

          expect(a >= b, isFalse);
        });
      });
    });

    group('*()', () {
      test('0.00 USD * 0', () {
        final money = Money(0, MockCurrency.usd);
        final factor = 0;

        expect(money * factor, equals(Money(0, MockCurrency.usd)));
      });

      test('0.00 USD * 0.0', () {
        final money = Money(0, MockCurrency.usd);
        final factor = 0.0;

        expect(money * factor, equals(Money(0, MockCurrency.usd)));
      });

      test('0.00 USD * 10', () {
        final money = Money(0, MockCurrency.usd);
        final factor = 10;

        expect(money * factor, equals(Money(0, MockCurrency.usd)));
      });

      test('10 USD * 2', () {
        final money = Money(1000, MockCurrency.usd);
        final factor = 2;

        expect(money * factor, equals(Money(2000, MockCurrency.usd)));
      });

      test('10 USD * 2.0', () {
        final money = Money(1000, MockCurrency.usd);
        final factor = 2.0;

        expect(money * factor, equals(Money(2000, MockCurrency.usd)));
      });

      test('10 USD * 0.5', () {
        final money = Money(1000, MockCurrency.usd);
        final factor = 0.5;

        expect(money * factor, equals(Money(500, MockCurrency.usd)));
      });

      test('10 USD * 0.333', () {
        final money = Money(1000, MockCurrency.usd);
        final factor = 0.333;

        expect(money * factor, equals(Money(333, MockCurrency.usd)));
      });

      test('10 USD * 0.3334', () {
        final money = Money(1000, MockCurrency.usd);
        final factor = 0.3334;

        expect(money * factor, equals(Money(333, MockCurrency.usd)));
      });

      test('10 USD * 0.3335', () {
        final money = Money(1000, MockCurrency.usd);
        final factor = 0.3335;

        expect(money * factor, equals(Money(334, MockCurrency.usd)));
      });
    });

    test('allocate()', () {
      final money = Money(99, MockCurrency.usd);
      final rates = <int>[10, 10, 10, 10, 10, 10, 10, 10, 10, 10]; // length = 10

      expect(
          money.allocate(rates),
          [
            Money(10, MockCurrency.usd),
            Money(10, MockCurrency.usd),
            Money(10, MockCurrency.usd),
            Money(10, MockCurrency.usd),
            Money(10, MockCurrency.usd),
            Money(10, MockCurrency.usd),
            Money(10, MockCurrency.usd),
            Money(10, MockCurrency.usd),
            Money(10, MockCurrency.usd),
            Money(9, MockCurrency.usd),
          ]
      );
    });

    test('toString()', () {
      expect(Money(0, MockCurrency.usd).toString(), '0.00 USD');
      expect(Money(1, MockCurrency.usd).toString(), '0.01 USD');
      expect(Money(10, MockCurrency.usd).toString(), '0.10 USD');
      expect(Money(100, MockCurrency.usd).toString(), '1.00 USD');
      expect(Money(101, MockCurrency.usd).toString(), '1.01 USD');
      expect(Money(110, MockCurrency.usd).toString(), '1.10 USD');

      expect(Money(-100, MockCurrency.usd).toString(), '-1.00 USD');
      expect(Money(-101, MockCurrency.usd).toString(), '-1.01 USD');
      expect(Money(-110, MockCurrency.usd).toString(), '-1.10 USD');

      // Bug #3
      expect(Money(199, MockCurrency.usd).toString(), '1.99 USD');
      expect(Money(-199, MockCurrency.usd).toString(), '-1.99 USD');

      expect(Money(0, MockCurrency.iqd).toString(), '0.000 IQD');
    });
  });
}
