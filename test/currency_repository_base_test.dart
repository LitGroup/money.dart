// The MIT License (MIT)
//
// Copyright (c) 2015 - 2016 Roman Shamritskiy
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import "package:test/test.dart";

import "package:money/money.dart"
    show CurrencyRepository, CurrencyRepositoryBase, Currency, UnknownCurrencyException;

final code = "USD";
final anotherCode = "RUB";

final currency = new Currency(code);
final anotherCurrency = new Currency(anotherCode);

final notInRepoCode = "EUR";
final notInRepoCurrency = new Currency("EUR");

class TestCurrencyRepository extends CurrencyRepositoryBase {
  @override
  List<Currency> allCurrencies() {
    return <Currency>[
      currency,
      anotherCurrency
    ];
  }
}

void main() {
  group("CurrencyRepositoryBase", () {
    CurrencyRepositoryBase repository;

    setUp(() {
      repository = new TestCurrencyRepository();
    });

    test("is a currency repository", () {
      expect(repository, const isInstanceOf<CurrencyRepository>());
    });

    test("fiends currency by its code", () {
      expect(repository.currencyOf(code), equals(currency));
      expect(repository.currencyOf(anotherCode), equals(anotherCurrency));
    });

    test("throws an exception when currency cannot be found by a given code", () {
      expect(() => repository.currencyOf(notInRepoCode),
          throwsA(const isInstanceOf<UnknownCurrencyException>()));
    });

    test("checks whether a currency is available in this repository", () {
      expect(repository.containsCurrency(currency), isTrue);
      expect(repository.containsCurrency(anotherCurrency), isTrue);
      expect(repository.containsCurrency(notInRepoCurrency), isFalse);
    });

    test("checks whether a currency with a given code is in this repository", () {
      expect(repository.containsCurrencyOf(code), isTrue);
      expect(repository.containsCurrencyOf(anotherCode), isTrue);
      expect(repository.containsCurrencyOf(notInRepoCode), isFalse);
    });
  });
}