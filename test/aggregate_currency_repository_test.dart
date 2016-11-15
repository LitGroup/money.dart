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
      when(repository.findAll()).thenReturn(<Currency>[currency]);
      when(anotherRepository.findAll()).thenReturn(<Currency>[anotherCurrency]);

      expect(aggregate.findAll(), equals(<Currency>[currency, anotherCurrency]));
    });

    test("finds currency by code", () {
      when(repository.containsWithCode(code)).thenReturn(true);
      when(repository.containsWithCode(anotherCode)).thenReturn(false);
      when(repository.find(code)).thenReturn(currency);
      when(repository.find(anotherCode)).thenThrow(new UnknownCurrencyException(anotherCode));

      when(anotherRepository.containsWithCode(code)).thenReturn(false);
      when(anotherRepository.containsWithCode(anotherCode)).thenReturn(true);
      when(anotherRepository.find(code)).thenThrow(new UnknownCurrencyException(code));
      when(anotherRepository.find(anotherCode)).thenReturn(anotherCurrency);

      expect(aggregate.find(code), equals(currency));
      expect(aggregate.find(anotherCode), equals(anotherCurrency));
    });

    test("throws an exception when currency with some code cannot be found", () {
      when(repository.containsWithCode(code)).thenReturn(false);
      when(anotherRepository.containsWithCode(code)).thenReturn(false);
      when(repository.find(code)).thenThrow(new UnknownCurrencyException(code));
      when(anotherRepository.find(code)).thenThrow(new UnknownCurrencyException(code));

      expect(() => aggregate.find(code), throwsA(const isInstanceOf<UnknownCurrencyException>()));
    });

    test("checks that any of repositories contains currency", () {
      when(repository.contains(currency)).thenReturn(true);
      when(anotherRepository.contains(currency)).thenReturn(false);
      expect(aggregate.contains(currency), isTrue);

      when(repository.contains(currency)).thenReturn(false);
      when(anotherRepository.contains(currency)).thenReturn(true);
      expect(aggregate.contains(currency), isTrue);

      when(repository.contains(currency)).thenReturn(false);
      when(anotherRepository.contains(currency)).thenReturn(false);
      expect(aggregate.contains(currency), isFalse);
    });

    test("checks that any of repositories contains currency with a given code", () {
      when(repository.containsWithCode(code)).thenReturn(true);
      when(anotherRepository.containsWithCode(code)).thenReturn(false);
      expect(aggregate.containsWithCode(code), isTrue);

      when(repository.containsWithCode(code)).thenReturn(false);
      when(anotherRepository.containsWithCode(code)).thenReturn(true);
      expect(aggregate.containsWithCode(code), isTrue);

      when(repository.containsWithCode(code)).thenReturn(false);
      when(anotherRepository.containsWithCode(code)).thenReturn(false);
      expect(aggregate.containsWithCode(code), isFalse);
    });
  });
}