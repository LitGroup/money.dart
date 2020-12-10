import 'currency.dart';
import 'encoders.dart';
import 'money.dart';
import 'money_data.dart';

/// Decodes a monetary amount based on a pattern.
class PatternDecoder implements MoneyDecoder<String> {
  /// the currency we discovered
  final Currency currency;

  /// the pattern used to decode the amount.
  final String pattern;

  /// ctor
  PatternDecoder(
    this.currency,
    this.pattern,
  ) {
    ArgumentError.checkNotNull(currency, 'currency');
    ArgumentError.checkNotNull(pattern, 'pattern');
  }

  @override
  MoneyData decode(final String monetaryValue) {
    final negativeOne = BigInt.from(-1);
    var majorUnits = BigInt.zero;
    var minorUnits = BigInt.zero;

    final code = currency.code;

    var compressedPattern = compressDigits(pattern);
    compressedPattern = compressWhitespace(compressedPattern);
    final compressedMonetaryValue = compressWhitespace(monetaryValue);
    var codeIndex = 0;

    var isNegative = false;
    var seenMajor = false;

    final valueQueue =
        ValueQueue(compressedMonetaryValue, currency.thousandSeparator);

    for (var i = 0; i < compressedPattern.length; i++) {
      switch (compressedPattern[i]) {
        case 'S':
          final char = valueQueue.takeOne();
          if (char != currency.symbol) {
            throw MoneyParseException.fromValue(compressedPattern, i,
                compressedMonetaryValue, valueQueue.index);
          }

          break;
        case 'C':
          if (codeIndex >= code.length) {
            throw MoneyParseException(
                'The pattern has more currency code "C" characters '
                '($codeIndex + 1) than the length of the passed currency.');
          }
          final char = valueQueue.takeOne();
          if (char != code[codeIndex]) {
            throw MoneyParseException.fromValue(compressedPattern, i,
                compressedMonetaryValue, valueQueue.index);
          }
          codeIndex++;
          break;
        case '#':
          if (!seenMajor) {
            final char = valueQueue.peek();
            if (char == '-') {
              valueQueue.takeOne();
              isNegative = true;
            }
          }
          if (seenMajor) {
            minorUnits = valueQueue.takeDigits();
          } else {
            majorUnits = valueQueue.takeDigits();
          }
          break;
        case '.':
          final char = valueQueue.takeOne();
          if (char != currency.decimalSeparator) {
            throw MoneyParseException.fromValue(compressedPattern, i,
                compressedMonetaryValue, valueQueue.index);
          }
          seenMajor = true;
          break;
        case ' ':
          break;
        default:
          throw MoneyParseException(
              'Invalid character "${compressedPattern[i]}" found in pattern.');
      }
    }

    if (isNegative) {
      majorUnits = majorUnits * negativeOne;
      minorUnits = minorUnits * negativeOne;
    }

    final value = currency.toMinorUnits(majorUnits, minorUnits);
    final result = MoneyData.from(value, currency);
    return result;
  }

  ///
  /// Compresses all 0 # , . characters into a single #.#
  ///
  String compressDigits(String pattern) {
    final decimalSeparator = currency.decimalSeparator;
    final thousandsSeparator = currency.thousandSeparator;

    var result = '';

    final regExPattern =
        '([#|0|$thousandsSeparator]+)$decimalSeparator([#|0]+)';

    final regEx = RegExp(regExPattern);

    final matches = regEx.allMatches(pattern);

    if (matches.isEmpty) {
      throw MoneyParseException(
          'The pattern did not contain a valid pattern such as "0.00"');
    }

    if (matches.length != 1) {
      throw MoneyParseException(
          'The pattern contained more than one numberic pattern.'
          " Check you don't have spaces in the numeric parts of the pattern.");
    }

    final Match match = matches.first;

    if (match.group(0) != null && match.group(1) != null) {
      result = pattern.replaceFirst(regEx, '#.#');
      // result += '#';
    } else if (match.group(0) != null) {
      result = pattern.replaceFirst(regEx, '#');
    } else if (match.group(1) != null) {
      result = pattern.replaceFirst(regEx, '.#');
      // result += '.#';
    }
    return result;
  }

  /// Removes all whitespace from a pattern or a value
  /// as when we are parsing we ignore whitespace.
  String compressWhitespace(String value) {
    final regEx = RegExp(r'\s+');

    return value.replaceAll(regEx, '');
  }
}

/// Takes a monetary value and turns it into a queue
/// of digits which can be taken one at a time.
class ValueQueue {
  /// the amount we are queuing the digits of.
  String monetaryValue;

  /// current index into the [monetaryValue]
  int index = 0;

  /// the thousands seperator used in this [monetaryValue]
  String thousandsSeparator;

  /// The last character we took from the queue.
  String lastTake;

  ///
  ValueQueue(this.monetaryValue, this.thousandsSeparator);

  String peek() {
    return monetaryValue[index];
  }

  /// takes the next character from the value.
  String takeOne() => lastTake = monetaryValue[index++];

  /// return all of the digits from the current position
  /// until we find a non-digit.
  BigInt takeDigits() {
    var digits = ''; //  = lastTake;

    while (index < monetaryValue.length &&
        (isDigit(monetaryValue[index]) ||
            monetaryValue[index] == thousandsSeparator)) {
      if (monetaryValue[index] != thousandsSeparator) {
        digits += monetaryValue[index];
      }
      index++;
    }

    if (digits.isEmpty) {
      throw MoneyParseException(
          'Character "${monetaryValue[index]}" at pos $index'
          ' is not a digit when a digit was expected');
    }
    return BigInt.parse(digits);
  }

  /// true if the passed character is a digit.
  bool isDigit(String char) {
    return RegExp('[0123456789]').hasMatch(char);
  }
}
