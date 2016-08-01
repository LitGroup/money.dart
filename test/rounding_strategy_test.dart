// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>

// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

import 'package:test/test.dart';
import 'package:money/money.dart' show RoundingStrategy;
import 'dart:mirrors';

void main() {
  group('RoundingStrategy', () {
    test('is enum', () {
      expect(reflectClass(RoundingStrategy).isEnum, isTrue);
    });

    test('has value "halfUp"', () {
      expect(RoundingStrategy.halfUp, const isInstanceOf<RoundingStrategy>());
    });

    test('has value "halfUp"', () {
      expect(RoundingStrategy.halfDown, const isInstanceOf<RoundingStrategy>());
    });

    test('has value "halfEve"', () {
      expect(RoundingStrategy.halfEve, const isInstanceOf<RoundingStrategy>());
    });

    test('has value "halfOdd"', () {
      expect(RoundingStrategy.halfOdd, const isInstanceOf<RoundingStrategy>());
    });

    test('has value "up"', () {
      expect(RoundingStrategy.up, const isInstanceOf<RoundingStrategy>());
    });

    test('has value "up"', () {
      expect(RoundingStrategy.down, const isInstanceOf<RoundingStrategy>());
    });

    test('has value "halfPositiveInf"', () {
      expect(RoundingStrategy.halfPositiveInf, const isInstanceOf<RoundingStrategy>());
    });

    test('has value "halfNegativeInf"', () {
      expect(RoundingStrategy.halfNegativeInf, const isInstanceOf<RoundingStrategy>());
    });
  });
}