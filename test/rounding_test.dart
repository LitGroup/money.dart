@Timeout(Duration(minutes: 15))
/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2021  Noojee IT Pty Ltd
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  final usd = Currency.create('USD', 2);

  test('Rounding', () {
    expect(Money.from(69.99, usd).minorUnits.toInt(), 6999);
    expect(Money.from(10.00, usd).minorUnits.toInt(), 1000);

    expect(Money.from(10.0000001, usd).minorUnits.toInt(), 1000);
    expect(Money.from(10.004, usd).minorUnits.toInt(), 1000);
    expect(Money.from(10.005, usd).minorUnits.toInt(), 1001);

    expect(Money.from(29.99, usd).minorUnits.toInt(), 2999);
  });
}
