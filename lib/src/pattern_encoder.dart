import 'dart:math';

import 'package:intl/intl.dart';

import 'encoders.dart';
import 'money.dart';
import 'money_data.dart';

/// Encodes a monetary value based on a pattern.
class PatternEncoder implements MoneyEncoder<String> {
  /// the amount to encode
  Money money;

  /// the pattern to encode to.
  String pattern;

  ///
  PatternEncoder(
    this.money,
    this.pattern,
  );

  @override
  String encode(MoneyData data) {
    String formatted;

    final decimalSeperatorCount =
        data.currency.decimalSeparator.allMatches(pattern).length;

    if (decimalSeperatorCount > 1) {
      throw IllegalPatternException(
          'A format Pattern may contain, at most, a single decimal '
          "separator '${data.currency.decimalSeparator}'");
    }

    var decimalSeparatorIndex = pattern.indexOf(data.currency.decimalSeparator);

    var hasMinor = true;
    if (decimalSeparatorIndex == -1) {
      decimalSeparatorIndex = pattern.length;
      hasMinor = false;
    }

    final majorPattern = pattern.substring(0, decimalSeparatorIndex);

    formatted = formatMajorPart(data, majorPattern);
    if (hasMinor) {
      final minorPattern = pattern.substring(decimalSeparatorIndex + 1);
      formatted +=
          data.currency.decimalSeparator + formatMinorPart(data, minorPattern);
    }

    return formatted;
  }

  /// Formats the major part of the [data].
  String formatMajorPart(MoneyData data, final String majorPattern) {
    var formatted = '';

    // extract the contiguous money components made up of 0 # , and .
    final moneyPattern = getMoneyPattern(majorPattern);
    checkZeros(moneyPattern, data.currency.thousandSeparator, minor: false);

    final majorUnits = data.getMajorUnits();

    final formattedMajorUnits =
        getFormattedMajorUnits(data, moneyPattern, majorUnits);

    // replace the the money components with a single #
    var compressedMajorPattern = compressMoney(majorPattern);

    final code = getCode(data, compressedMajorPattern);
    // replaces multiple C's with a single C
    compressedMajorPattern = compressC(compressedMajorPattern);

    // checks we have only one S.
    validateS(compressedMajorPattern);

    // Replace the compressed patterns with actual values.
    // The periods and commas have already been removed from the pattern.
    for (var i = 0; i < compressedMajorPattern.length; i++) {
      final char = compressedMajorPattern[i];
      switch (char) {
        case 'S':
          formatted += data.currency.symbol;
          break;
        case 'C':
          formatted += code;
          break;
        case '#':
          formatted += formattedMajorUnits;
          break;
        case ' ':
          formatted += ' ';
          break;
        case '0':
        case ',':
        case '.':
        default:
          throw IllegalPatternException(
              "The pattern contains an unknown character: '$char'");
      }
    }

    return formatted;
  }

  ///
  String getFormattedMajorUnits(
      MoneyData data, final String moneyPattern, BigInt majorUnits) {
    String normalisedMoneyPattern;
    if (data.currency.invertSeparators) {
      // the NumberFormat doesn't like the inverted characters
      // so we normalise them for the conversion.
      normalisedMoneyPattern = moneyPattern.replaceAll('.', ',');
    } else {
      normalisedMoneyPattern = moneyPattern;
    }
    // format the no. into that pattern.
    var formattedMajorUnits =
        NumberFormat(normalisedMoneyPattern).format(majorUnits.toInt());

    if (!majorUnits.isNegative && data.minorUnits.isNegative) {
      formattedMajorUnits = '-$formattedMajorUnits';
    }

    if (data.currency.invertSeparators) {
      // Now convert them back
      formattedMajorUnits = formattedMajorUnits.replaceAll(',', '.');
    }
    return formattedMajorUnits;
  }

  /// returns the currency code from [data] using the
  /// supplied [pattern] to find the code.
  String getCode(MoneyData data, String pattern) {
    // find the contigous 'C'
    final codeLength = 'C'.allMatches(pattern).length;

    // get the code based on the no. of C's.
    String code;
    if (codeLength == 3) {
      // Three Cs means the whole code.
      code = data.currency.code;
    } else {
      code = data.currency.code
          .substring(0, min(codeLength, data.currency.code.length));
    }
    return code;
  }

