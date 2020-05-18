import 'package:meta/meta.dart';

/// [MinorUnits] represent the smallest unit in a given currency
/// e.g. cents.
/// The [Money] classes uses the [MinorUnits] to store all monetary
/// values.
@immutable
class MinorUnits implements Comparable<MinorUnits> {
  final BigInt _value;

  /// Create a MinorUnit from a [BigInt] which contains
  /// a value in minor units.
  MinorUnits.from(BigInt value) : _value = value {
    assert(value != null);
  }

  /// returns true of the value of this [MinorUnit] is zero.
  bool get isZero => _value == BigInt.zero;

  /// returns true of the value of this [MinorUnit] is negative.
  bool get isNegative => _value < BigInt.zero;

  /// returns true of the value of this [MinorUnit] is positive.
  bool get isPositive => _value > BigInt.zero;

  @override
  int compareTo(MinorUnits other) => _value.compareTo(other._value);

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(dynamic other) =>
      other is MinorUnits && _value == other._value;

  /// less than operator
  bool operator <(MinorUnits other) => _value < other._value;

  /// less than or equal operator
  bool operator <=(MinorUnits other) => _value <= other._value;

  /// greater than operator
  bool operator >(MinorUnits other) => _value > other._value;

  /// greater than or equal operator
  bool operator >=(MinorUnits other) => _value >= other._value;

  ///
  ///  Allocation
  List<MinorUnits> allocationAccordingTo(List<int> ratios) {
    if (ratios.isEmpty) {
      throw ArgumentError.value(ratios, 'ratios',
          'List of ratios must not be empty, cannot allocate to nothing.');
    }

    return _doAllocationAccordingTo(ratios.map((ratio) {
      if (ratio < 0) {
        throw ArgumentError.value(
            ratios, 'ratios', 'Ratio must not be negative.');
      }

      return BigInt.from(ratio);
    }).toList());
  }

  List<MinorUnits> _doAllocationAccordingTo(List<BigInt> ratios) {
    final totalVolume = ratios.reduce((a, b) => a + b);

    if (totalVolume == BigInt.zero) {
      throw ArgumentError('Sum of ratios must be greater than zero, '
          'cannot allocate to nothing.');
    }

    final absoluteValue = _value.abs();
    var remainder = absoluteValue;

    var shares = ratios.map((ratio) {
      final share = absoluteValue * ratio ~/ totalVolume;
      remainder -= share;

      return share;
    }).toList();

    for (var i = 0; remainder > BigInt.zero && i < shares.length; ++i) {
      if (ratios[i] > BigInt.zero) {
        shares[i] += BigInt.one;
        remainder -= BigInt.one;
      }
    }

    return shares
        .map((share) => MinorUnits.from(_value.isNegative ? -share : share))
        .toList();
  }

  /// Arithmetic

  /// add operator
  MinorUnits operator +(MinorUnits operand) =>
      MinorUnits.from(_value + operand._value);

  /// unary minus operator.
  MinorUnits operator -() => MinorUnits.from(-_value);

  /// subtract operator
  MinorUnits operator -(MinorUnits operand) =>
      MinorUnits.from(_value - operand._value);

  /// multiplication operator.
  MinorUnits operator *(num operand) {
    if (operand is int) {
      return MinorUnits.from(_value * BigInt.from(operand));
    }

    if (operand is double) {
      const floatingDecimalFactor = 1e14;
      final decimalFactor = BigInt.from(100000000000000); // 1e14
      final roundingFactor = BigInt.from(50000000000000); // 5 * 1e14

      final product =
          _value * BigInt.from((operand.abs() * floatingDecimalFactor).round());

      var result = product ~/ decimalFactor;
      if (product.remainder(decimalFactor) >= roundingFactor) {
        result += BigInt.one;
      }
      if (operand.isNegative) {
        result *= -BigInt.one;
      }

      return MinorUnits.from(result);
    }

    throw UnsupportedError(
        'Unsupported type of multiplier: "${operand.runtimeType}", '
        '(int or double are expected)');
  }

  /// Division operator.
  MinorUnits operator /(num divisor) {
    return this * (1.0 / divisor.toDouble());
  }

  ///
  /// Type Conversion **********************************************************
  ///

  /// returns the minor units as a big int value.
  BigInt toBigInt() => _value;
}
