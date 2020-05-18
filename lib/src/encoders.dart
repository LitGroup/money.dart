import 'money_data.dart';

/// Bases class for implementing a encoder for money.
// ignore: one_member_abstracts
abstract class MoneyEncoder<T> {
  /// Returns encoded representation of money data.
  T encode(MoneyData data);
}

/// Bases class for implementing a decoder for money.
// ignore: one_member_abstracts
abstract class MoneyDecoder<T> {
  /// Returns decoded [MoneyData] or throws a [FormatException].
  MoneyData decode(T encoded);
}
