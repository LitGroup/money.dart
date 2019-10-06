# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project adheres to [Semantic Versioning](http://semver.org/).

## version: 1.2.0
Deprecated 'fromString' methods in favour of 'parse' method name. This was done to bring the library 
in line with the likes of BigInt.parse.

### Added
New 'Money.from(num)' method to support creating money from int's and doubles.
New Unit tests for Money.from and the new parse methods.

### Deprecated
Money.fromString - use Money.parse
Currency.fromString - use Currency.parse
Currencies.fromString - use Currencies.parse

## version: 1.1.1
Minor documenation cleanups.

## version: 1.1.0
Change the API of Currencies. Its now a singleton so usage changes from:
Currencies().register() to Currencies.register().

### Added
New methods to parse a monetary value from a String including:
Money.frommString
Currency.fromString
Currencies.fromString

New method to convert a [Money] of one currency to another currency
via the [Money.exchangeTo] method.

New examples and unit tests for the above methods.


## version: 1.0.7
2nd Attempt to improve the description displayed on pub.dev.

## version: 1.0.6
Attempt to improve the description displayed on pub.dev.

## version: 1.0.5
Formatting of examples as the pub.dev site clips wide lines.

## version: 1.0.4
Improved the examples.

## version: 1.0.3
Changed readme sample to the more familar usd. 

### Added
Examples of registry usage.  
Additional unit tests.

## version: 1.0.2
tweaks to the doco, some additional unit tests. Improved the trailing zero logic.

## version: 1.0.1
Improvemenst to the dartdoc.

## version: 1.0.0
First release version

### Updated
Readme to document invertedSeparators and general improvments corrections.

### Added
Added a couple additional examples.
InvertedSeparator argument to Currency.create
Additional unit test for the InvertedSeparator option.

## version: 1.0.0-beta.6
Minor cleanups of the readme.md

## version: 1.0.0-beta.5
Updated the name of example.dart to please google package gods.

## version: 1.0.0-beta.4
Update to please the google package gods.

### Added
- longer description
- fixed to broken annotations.

## version: 1.0.0-beta.3
Updated the description.

### Removed
- Dependency on `meta ^1.1.7`.
### Updated
- Dependancy on `intl: ^0.16.0`.

## 1.0.0-beta.1 - 2019-9-26
### Added
- Dependency on `meta ^1.1.7`.
- Dependancy on `intl: ^0.15.8`.
- Annotations `@immutable` and `@sealed` to `Money`, `Currency`, `MoneyData`.
- Added new format method on Money class to allow simply formating of amounts.
- Modified the API to make it easier to follow.
- Change the Currencies class to a factory and renamed methods to 'register' and 'registerList'.
- Chaneged ctor for Money from withBigInt to fromBigInt
- Added ctor for Money 'fromInt'
- Added strong mode to the analyzer.
- Renamed a number of classes for clarity.
- Added unit tests for the new formatter.
- Updated the readme.md for clarity and the details on the new formatter.
- Removed the aggregated currency interface as couldn't see that it added significant value.

## 1.0.0-alpha.1 - 2019-04-09
> **This release was made from scratch and provides API incompatible with `0.2.1`.**

### Added
- `Currency` value-type.
- The interface `Currencies` for representation of currency directories.
- Implementation of currencies which can be initialized by any `Iterable<Currency>`
(see the factory `Currencies.from(Iterable<Currency>)`).
- Aggregating `Currencies` implementation (see the factory
`Currencies.aggregating(Iterable<Currencies>)`).
- Adds `Money` value-type:
    - amount predicates: `.isZero`, `.isPositive`, `.isNegative`;
    - currency predicates `.isInCurrency(Currency)`, `.isInSameCurrencyAs(Money)`;
    - comparison operators: `==`, `<`, `<=`, `>`, `>=`;
    - conformance to `Comparable<Money>`;
    - arithmetic operators (`+(Money)`, `-(Money)`, `*(num)`, `/(num)`);
    - allocation according to ratios with `.allocationAccordingTo(List<int>)`;
    - allocation to _N_ targets with `.allocationTo(int)`;
    - `.encodedBy(MoneyDecoder)`;
    - `Money.decoding(MoneyEncoder)`.
- Interface `MoneyEncoder`.
- Interface `MoneyDecoder`.
- `MoneyData` — DTO for encoding/decoding.

## 0.2.1 - 2018-08-21
### Fixed
- Fixes comparison of `0` and `-0` amount in a browser.

## 0.2.0 - 2018-08-17
### Changed
- Code was migrated to Dart 2.0. No API changes.

## 0.1.6 - 2017-02-24
### Fixed
- Fixed wrong parsing from string when integer part of amount is `0`.

## 0.1.5 - 2016-07-06
### Changed
- Class `Currency` is not abstract from now on.

### Fixed
- `Money.hashCode` now relates on `amount` and `currency` (Issue #1).


## 0.1.4 - 2016-06-03
### Changed
- [BC] `Money.==()` now receives `Object` instead of `Money` and checks runtime
  type of the argument, closes [#4](https://github.com/LitGroup/money.dart/issues/4).


## 0.1.3+2 - 2016-05-10
### Fixed
- Fixed invalid rounding of amount in `Money.toString()`, closes
  [#3](https://github.com/LitGroup/money.dart/issues/3).


## 0.1.3 - 2015-05-05
### Added
- Added `Money.fromDouble()` constructor.


## 0.1.2 - 2015-05-05
### Added
- Added getter `Money.amountAsString`.


## 0.1.1 - 2015-05-04
### Added
- Added `Money.fromString()` constructor.
- Added relational operators (`<`, `<=`, `>`, `>=`).


## 0.1.0+1 - 2015-05-01
### Fixed
- Fixes `README.md`.


## [0.1.0] - 2015-05-01
Initial version.
