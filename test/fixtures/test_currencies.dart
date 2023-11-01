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

import 'dart:collection';

import 'package:money/money.dart' show Currencies, Currency, CurrencyCode;

class TestCurrencies extends Currencies {
  /// Russian ruble.
  static final rur = Currency(CurrencyCode('RUR'), precision: 2);

  /// United States dollar.
  static final usd = Currency(CurrencyCode('USD'), precision: 2);

  /// Euro.
  static final eur = Currency(CurrencyCode('EUR'), precision: 2);

  /// Japanese yen.
  static final jpy = Currency(CurrencyCode('JPY'), precision: 0);

  /// Bitcoin.
  static final btc = Currency(CurrencyCode('BTC'), precision: 8);

  /// Unknown currency; not included in the test currencies directory.
  static final unknown = Currency(CurrencyCode('UNKNOWN'), precision: 0);

  static List<Currency> asList() => List.of(_currencies, growable: false);

  static final List<Currency> _currencies = [
    TestCurrencies.rur,
    TestCurrencies.usd,
    TestCurrencies.eur,
    TestCurrencies.jpy,
    TestCurrencies.btc,
  ];

  TestCurrencies();

  @override
  Currency? findByCode(CurrencyCode code) =>
      _currencies.where((currency) => currency.code == code).firstOrNull;
}
