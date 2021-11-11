import 'dart:math';

BigInt calcPrecisionFactor(int precision) {
  if (precision.isNegative) {
    throw ArgumentError.value(
      precision,
      'precision',
      'Must be a non-negative value.',
    );
  }
  return BigInt.from(pow(10, precision));
}
