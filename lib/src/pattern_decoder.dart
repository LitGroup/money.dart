import 'currency.dart';
import 'encoders.dart';
import 'money.dart';
import 'money_data.dart';

class PatternDecoder implements MoneyDecoder<String> {
  Currency currency;
  String pattern;

  PatternDecoder(
    this.currency,
    this.pattern,
  ) {
    ArgumentError.checkNotNull(currency, "currency");
    ArgumentError.checkNotNull(pattern, "pattern");
  }

  MoneyData decode(String monetaryValue) {
    BigInt majorUnits = BigInt.zero;
    BigInt minorUnits = BigInt.zero;

    String code = currency.code;

    pattern = compressDigits(pattern);
    int codeIndex = 0;

    bool seenMajor = false;

    ValueQueue valueQueue =
        ValueQueue(monetaryValue, currency.thousandSeparator);

    for (int i = 0; i < pattern.length; i++) {
      switch (pattern[i]) {
        case 'S':
          String char = valueQueue.takeOne();
          if (char != currency.symbol) {
            throw MoneyParseException.fromValue(
                pattern, i, monetaryValue, valueQueue.index);
          }

          break;
        case 'C':
          if (codeIndex >= code.length) {
            throw MoneyParseException(
                "The pattern has more currency code 'C' characters ($codeIndex + 1) than the length of the passed currency.");
          }
          String char = valueQueue.takeOne();
          if (char != code[codeIndex]) {
            throw MoneyParseException.fromValue(
                pattern, i, monetaryValue, valueQueue.index);
          }
          codeIndex++;
          break;
        case "#":
          if (seenMajor) {
            minorUnits = valueQueue.takeDigits();
          } else {
            majorUnits = valueQueue.takeDigits();
          }
          break;
        case '.':
          String char = valueQueue.takeOne();
          if (char != currency.decimalSeparator) {
            throw MoneyParseException.fromValue(
                pattern, i, monetaryValue, valueQueue.index);
          }
          seenMajor = true;
          break;
        default:
          throw MoneyParseException(
              "Invalid character '${pattern[i]}' found in pattern.");
      }
    }

    BigInt value = currency.toMinorUnits(majorUnits, minorUnits);
    MoneyData result = MoneyData.from(value, currency);
    return result;
  }

  //
  // Compresses all 0 # , . characters into a single #.#
  //
  String compressDigits(String pattern) {
    String decimalSeparator = currency.decimalSeparator;
    String thousandsSeparator = currency.thousandSeparator;

    String result = "";

    String regExPattern =
        "([#|0|${thousandsSeparator}]+)${decimalSeparator}([#|0]+)";

    RegExp regEx = RegExp(regExPattern);

    var matches = regEx.allMatches(pattern);

    if (matches.isEmpty) {
      throw MoneyParseException(
          "The pattern did not contain a valid pattern such as '0.00'");
    }

    if (matches.length != 1) {
      throw MoneyParseException(
          "The pattern contained more than one numberic pattern. Check you don't have spaces in the numeric parts of the pattern.");
    }

    Match match = matches.first;

    if (match.group(0) != null && match.group(1) != null) {
      result = pattern.replaceFirst(regEx, "#.#");
      // result += "#";
    } else if (match.group(0) != null) {
      result = pattern.replaceFirst(regEx, "#");
    } else if (match.group(1) != null) {
      result = pattern.replaceFirst(regEx, ".#");
      // result += ".#";
    }
    return result;
  }
}

class ValueQueue {
  String monetaryValue;
  int index = 0;
  String thousandsSeparator;

  String lastTake;

  ValueQueue(this.monetaryValue, this.thousandsSeparator);

  String takeOne() {
    lastTake = this.monetaryValue[index++];

    return lastTake;
  }

  BigInt takeDigits() {
    String digits = ""; //  = lastTake;

    while (index < monetaryValue.length &&
        (isDigit(this.monetaryValue[index]) ||
            this.monetaryValue[index] == thousandsSeparator)) {
      if (this.monetaryValue[index] != thousandsSeparator) {
        digits += this.monetaryValue[index];
      }
      index++;
    }

    if (digits.isEmpty) {
      throw MoneyParseException(
          "Character '${monetaryValue[index]}' at pos $index is not a digit when a digit was expected");
    }
    return BigInt.parse(digits);
  }

  bool isDigit(String char) {
    return RegExp(r'[0123456789]').hasMatch(char);
  }
}
