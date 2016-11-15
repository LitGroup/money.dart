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

part of money;

/// Interface for repository of currencies.
///
/// Implement this interface to provide set of currencies to your application.
abstract class CurrencyRepository {
  /// Returns a currency with a specified [code].
  ///
  /// Throws a [UnknownCurrencyException] if this repository does not
  /// contain a currency with a specified code.
  Currency find(String code);

  /// Returns list with all currencies in this repository.
  List<Currency> findAll();

  /// Checks whether a [currency] is available in this repository.
  bool contains(Currency currency);

  /// Checks whether a currency with [code] is available in this repository.
  bool containsWithCode(String code);
}

class UnknownCurrencyException implements Exception {
  final String unknownCurrencyCode;

  UnknownCurrencyException(this.unknownCurrencyCode);

  @override
  String toString() =>
      'UnknownCurrencyException: Unknown currency "$unknownCurrencyCode".';
}

/// Base class for implementing [CurrencyRepository].
///
/// This class implements all methods of [CurrencyRepository]
/// except of [findAll].
abstract class CurrencyRepositoryBase implements CurrencyRepository {
  @override
  Currency find(String code) {
    return findAll().firstWhere((c) => c.code == code,
        orElse: () => throw new UnknownCurrencyException(code));
  }

  @override
  bool containsWithCode(String code) {
    return findAll().where((c) => c.code == code).isNotEmpty;
  }

  @override
  bool contains(Currency currency) {
    return findAll().contains(currency);
  }
}

/// Aggregates several currency repositories.
class AggregateCurrencyRepository implements CurrencyRepository {
  final List<CurrencyRepository> _repositories;

  AggregateCurrencyRepository(Iterable<CurrencyRepository> repositories)
      : _repositories = repositories.toList(growable: false) {
    if (_repositories.isEmpty) {
      throw new ArgumentError("List of repositories cannot be empty.");
    }
  }

  @override
  Currency find(String code) {
    for (final repository in _repositories) {
      if (repository.containsWithCode(code)) {
        return repository.find(code);
      }
    }

    throw new UnknownCurrencyException(code);
  }

  @override
  bool containsWithCode(String code) {
    for (final repository in _repositories) {
      if (repository.containsWithCode(code)) {
        return true;
      }
    }

    return false;
  }

  @override
  bool contains(Currency currency) {
    for (final repository in _repositories) {
      if (repository.contains(currency)) {
        return true;
      }
    }

    return false;
  }

  @override
  List<Currency> findAll() {
    final result = <Currency>[];
    for (final repository in _repositories) {
      result.addAll(repository.findAll());
    }

    return result.toList(growable: false);
  }
}
