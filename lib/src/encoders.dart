import 'dart:math';

import 'package:intl/intl.dart';

import 'money.dart';
import 'money_data.dart';

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

  PatternEncoder(
    this.money,
    this.pattern,
  ) {
    assert(money != null);
    assert(pattern != null);
  }

  @override
  String encode(MoneyData data) {
    String formatted;

    int decimalSeperatorCount =
        data.currency.decimalSeparator.allMatches(pattern).length;

    if (decimalSeperatorCount > 1) {
      throw IllegalPatternException(
          "A format Pattern may contain, at most, a single decimal separator '${data.currency.decimalSeparator}'");
    }

    int decimalSeparatorIndex = pattern.indexOf(data.currency.decimalSeparator);

    bool hasMinor = true;
    if (decimalSeparatorIndex == -1) {
      decimalSeparatorIndex = pattern.length;
      hasMinor = false;
    }

    String majorPattern = pattern.substring(0, decimalSeparatorIndex);

    formatted = formatMajorPart(data, majorPattern);
    if (hasMinor) {
      String minorPattern = pattern.substring(decimalSeparatorIndex + 1);
      formatted +=
          data.currency.decimalSeparator + formatMinorPart(data, minorPattern);
    }

    return formatted;
  }

  String formatMajorPart(MoneyData data, String majorPattern) {
    String formatted = "";

    // extract the contiguous money components made up of 0 # , and .
    String moneyPattern = getMoneyPattern(majorPattern);
    checkZeros(moneyPattern, data.currency.thousandSeparator, minor: false);

    BigInt majorUnits = data.getMajorUnits();

    String formattedMajorUnits = getFormattedMajorUnits(data, moneyPattern, majorUnits);

    // replace the the money components with a single #
    majorPattern = compressMoney(majorPattern);

    String code = getCode(data, majorPattern);
    // replaces multiple C's with a single S
    majorPattern = compressC(majorPattern);

    // checks we have only one S.
    validateS(majorPattern);

    // Replace the compressed patterns with actual values.
    // The periods and commas have already been removed from the pattern.
    for (int i = 0; i < majorPattern.length; i++) {
      var char = majorPattern[i];
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

  String getFormattedMajorUnits(MoneyData data, String moneyPattern, BigInt majorUnits) {
    if (data.currency.invertSeparators) {
      // the NumberFormat doesn't like the inverted characters
      // so we normalise them for the conversion.
      moneyPattern = moneyPattern.replaceAll(".", ",");
    }
    // format the no. into that pattern.
    String formattedMajorUnits =
        NumberFormat(moneyPattern).format(majorUnits.toInt());
    
    if (data.currency.invertSeparators) {
      // Now convert them back
      formattedMajorUnits = formattedMajorUnits.replaceAll(",", ".");
    }
    return formattedMajorUnits;
  }

  String getCode(MoneyData data, String pattern) {
    // find the contigous 'C'
    int codeLength = 'C'.allMatches(pattern).length;

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

// MinorUnits use trailing zeros, MajorUnits use leading zeros.
  String getMoneyPattern(String pattern) {
    bool foundMoney = false;
    bool inMoney = false;
    String moneyPattern = "";
    for (int i = 0; i < pattern.length; i++) {
      String char = pattern[i];
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

          isMoneyAllowed(inMoney, foundMoney, i);
          moneyPattern += '#';
          break;
        case '0':
          isMoneyAllowed(inMoney, foundMoney, i);
          moneyPattern += '0';
          inMoney = true;
          foundMoney = true;
          break;
        case ',':
          isMoneyAllowed(inMoney, foundMoney, i);
          moneyPattern += ',';
          inMoney = true;
          foundMoney = true;

          break;
        case '.':
          isMoneyAllowed(inMoney, foundMoney, i);
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

  String formatMinorPart(MoneyData data, String minorPattern) {
    String formatted = "";
    // extract the contiguous money components made up of 0 # , and .
    String moneyPattern = getMoneyPattern(minorPattern);

    checkZeros(moneyPattern, data.currency.thousandSeparator, minor: true);

    int paddedTo = 0;
    int firstZero = moneyPattern.indexOf('0');
    if (firstZero != -1) {
      paddedTo = moneyPattern.length;
    }

    BigInt minorUnits = data.getMinorUnits();
    // format the no. into that pattern.
    String formattedMinorUnits =
        NumberFormat(moneyPattern).format(minorUnits.toInt());
    if (moneyPattern.length < formattedMinorUnits.length) {
      // money pattern is short, so we need to force a truncation as NumberFormat doesn't
      // know we are dealing with minor units.
      formattedMinorUnits =
          formattedMinorUnits.substring(0, moneyPattern.length);
    }

    // replace the the money components with a single #
    minorPattern = compressMoney(minorPattern);

    String code = getCode(data, minorPattern);
    // replaces multiple C's with a single S
    minorPattern = compressC(minorPattern);

    // checks we have only one S.
    validateS(minorPattern);

    // expand the pattern
    for (int i = 0; i < minorPattern.length; i++) {
      var char = minorPattern[i];
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
        case '0':
        case ',':
        case '.':
        default:
          throw IllegalPatternException(
              "The pattern contains an unknown character: '$char'");
      }
    }

    // Fixed problems caused by passing a int to the NumberFormat when we are trying to format a decimal.
    // Move leading zeros to the end.
    formatted = invertZeros(formatted);
    // Add trailing zeros.

    if (paddedTo != 0) formatted = formatted.padRight(paddedTo, '0');

    return formatted;
  }

  // counts the no. of # and 0s in the pattern before the decimal seperator.
  int countMajorPatternDigits(String pattern, String decimalSeparator) {
    int count = 0;
    for (int i = 0; i < pattern.length; i++) {
      var char = pattern[i];
      if (char == decimalSeparator) {
        break;
      }

      if (char == '#' || char == '0') {
        count++;
      }
    }
    return count;
  }

  // counts the no. of # and 0s in the pattern before the decimal separator.
  int countMinorPatternDigits(String pattern, String decimalSeparator) {
    int count = 0;
    bool foundDecimalSeparator = false;

    for (int i = 0; i < pattern.length; i++) {
      var char = pattern[i];
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

  void isMoneyAllowed(bool inMoney, bool foundMoney, int pos) {
    if (!inMoney && foundMoney) {
      throw IllegalPatternException(
          "Found a 0 at location $pos. All money characters (0#,.)must be contiguous");
    }
  }

  String compressC(String majorPattern) {
    // replaced with a single C.
    majorPattern = majorPattern.replaceAll(RegExp(r'[C]+'), 'C');

    if ('C'.allMatches(majorPattern).length > 1) {
      throw IllegalPatternException(
          "The pattern may only contain a single contigous group of 'C's");
    }
    return majorPattern;
  }

  void validateS(String majorPattern) {
    // check for at most single S
    if ('S'.allMatches(majorPattern).length > 1) {
      throw IllegalPatternException(
          "The pattern may only contain a single 'S's");
    }
  }

  String compressMoney(String majorPattern) {
    return majorPattern.replaceAll(RegExp(r'[#|0|,|\.]+'), "#");
  }

  void checkZeros(String moneyPattern, String thousandSeparator, {bool minor}) {
    if (!moneyPattern.contains("0")) return;

    // compress zeros so we have only one which should be at the end,
    // unless we have thousand separators then we can have several 0s e.g. 0,0,0
    moneyPattern = moneyPattern.replaceAll(RegExp(r'0+'), "0");

    // check that zeros are the trailing character.
    // if the pattern has thousand separators then there can be more than one 0.
    bool expectingZero = true;
    int len = moneyPattern.length - 1;
    for (int i = len; i > 0; i--) {
      String char = moneyPattern[i];
      bool isValid = (char == '0' || char == thousandSeparator);
      if (isValid && !expectingZero) {
        throw IllegalPatternException(
            "The '0' pattern characters must only be at the end of the pattern for " +
                (minor ? "Minor" : "Major") +
                " Units");
      }
      if (!isValid) expectingZero = false;
    }
  }

  // move leading zeros to the end of the string.
  String invertZeros(String formatted) {
    String trailingZeros = "";
    String result = "";
    for (int i = 0; i < formatted.length; i++) {
      String char = formatted[i];

      if (char == '0' && result.isEmpty) {
        trailingZeros += '0';
      } else {
        result += char;
      }
    }
    return result + trailingZeros;
  }
}
