import 'package:decimal/decimal.dart';

import '../../test/src/fixed_precision_decoder.dart';

class FixedPrecision {
  late final Decimal decimal;

  FixedPrecision.parse(
    String amount, {
    String pattern = '#.#',
    int precision = 2,
    bool invertSeparator = false,
  }) {
    FixedPrecisionDecoder(
      pattern: pattern,
      thousandSeparator: invertSeparator ? '.' : ',',
      decimalSeparator: invertSeparator ? ',' : '.',
      precision: precision,
    );
    decimal = Decimal.parse(amount);
  }

  FixedPrecision from(num amount, {int precision = 2}) => FixedPrecisionDecoder(
        precision: precision,
        pattern: '#.#',
        thousandSeparator: ',',
        decimalSeparator: '.',
      ).decode(amount.toStringAsFixed(precision));

  static late final ten = Decimal.fromInt(10);
  FixedPrecision.fromInt(int amount, {int precision = 2})
      : decimal = Decimal.fromInt(amount) / ten.pow(precision);

  FixedPrecision.fromBigInt(BigInt amount, {int precision = 2})
      : decimal = Decimal.fromBigInt(amount) / ten.pow(precision);
}