  /// Just extract the number specific format chacters leaving out
  /// currency and symbols
  /// MinorUnits use trailing zeros, MajorUnits use leading zeros.
  String getMoneyPattern(String pattern) {
    var foundMoney = false;
    var inMoney = false;
    var moneyPattern = '';
    for (var i = 0; i < pattern.length; i++) {
      final char = pattern[i];
      switch (char) {
        case 'S':
          inMoney = false;
          break;
        case 'C':
          inMoney = false;
          break;
        case '#':
          inMoney = true;
          foundMoney = true;

          isMoneyAllowed(inMoney: inMoney, foundMoney: foundMoney, pos: i);
          moneyPattern += '#';
          break;
        case '0':
          isMoneyAllowed(inMoney: inMoney, foundMoney: foundMoney, pos: i);
          moneyPattern += '0';
          inMoney = true;
          foundMoney = true;
          break;
        case ',':
          isMoneyAllowed(inMoney: inMoney, foundMoney: foundMoney, pos: i);
          moneyPattern += ',';
          inMoney = true;
          foundMoney = true;

          break;
        case '.':
          isMoneyAllowed(inMoney: inMoney, foundMoney: foundMoney, pos: i);
          moneyPattern += '.';
          inMoney = true;
          foundMoney = true;

          break;
        case ' ':
          inMoney = false;
          break;
        default:
          throw IllegalPatternException(
              "The pattern contains an unknown character: '$char'");
      }
    }
    return moneyPattern;
  }

  ///
  String formatMinorPart(MoneyData data, String minorPattern) {
    var formatted = '';

    // extract the contiguous money components made up of 0 # , and .
    var moneyPattern = getMoneyPattern(minorPattern);

    /// check that the zeros are only at is at the end of the pattern.
    checkZeros(moneyPattern, data.currency.thousandSeparator, minor: true);

    /// If there are trailing zeros then we must ensure
    /// the final string is at least [requiredPatternWidth] or if
    /// its not then we pad with zeros.
    var requiredPatternWidth = 0;
    final firstZero = moneyPattern.indexOf('0');
    if (firstZero != -1) {
      requiredPatternWidth = moneyPattern.length;
    }

    /// If the pattern is longer than the minor digits we need to clip the
    /// pattern and add trailing zeros back at the end.
    const extendFormatWithZeros = 0;
    if (moneyPattern.length > data.currency.precision) {
      moneyPattern = moneyPattern.substring(0, data.currency.precision);
      // extendFormatWithZeros

    }

    final minorUnits = data.getMinorUnits();

    // format the no. into that pattern.
    // in order for Number format to format single digit minor unit properly
    // with proper 0s, we first add [minorDigitsFactor] and then strip the 1
    // after being formatted.
    //
    // e.g., using ## to format 1 would result in 1, but we want it
    // formatted as 01 because it is really the decimal part of the number.

    var formattedMinorUnits = NumberFormat(moneyPattern)
        .format((minorUnits + data.currency.precisionFactor).toInt())
        .substring(1);

    if (moneyPattern.length < formattedMinorUnits.length) {
      // money pattern is short, so we need to force a truncation as
      // NumberFormat doesn't know we are dealing with minor units.
      formattedMinorUnits =
          formattedMinorUnits.substring(0, moneyPattern.length);
    }

    /// If we have a minor digits of 4 and minorunits = 10
    /// then the number format will produce 10 rather than 0010
    /// So we need to add leading zeros
    //if ()

    // Fixed problems caused by passing a int to the NumberFormat
    // when we are trying to format a decimal.
    // Move leading zeros to the end when minor units >= 10 - i.e.,
    // we want to keep the leading zeros for single digit cents.
    if (minorUnits.toInt() >= data.currency.precisionFactor.toInt()) {
      formatted = invertZeros(formatted);
    }

    // If the no. of decimal digits contained in the minorunits
    // then we need to pad the result.
    if (formattedMinorUnits.length < moneyPattern.length) {
      formattedMinorUnits.padLeft(moneyPattern.length - formatted.length, '0');
    }
    // Add trailing zeros.

    if (requiredPatternWidth != 0) {
      formattedMinorUnits = formattedMinorUnits.padRight(requiredPatternWidth, '0');
    }

    if (extendFormatWithZeros != 0) {
      formattedMinorUnits = formattedMinorUnits.padRight(extendFormatWithZeros, '0');
    }

    // replace the the money components with a single #
    var compressedMinorPattern = compressMoney(minorPattern);

    final code = getCode(data, compressedMinorPattern);
    // replaces multiple C's with a single S
    compressedMinorPattern = compressC(compressedMinorPattern);

    // checks we have only one S.
    validateS(minorPattern);

    // expand the pattern
    for (var i = 0; i < compressedMinorPattern.length; i++) {
      final char = compressedMinorPattern[i];
      switch (char) {
        case 'S':
          formatted += data.currency.symbol;
          break;
        case 'C':
          formatted += code;
          break;
        case '#':
          formatted += formattedMinorUnits;
          break;
        case ' ':
          formatted += ' ';
          break;
        case '0':
        case ',':
        case '.':
        default:
          throw IllegalPatternException(
              "The minor part of the pattern contains an unexpected character: '$char'");
      }
    }

    return formatted;
  }

