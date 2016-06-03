CHANGELOG
=========

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).


## [0.1.4] - 2016-06-03
### Changed
- [BC] `Money.==()` now receives `Object` instead of `Money` and checks runtime
  type of the argument, closes [#4](https://github.com/LitGroup/money.dart/issues/4).


## [0.1.3+2] - 2016-05-10
### Fixed
- Fixed invalid rounding of amount in `Money.toString()`, closes
  [#3](https://github.com/LitGroup/money.dart/issues/3).


## [0.1.3] - 2015-05-05
### Added
- Added `Money.fromDouble()` constructor.


## [0.1.2] - 2015-05-05
### Added
- Added getter `Money.amountAsString`.


## [0.1.1] - 2015-05-04
### Added
- Added `Money.fromString()` constructor.
- Added relational operators (`<`, `<=`, `>`, `>=`).


## [0.1.0+1] - 2015-05-01
### Fixed
- Fixes `README.md`.


## [0.1.0] - 2015-05-01
Initial version.
