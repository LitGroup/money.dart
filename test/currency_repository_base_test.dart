import "package:test/test.dart";

import "package:money/money.dart"
    show CurrencyRepository, CurrencyRepositoryBase, Currency, CurrencyNotFoundException;

final code = "USD";
final anotherCode = "RUB";

final currency = new Currency(code);
final anotherCurrency = new Currency(anotherCode);

final notInRepoCode = "EUR";
final notInRepoCurrency = new Currency("EUR");

class TestCurrencyRepository extends CurrencyRepositoryBase {
  @override
  List<Currency> findAll() {
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

    test("is a subtype of CurrencyRepository", () {
      expect(repository, const isInstanceOf<CurrencyRepository>());
    });

    test("fiends currency by its code", () {
      expect(repository.find(code), equals(currency));
      expect(repository.find(anotherCode), equals(anotherCurrency));
    });

    test("throws an exception when currency cannot be found by a given code", () {
      expect(() => repository.find(notInRepoCode),
          throwsA(const isInstanceOf<CurrencyNotFoundException>()));
    });

    test("checks whether a currency is available in this repository", () {
      expect(repository.contains(currency), isTrue);
      expect(repository.contains(anotherCurrency), isTrue);
      expect(repository.contains(notInRepoCurrency), isFalse);
    });

    test("checks whether a currency with a given code is in this repository", () {
      expect(repository.containsWithCode(code), isTrue);
      expect(repository.containsWithCode(anotherCode), isTrue);
      expect(repository.containsWithCode(notInRepoCode), isFalse);
    });
  });
}