  /// counts the no. of # and 0s in the pattern before the decimal seperator.
  int countMajorPatternDigits(String pattern, String decimalSeparator) {
    var count = 0;
    for (var i = 0; i < pattern.length; i++) {
      final char = pattern[i];
      if (char == decimalSeparator) {
        break;
      }

      if (char == '#' || char == '0') {
        count++;
      }
    }
    return count;
  }

  /// counts the no. of # and 0s in the pattern before the decimal separator.
  int countMinorPatternDigits(String pattern, String decimalSeparator) {
    var count = 0;
    var foundDecimalSeparator = false;

    for (var i = 0; i < pattern.length; i++) {
      final char = pattern[i];
      if (char == decimalSeparator) {
        foundDecimalSeparator = true;
      }

      if (!foundDecimalSeparator) {
        continue;
      }

      if (char == '#' || char == '0') {
        count++;
      }
    }
    return count;
  }

  ///
  void isMoneyAllowed(
      {required bool inMoney, required bool foundMoney, required int pos}) {
    if (!inMoney && foundMoney) {
      throw IllegalPatternException('Found a 0 at location $pos. '
          'All money characters (0#,.)must be contiguous');
    }
  }

  /// Compresses multiple currency pattern characters 'CCC' into a single
  /// 'C'.
  String compressC(final String majorPattern) {
    // replaced with a single C.
    final compressedMajorPattern = majorPattern.replaceAll(RegExp('[C]+'), 'C');

    if ('C'.allMatches(compressedMajorPattern).length > 1) {
      throw IllegalPatternException(
          "The pattern may only contain a single contigous group of 'C's");
    }
    return compressedMajorPattern;
  }

  ///
  void validateS(String majorPattern) {
    // check for at most single S
    if ('S'.allMatches(majorPattern).length > 1) {
      throw IllegalPatternException(
          "The pattern may only contain a single 'S's");
    }
  }

  ///
  String compressMoney(String majorPattern) {
    return majorPattern.replaceAll(RegExp(r'[#|0|,|\.]+'), '#');
  }

  /// Check that Zeros are only at the end of the pattern unless we have thousand separators as there
  /// can then be a zero at the end of each segment.
  void checkZeros(final String moneyPattern, final String thousandSeparator,
      {required bool minor}) {
    if (!moneyPattern.contains('0')) return;

    final illegalPattern = IllegalPatternException(
        '''The '0' pattern characters must only be at the end of the pattern for ${minor ? 'Minor' : 'Major'} Units''');

    // compress zeros so we have only one which should be at the end,
    // unless we have thousand separators then we can have several 0s e.g. 0,0,0
    final comppressedMoneyPattern = moneyPattern.replaceAll(RegExp('0+'), '0');

    // last char must be a zero (i.e. thousand separater not allowed here)
    if (comppressedMoneyPattern[comppressedMoneyPattern.length - 1] != '0') {
      throw illegalPattern;
    }

    // check that zeros are the trailing character.
    // if the pattern has thousand separators then there can be more than one 0.
    var zerosEnded = false;
    final len = comppressedMoneyPattern.length - 1;
    for (var i = len; i > 0; i--) {
      final char = comppressedMoneyPattern[i];
      var isValid = char == '0';

      // when looking at the intial zeros a thousand separator
      // is consider  valid.
      if (!zerosEnded) isValid &= char == thousandSeparator;

      if (isValid && zerosEnded) {
        throw illegalPattern;
      }
      if (!isValid) zerosEnded = true;
    }
  }

  /// move leading zeros to the end of the string.
  String invertZeros(String formatted) {
    var trailingZeros = '';
    var result = '';
    for (var i = 0; i < formatted.length; i++) {
      final char = formatted[i];

      if (char == '0' && result.isEmpty) {
        trailingZeros += '0';
      } else {
        result += char;
      }
    }
    return result + trailingZeros;
  }
}

/// Thrown when you pass an invalid pattern to [Money.format].
class IllegalPatternException implements Exception {
  /// the error
  String message;

  ///
  IllegalPatternException(this.message);

  @override
  String toString() => message;
}
