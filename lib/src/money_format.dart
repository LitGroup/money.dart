/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 - 2019 LitGroup LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'dart:math';

import 'package:meta/meta.dart' show sealed, immutable;
import 'package:money/src/money.dart';

import 'currency.dart';

/// DTO for exchange of data between an instance of [Money] and [MoneyEncoder]
/// or [MoneyDecoder].
@sealed
@immutable
class MoneyData {
  /// Amount of money in the smallest units (like cent for USD).
  final BigInt subunits;

  /// The currency of the subunits.
  final Currency currency;

  MoneyData.from(this.subunits, this.currency) {
    if (subunits == null) {
      throw ArgumentError.notNull('subunits');
    }
    if (currency == null) {
      throw ArgumentError.notNull('currency');
    }
  }
}

abstract class MoneyEncoder<T> {
  /// Returns encoded representation of money data.
  T encode(MoneyData data);
}

abstract class MoneyDecoder<T> {
  /// Returns decoded [MoneyData] or throws a [FormatException].
  MoneyData decode(T encoded);
}

class PatternEncoder implements MoneyEncoder<String> {
  Money money;
  String pattern;
  String sign;

  PatternEncoder(this.money, this.pattern, this.sign);

  @override
  String encode(MoneyData data) {
    String formatted = "";
    int indexC = 0;

    String major =
        (data.subunits ~/ BigInt.from(pow(10, data.currency.precision)))
            .toString();
    String minor =
        (data.subunits % BigInt.from(pow(10, data.currency.precision)))
            .toString();

    String partSource = major;
    bool inMajor = true;
    int partIndex = 0;

    int majorDigits = countMajorPatternDigits(pattern);
    int minorDigits = countMinorPatternDigits(pattern);

    int partDigits = majorDigits;

    String code = data.currency.code;

    for (int i = 0; i < pattern.length; i++) {
      var char = pattern[i];
      switch (char) {
        case 'S':
          formatted += sign;
          break;
        case 'C':
          formatted += code[indexC % 3];
          indexC++;
          break;
        case '#':
          formatted += partSource[partIndex++];
          break;
        case '0':
          //if (partIndex > partDigits )
          // throw IllegalPatternException("")
          if (inMajor) {
            if (partDigits - partIndex > partSource.length) {
              formatted += '0';
            } else {
              formatted += partSource[partIndex++];
            }
          } else {
            if (partIndex >= partSource.length) {
              formatted += '0';
            } else {
              formatted += partSource[partIndex++];
            }
          }
          break;
        case ',':
          formatted += ",";
          break;
        case '.':
          formatted += ".";
          inMajor = false;
          partSource = minor;
          partIndex = 0;
          partDigits = minorDigits;
          break;
        case ' ':
          formatted += ' ';
          break;
        default:
          throw IllegalPatternException(
              "The pattern contains an unknown character: '$char'");
      }
    }
    return formatted;
  }

  // counts the no. of # and 0s in the pattern before the '.'.
  int countMajorPatternDigits(String pattern) {
    int count = 0;
    for (int i = 0; i < pattern.length; i++) {
      var char = pattern[i];
      if (char == '.') {
        break;
      }

      if (char == '#' || char == '0') {
        count++;
      }
    }
    return count;
  }

  // counts the no. of # and 0s in the pattern before the '.'.
  int countMinorPatternDigits(String pattern) {
    int count = 0;
    bool foundPeriod = false;

    for (int i = 0; i < pattern.length; i++) {
      var char = pattern[i];
      if (char == '.') {
        foundPeriod = true;
      }

      if (!foundPeriod) {
        continue;
      }

      if (char == '#' || char == '0') {
        count++;
      }
    }
    return count;
  }
}
