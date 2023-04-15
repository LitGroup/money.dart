/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'dart:math';

import 'package:intl/intl.dart';

import 'encoders.dart';
import 'money.dart';
import 'money_data.dart';

/// Formats a monetary value to a String based on a pattern.
class PatternEncoder implements MoneyEncoder<String> {
  ///
  PatternEncoder(this.money, this.pattern);

  /// the amount to encode
  Money money;

  /// the pattern to encode to.
  String pattern;

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

    formatted = _formatMajorPart(data, majorPattern);
    if (hasMinor) {
      final minorPattern = pattern.substring(decimalSeparatorIndex + 1);
      final formattedMinorPart = _formatMinorPart(data, minorPattern);

      /// ensure we don't end up with a trailing decimal point.
      if (formattedMinorPart.isNotEmpty) {
        final numericMinorPart =
            formattedMinorPart.replaceAll(RegExp('[^0-9]'), '');
        final decimalSeparator =
            numericMinorPart.isNotEmpty ? data.currency.decimalSeparator : '';

        formatted += decimalSeparator + formattedMinorPart;
      }
    }

    return formatted;
  }

  /// Formats the major part of the [data].
  String _formatMajorPart(MoneyData data, final String majorPattern) {
    var formatted = '';

    // extract the contiguous money components made up of 0 # , and .
    final moneyPattern = _getMoneyPattern(majorPattern);
    _checkZeros(moneyPattern, data.currency.groupSeparator, minor: false);

    final integerPart = data.integerPart;

    final formattedMajorUnits =
        _getFormattedMajorUnits(data, moneyPattern, integerPart);

    // replace the the money components with a single #
    var compressedMajorPattern = _compressMoney(majorPattern);

    final code = _getCode(data, compressedMajorPattern);
    // replaces multiple C's with a single C
    compressedMajorPattern = _compressC(compressedMajorPattern);

    // checks we have only one S.
    _validateS(compressedMajorPattern);

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
  String _getFormattedMajorUnits(
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

    if (!majorUnits.isNegative && data.amount.isNegative) {
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
  String _getCode(MoneyData data, String pattern) {
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
  String _getMoneyPattern(String pattern) {
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

          _isMoneyAllowed(inMoney: inMoney, foundMoney: foundMoney, pos: i);
          moneyPattern += '#';
          break;
        case '0':
          _isMoneyAllowed(inMoney: inMoney, foundMoney: foundMoney, pos: i);
          moneyPattern += '0';
          inMoney = true;
          foundMoney = true;
          break;
        case ',':
          _isMoneyAllowed(inMoney: inMoney, foundMoney: foundMoney, pos: i);
          moneyPattern += ',';
          inMoney = true;
          foundMoney = true;

          break;
        case '.':
          _isMoneyAllowed(inMoney: inMoney, foundMoney: foundMoney, pos: i);
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
  String _formatMinorPart(MoneyData data, String minorPattern) {
    var formatted = '';

    final groupSeparator = data.currency.groupSeparator;

    // extract the contiguous money components made up of 0 # , and .
    var moneyPattern = _getMoneyPattern(minorPattern);

    /// check that the zeros are only at the end of the pattern.
    _checkZeros(moneyPattern, groupSeparator, minor: true);

    /// If there are trailing zeros in the pattern then we must ensure
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
    if (moneyPattern.length > data.amount.scale) {
      moneyPattern = moneyPattern.substring(0, data.amount.scale);
      // extendFormatWithZeros

    }

    final decimalPart = data.amount.decimalPart;

    // format the no. using the pattern.
    // In order for Number format to minor units
    // with proper 0s, we first add [minorDigitsFactor] and then strip the 1
    // after being formatted.
    //
    // e.g., using ## to format 1 would result in 1, but we want it
    // formatted as 01 because it is really the decimal part of the number.

    var formattedMinorUnits =
        NumberFormat(moneyPattern).format(decimalPart.toInt());

    /// If the we have a scale of 4 and minorunits = 10
    /// then the number format will produce 10 rather than 0010
    /// So we need to add leading zeros
    if (formattedMinorUnits.length < data.amount.scale) {
      final leadingZeros = data.amount.scale - formattedMinorUnits.length;
      formattedMinorUnits = '${'0' * leadingZeros}$formattedMinorUnits';
    }

    if (moneyPattern.length < formattedMinorUnits.length) {
      // money pattern is short, so we need to force a truncation as
      // NumberFormat doesn't know we are dealing with minor units.
      formattedMinorUnits =
          formattedMinorUnits.substring(0, moneyPattern.length);
    }

    // Fixed problems caused by passing a int to the NumberFormat
    // when we are trying to format a decimal.
    // Move leading zeros to the end when minor units >= 10 - i.e.
    // we want to keep the leading zeros for single digit cents.
    if (decimalPart.toInt() >= data.currency.scaleFactor.toInt()) {
      formatted = _invertZeros(formatted);
    }

    // If the no. of decimal digits contained in the minorunits
    // then we need to pad the result.
    if (formattedMinorUnits.length < moneyPattern.length) {
      formattedMinorUnits.padLeft(moneyPattern.length - formatted.length, '0');
    }
    // Add trailing zeros.
    if (extendFormatWithZeros != 0) {
      formattedMinorUnits =
          formattedMinorUnits.padRight(extendFormatWithZeros, '0');
    }

    if (requiredPatternWidth != 0) {
      formattedMinorUnits =
          formattedMinorUnits.padRight(requiredPatternWidth, '0');
    }

    // trim trailing zeros back to the [requiredPatternWidth]
    formattedMinorUnits =
        _trimExcessZeros(formattedMinorUnits, requiredPatternWidth);

    // replace the the money components with a single #
    var compressedMinorPattern = _compressMoney(minorPattern);

    final code = _getCode(data, compressedMinorPattern);
    // replaces multiple C's with a single S
    compressedMinorPattern = _compressC(compressedMinorPattern);

    // checks we have only one S.
    _validateS(minorPattern);

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
              'The minor part of the pattern contains an unexpected character: '
              "'$char'");
      }
    }

    return formatted;
  }

  ///
  void _isMoneyAllowed(
      {required bool inMoney, required bool foundMoney, required int pos}) {
    if (!inMoney && foundMoney) {
      throw IllegalPatternException('Found a 0 at location $pos. '
          'All money characters (0#,.)must be contiguous');
    }
  }

  /// Compresses multiple currency pattern characters 'CCC' into a single
  /// 'C'.
  String _compressC(final String majorPattern) {
    // replaced with a single C.
    final compressedMajorPattern = majorPattern.replaceAll(RegExp('[C]+'), 'C');

    if ('C'.allMatches(compressedMajorPattern).length > 1) {
      throw IllegalPatternException(
          "The pattern may only contain a single contigous group of 'C's");
    }
    return compressedMajorPattern;
  }

  ///
  void _validateS(String majorPattern) {
    // check for at most single S
    if ('S'.allMatches(majorPattern).length > 1) {
      throw IllegalPatternException(
          "The pattern may only contain a single 'S's");
    }
  }

  ///
  String _compressMoney(String majorPattern) =>
      majorPattern.replaceAll(RegExp(r'[#|0|,|\.]+'), '#');

  /// Check that Zeros are only at the end of the pattern unless we have group
  /// separators as there can then be a zero at the end of each segment.
  void _checkZeros(final String moneyPattern, final String groupSeparator,
      {required bool minor}) {
    if (!moneyPattern.contains('0')) {
      return;
    }

    final illegalPattern = IllegalPatternException(
        '''The '0' pattern characters must only be at the end of the pattern for ${minor ? 'Minor' : 'Major'} Units''');

    // compress zeros so we have only one which should be at the end,
    // unless we have group separators then we can have several 0s e.g. 0,0,0
    final comppressedMoneyPattern = moneyPattern.replaceAll(RegExp('0+'), '0');

    // last char must be a zero (i.e. group separater not allowed here)
    if (comppressedMoneyPattern[comppressedMoneyPattern.length - 1] != '0') {
      throw illegalPattern;
    }

    // check that zeros are the trailing character.
    // if the pattern has group separators then there can be more than one 0.
    var zerosEnded = false;
    final len = comppressedMoneyPattern.length - 1;
    for (var i = len; i > 0; i--) {
      final char = comppressedMoneyPattern[i];
      var isValid = char == '0';

      // when looking at the intial zeros a group separator
      // is consider  valid.
      if (!zerosEnded) {
        isValid &= char == groupSeparator;
      }

      if (isValid && zerosEnded) {
        throw illegalPattern;
      }
      if (!isValid) {
        zerosEnded = true;
      }
    }
  }

  /// move leading zeros to the end of the string.
  String _invertZeros(String formatted) {
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

  String _trimExcessZeros(
      String formattedMinorUnits, int requiredPatternWidth) {
    if (formattedMinorUnits.length <= requiredPatternWidth) {
      return formattedMinorUnits;
    }
    var toTrim = 0;

    for (var i = formattedMinorUnits.length - 1;
        i > requiredPatternWidth - 1;
        i--) {
      if (formattedMinorUnits.substring(i, i + 1) == '0') {
        toTrim++;
      } else {
        break;
      }
    }
    return formattedMinorUnits.substring(
        0, formattedMinorUnits.length - toTrim);
  }
}

/// Thrown when you pass an invalid pattern to [Money.format].
class IllegalPatternException implements MoneyException {
  ///
  IllegalPatternException(this.message);

  /// the error
  String message;

  @override
  String toString() => message;
}
