# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project adheres to [Semantic Versioning](http://semver.org/).

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
