@Timeout(Duration(minutes: 15))
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  final usd = Currency.create('USD', 2);

  test('Rounding', () {
    expect(Money.fromNumWithCurrency(69.99, usd).minorUnits.toInt(), 6999);
    expect(Money.fromNumWithCurrency(10.00, usd).minorUnits.toInt(), 1000);

    expect(Money.fromNumWithCurrency(10.0000001, usd).minorUnits.toInt(), 1000);
    expect(Money.fromNumWithCurrency(10.004, usd).minorUnits.toInt(), 1000);
    expect(Money.fromNumWithCurrency(10.005, usd).minorUnits.toInt(), 1001);

    expect(Money.fromNumWithCurrency(29.99, usd).minorUnits.toInt(), 2999);
  });
}
