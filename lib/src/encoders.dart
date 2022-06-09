/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
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
