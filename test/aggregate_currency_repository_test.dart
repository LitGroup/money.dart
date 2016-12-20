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

import "package:mockito/mockito.dart";
import "package:test/test.dart";

import "package:money/money.dart"
    show AggregateCurrencyRepository, CurrencyRepository, Currency, UnknownCurrencyException;

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

const code = "USD";
const anotherCode = "EUR";

final currency = new Currency(code);
final anotherCurrency = new Currency(anotherCode);

void main() {
  group("AggregateCurrencyRepository", () {

    MockCurrencyRepository repository;
    MockCurrencyRepository anotherRepository;

    AggregateCurrencyRepository aggregate;

    setUp(() {
      repository = new MockCurrencyRepository();
      anotherRepository = new MockCurrencyRepository();
      aggregate = new AggregateCurrencyRepository([
        repository,
        anotherRepository
      ]);
    });

    test("is a currency repository", () {
      expect(aggregate, const isInstanceOf<CurrencyRepository>());
    });

    test("throws an error when list of repositories is empty during instantiation", () {
      expect(() => new AggregateCurrencyRepository([]), throwsArgumentError);
    });

    test("provides list of all currencies in the aggregatet repositories", () {
      when(repository.allCurrencies()).thenReturn(<Currency>[currency]);
      when(anotherRepository.allCurrencies()).thenReturn(<Currency>[anotherCurrency]);

      expect(aggregate.allCurrencies(), equals(<Currency>[currency, anotherCurrency]));
    });

    test("finds currency by code", () {
      when(repository.containsCurrencyOf(code)).thenReturn(true);
      when(repository.containsCurrencyOf(anotherCode)).thenReturn(false);
      when(repository.currencyOf(code)).thenReturn(currency);
      when(repository.currencyOf(anotherCode)).thenThrow(new UnknownCurrencyException(anotherCode));

      when(anotherRepository.containsCurrencyOf(code)).thenReturn(false);
      when(anotherRepository.containsCurrencyOf(anotherCode)).thenReturn(true);
      when(anotherRepository.currencyOf(code)).thenThrow(new UnknownCurrencyException(code));
      when(anotherRepository.currencyOf(anotherCode)).thenReturn(anotherCurrency);

      expect(aggregate.currencyOf(code), equals(currency));
      expect(aggregate.currencyOf(anotherCode), equals(anotherCurrency));
    });

    test("throws an exception when currency with some code cannot be found", () {
      when(repository.containsCurrencyOf(code)).thenReturn(false);
      when(anotherRepository.containsCurrencyOf(code)).thenReturn(false);
      when(repository.currencyOf(code)).thenThrow(new UnknownCurrencyException(code));
      when(anotherRepository.currencyOf(code)).thenThrow(new UnknownCurrencyException(code));

      expect(() => aggregate.currencyOf(code), throwsA(const isInstanceOf<UnknownCurrencyException>()));
    });

    test("checks that any of repositories contains currency", () {
      when(repository.containsCurrency(currency)).thenReturn(true);
      when(anotherRepository.containsCurrency(currency)).thenReturn(false);
      expect(aggregate.containsCurrency(currency), isTrue);

      when(repository.containsCurrency(currency)).thenReturn(false);
      when(anotherRepository.containsCurrency(currency)).thenReturn(true);
      expect(aggregate.containsCurrency(currency), isTrue);

      when(repository.containsCurrency(currency)).thenReturn(false);
      when(anotherRepository.containsCurrency(currency)).thenReturn(false);
      expect(aggregate.containsCurrency(currency), isFalse);
    });

    test("checks that any of repositories contains currency with a given code", () {
      when(repository.containsCurrencyOf(code)).thenReturn(true);
      when(anotherRepository.containsCurrencyOf(code)).thenReturn(false);
      expect(aggregate.containsCurrencyOf(code), isTrue);

      when(repository.containsCurrencyOf(code)).thenReturn(false);
      when(anotherRepository.containsCurrencyOf(code)).thenReturn(true);
      expect(aggregate.containsCurrencyOf(code), isTrue);

      when(repository.containsCurrencyOf(code)).thenReturn(false);
      when(anotherRepository.containsCurrencyOf(code)).thenReturn(false);
      expect(aggregate.containsCurrencyOf(code), isFalse);
    });
  });
}