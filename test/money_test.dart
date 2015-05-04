// Copyright (c) 2015, the package authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

library money.test.money;

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
    test('new Money()', () {
      final money = new Money(100, MockCurrency.usd);
      
      expect(money.amount, equals(100));
      expect(money.currency, same(MockCurrency.usd));
    });

    group('new Money.fromString()', () {
      test('for "120" and USD currency', () {
        final money = new Money.fromString('120', MockCurrency.usd);

        expect(money.amount, 12000);
        expect(money.currency, MockCurrency.usd);
      });

      test('for "120.00" and USD currency', () {
        final money = new Money.fromString('120.00', MockCurrency.usd);

        expect(money.amount, 12000);
        expect(money.currency, MockCurrency.usd);
      });

      test('for "120.10" and USD currency', () {
        final money = new Money.fromString('120.10', MockCurrency.usd);

        expect(money.amount, 12010);
        expect(money.currency, MockCurrency.usd);
      });

      test('for "-120.00" and USD currency', () {
        final money = new Money.fromString('-120.00', MockCurrency.usd);

        expect(money.amount, -12000);
        expect(money.currency, MockCurrency.usd);
      });

      test('for "-120.10" and USD currency', () {
        final money = new Money.fromString('-120.10', MockCurrency.usd);

        expect(money.amount, -12010);
        expect(money.currency, MockCurrency.usd);
      });

      test('for "120.010" and IQD currency', () {
        final money = new Money.fromString('120.010', MockCurrency.iqd);

        expect(money.amount, 120010);
        expect(money.currency, MockCurrency.iqd);
      });

      test('throws FormatException for "120.00" and IQD currency (3 fraction digits should be)', () {
        expect(
          () => new Money.fromString('120.00', MockCurrency.iqd),
          throwsA(const isInstanceOf<FormatException>())
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
          expect(() => new Money.fromString(value, MockCurrency.usd), throwsA(const isInstanceOf<FormatException>()));
        }
      });
    });
    
    group('==()', () {
      test('the same amount and currencies', () {
        final money1 = new Money(1000, MockCurrency.usd);
        final money2 = new Money(1000, MockCurrency.usd);
        
        expect(money1 == money2, isTrue);
        expect(money1.hashCode == money2.hashCode, isTrue);
      });
      
      test('the same currency but different amounts', () {
        final money1 = new Money(1000, MockCurrency.usd);
        final money2 = new Money(2000, MockCurrency.usd);
        
        expect(money1 == money2, isFalse);
        expect(money1.hashCode == money2.hashCode, isFalse);
      });
      
      test('the same amount but different currencies', () {
        final money1 = new Money(1000, MockCurrency.usd);
        final money2 = new Money(1000, MockCurrency.eur);
        
        expect(money1 == money2, isFalse);
      });
      
      test('different amounts and currencies', () {
        final money1 = new Money(0, MockCurrency.usd);
        final money2 = new Money(1000, MockCurrency.eur);
        
        expect(money1 == money2, isFalse);
      });
    });
    
    group('unary -()', () {
      test('amount is zero', () {
        final money = new Money(0, MockCurrency.usd);
        
        expect(-money, equals(new Money(0, MockCurrency.usd)));
      });
      
      test('positive amount', () {
        final money = new Money(100, MockCurrency.usd);
        
        expect(-money, equals(new Money(-100, MockCurrency.usd)));
      });
      
      test('negative amount', () {
        final money = new Money(-100, MockCurrency.usd);
        
        expect(-money, new Money(100, MockCurrency.usd));
      });
    });
    
    group('-()', () {
      test('error for different currencies', () {
        final minuend = new Money(100, MockCurrency.usd);
        final subtrahend = new Money(100, MockCurrency.eur);

        expect(() => minuend - subtrahend, throwsArgumentError);
      });

      test('0.00 USD - 0.00 USD', () {
        final a = new Money(0, MockCurrency.usd);
        final b = new Money(0, MockCurrency.usd);

        expect(a - b, equals(new Money(0, MockCurrency.usd)));
      });

      test('0.00 USD - 1.00 USD', () {
        final a = new Money(0, MockCurrency.usd);
        final b = new Money(100, MockCurrency.usd);

        expect(a - b, equals(new Money(-100, MockCurrency.usd)));
      });

      test('2.00 USD - 1.00 USD', () {
        final a = new Money(200, MockCurrency.usd);
        final b = new Money(100, MockCurrency.usd);

        expect(a - b, equals(new Money(100, MockCurrency.usd)));
      });

      test('-2.00 USD - 1.00 USD', () {
        final a = new Money(-200, MockCurrency.usd);
        final b = new Money(100, MockCurrency.usd);

        expect(a - b, equals(new Money(-300, MockCurrency.usd)));
      });
    });

    group('+()', () {
      test('error for different currencies', () {
        final a = new Money(100, MockCurrency.usd);
        final b = new Money(100, MockCurrency.eur);

        expect(() => a + b, throwsArgumentError);
      });

      test('0.00 USD + 0.00 USD', () {
        final a = new Money(0, MockCurrency.usd);
        final b = new Money(0, MockCurrency.usd);

        expect(a + b, equals(new Money(0, MockCurrency.usd)));
      });

      test('0.00 USD + 1.00 USD', () {
        final a = new Money(0, MockCurrency.usd);
        final b = new Money(100, MockCurrency.usd);

        expect(a + b, equals(new Money(100, MockCurrency.usd)));
      });

      test('1.00 USD + 0.00 USD', () {
        final a = new Money(100, MockCurrency.usd);
        final b = new Money(0, MockCurrency.usd);

        expect(a + b, equals(new Money(100, MockCurrency.usd)));
      });

      test('1.00 USD + 2.00 USD', () {
        final a = new Money(100, MockCurrency.usd);
        final b = new Money(200, MockCurrency.usd);

        expect(a + b, equals(new Money(300, MockCurrency.usd)));
      });

      test('-1.00 USD + 2.00 USD', () {
        final a = new Money(-100, MockCurrency.usd);
        final b = new Money(200, MockCurrency.usd);

        expect(a + b, equals(new Money(100, MockCurrency.usd)));
      });

    });

    group('compareTo()', () {
      test('error for different currencies', () {
        final a = new Money(200, MockCurrency.usd);
        final b = new Money(100, MockCurrency.eur);

        expect(() => a.compareTo(b), throwsArgumentError);
      });


      test('0.00 USD equal to 0.00 USD', () {
        final a = new Money(0, MockCurrency.usd);
        final b = new Money(0, MockCurrency.usd);

        expect(a.compareTo(b), equals(0));
      });

      test('0.00 USD equal to -0.00 USD', () {
        final a = new Money(0, MockCurrency.usd);
        final b = new Money(0, MockCurrency.usd);

        expect(a.compareTo(-b), equals(0));
      });

      test('0.00 USD greater than -0.01 USD', () {
        final a = new Money(1, MockCurrency.usd);
        final b = new Money(0, MockCurrency.usd);

        expect(a.compareTo(b), equals(1));
      });

      test('0.00 USD less than 0.01 USD', () {
        final a = new Money(0, MockCurrency.usd);
        final b = new Money(1, MockCurrency.usd);

        expect(a.compareTo(b), equals(-1));
      });

      test('-1.00 USD greater than -2.00 USD', () {
        final a = new Money(-100, MockCurrency.usd);
        final b = new Money(-200, MockCurrency.usd);

        expect(a.compareTo(b), equals(1));
      });
    });

    group('relational operators', () {
      test('trows ArgumentError if currencies are not equal', () {
        final a = new Money(0, MockCurrency.usd);
        final b = new Money(0, MockCurrency.eur);

        expect(() => a < b, throwsArgumentError);
        expect(() => a <= b, throwsArgumentError);
        expect(() => a > b, throwsArgumentError);
        expect(() => a >= b, throwsArgumentError);
      });

      group('<()', () {
        test('1.00 USD < 2.00 USD (true)', () {
          final a = new Money(100, MockCurrency.usd);
          final b = new Money(200, MockCurrency.usd);

          expect(a < b, isTrue);
        });

        test('1.00 USD < 1.00 USD (false)', () {
          final a = new Money(100, MockCurrency.usd);
          final b = new Money(100, MockCurrency.usd);

          expect(a < b, isFalse);
        });

        test('2.00 USD < 1.00 USD (false)', () {
          final a = new Money(200, MockCurrency.usd);
          final b = new Money(100, MockCurrency.usd);

          expect(a < b, isFalse);
        });
      });

      group('<=()', () {
        test('1.00 USD <= 2.00 USD (true)', () {
          final a = new Money(100, MockCurrency.usd);
          final b = new Money(200, MockCurrency.usd);

          expect(a <= b, isTrue);
        });

        test('1.00 USD <= 1.00 USD (true)', () {
          final a = new Money(100, MockCurrency.usd);
          final b = new Money(100, MockCurrency.usd);

          expect(a <= b, isTrue);
        });

        test('2.00 USD <= 1.00 USD (false)', () {
          final a = new Money(200, MockCurrency.usd);
          final b = new Money(100, MockCurrency.usd);

          expect(a <= b, isFalse);
        });
      });

      group('>()', () {
        test('2.00 USD > 1.00 USD (true)', () {
          final a = new Money(200, MockCurrency.usd);
          final b = new Money(100, MockCurrency.usd);

          expect(a > b, isTrue);
        });

        test('1.00 USD > 1.00 USD (false)', () {
          final a = new Money(100, MockCurrency.usd);
          final b = new Money(100, MockCurrency.usd);

          expect(a > b, isFalse);
        });

        test('1.00 USD > 2.00 USD (false)', () {
          final a = new Money(100, MockCurrency.usd);
          final b = new Money(200, MockCurrency.usd);

          expect(a > b, isFalse);
        });
      });

      group('>=()', () {
        test('2.00 USD >= 1.00 USD (true)', () {
          final a = new Money(200, MockCurrency.usd);
          final b = new Money(100, MockCurrency.usd);

          expect(a >= b, isTrue);
        });

        test('1.00 USD >= 1.00 USD (true)', () {
          final a = new Money(100, MockCurrency.usd);
          final b = new Money(100, MockCurrency.usd);

          expect(a >= b, isTrue);
        });

        test('1.00 USD >= 2.00 USD (false)', () {
          final a = new Money(100, MockCurrency.usd);
          final b = new Money(200, MockCurrency.usd);

          expect(a >= b, isFalse);
        });
      });
    });

    group('*()', () {
      test('0.00 USD * 0', () {
        final money = new Money(0, MockCurrency.usd);
        final factor = 0;

        expect(money * factor, equals(new Money(0, MockCurrency.usd)));
      });

      test('0.00 USD * 0.0', () {
        final money = new Money(0, MockCurrency.usd);
        final factor = 0.0;

        expect(money * factor, equals(new Money(0, MockCurrency.usd)));
      });

      test('0.00 USD * 10', () {
        final money = new Money(0, MockCurrency.usd);
        final factor = 10;

        expect(money * factor, equals(new Money(0, MockCurrency.usd)));
      });

      test('10 USD * 2', () {
        final money = new Money(1000, MockCurrency.usd);
        final factor = 2;

        expect(money * factor, equals(new Money(2000, MockCurrency.usd)));
      });

      test('10 USD * 2.0', () {
        final money = new Money(1000, MockCurrency.usd);
        final factor = 2.0;

        expect(money * factor, equals(new Money(2000, MockCurrency.usd)));
      });

      test('10 USD * 0.5', () {
        final money = new Money(1000, MockCurrency.usd);
        final factor = 0.5;

        expect(money * factor, equals(new Money(500, MockCurrency.usd)));
      });

      test('10 USD * 0.333', () {
        final money = new Money(1000, MockCurrency.usd);
        final factor = 0.333;

        expect(money * factor, equals(new Money(333, MockCurrency.usd)));
      });

      test('10 USD * 0.3334', () {
        final money = new Money(1000, MockCurrency.usd);
        final factor = 0.3334;

        expect(money * factor, equals(new Money(333, MockCurrency.usd)));
      });

      test('10 USD * 0.3335', () {
        final money = new Money(1000, MockCurrency.usd);
        final factor = 0.3335;

        expect(money * factor, equals(new Money(334, MockCurrency.usd)));
      });
    });

    test('allocate()', () {
      final money = new Money(99, MockCurrency.usd);
      final rates = <int>[10, 10, 10, 10, 10, 10, 10, 10, 10, 10]; // length = 10

      expect(
          money.allocate(rates),
          [
            new Money(10, MockCurrency.usd),
            new Money(10, MockCurrency.usd),
            new Money(10, MockCurrency.usd),
            new Money(10, MockCurrency.usd),
            new Money(10, MockCurrency.usd),
            new Money(10, MockCurrency.usd),
            new Money(10, MockCurrency.usd),
            new Money(10, MockCurrency.usd),
            new Money(10, MockCurrency.usd),
            new Money(9, MockCurrency.usd),
          ]
      );
    });

    test('toString()', () {
      expect(new Money(0, MockCurrency.usd).toString(), '0.00 USD');
      expect(new Money(1, MockCurrency.usd).toString(), '0.01 USD');
      expect(new Money(10, MockCurrency.usd).toString(), '0.10 USD');
      expect(new Money(100, MockCurrency.usd).toString(), '1.00 USD');
      expect(new Money(101, MockCurrency.usd).toString(), '1.01 USD');
      expect(new Money(110, MockCurrency.usd).toString(), '1.10 USD');
      expect(new Money(-100, MockCurrency.usd).toString(), '-1.00 USD');
      
      expect(new Money(0, MockCurrency.iqd).toString(), '0.000 IQD');
      expect(new Money(1, MockCurrency.iqd).toString(), '0.001 IQD');
      expect(new Money(10, MockCurrency.iqd).toString(), '0.010 IQD');
      expect(new Money(100, MockCurrency.iqd).toString(), '0.100 IQD');
      expect(new Money(1000, MockCurrency.iqd).toString(), '1.000 IQD');
      expect(new Money(1001, MockCurrency.iqd).toString(), '1.001 IQD');
      expect(new Money(1110, MockCurrency.iqd).toString(), '1.110 IQD');
      expect(new Money(-1000, MockCurrency.iqd).toString(), '-1.000 IQD');
    });
  });
}