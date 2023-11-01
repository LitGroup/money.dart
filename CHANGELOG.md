## Unreleased

## 1.0.0-alpha.1

> **This release was made from scratch and provides API incompatible with `0.2.1`.**

## 0.2.1
 
- Fixes comparison of `0` and `-0` amount in a browser.

## 0.2.0

- Code was migrated to Dart 2.0. No API changes.

## 0.1.6

- Fixed wrong parsing from string when integer part of amount is `0`.

## 0.1.5

- Class `Currency` is not abstract from now on.
- Fixes `Money.hashCode`; it now relates on `amount` and `currency` (Issue #1).


## 0.1.4

- (BC) `Money.==()` now receives `Object` instead of `Money` and checks runtime
  type of the argument, closes [#4](https://github.com/LitGroup/money.dart/issues/4).


## 0.1.3+2

- Fixed invalid rounding of amount in `Money.toString()`, closes
  [#3](https://github.com/LitGroup/money.dart/issues/3).


## 0.1.3

- Added `Money.fromDouble()` constructor.


## 0.1.2

- Added getter `Money.amountAsString`.


## 0.1.1

- Added `Money.fromString()` constructor.
- Added relational operators (`<`, `<=`, `>`, `>=`).


## 0.1.0+1

- Fixes `README.md`.


## 0.1.0

Initial version.
