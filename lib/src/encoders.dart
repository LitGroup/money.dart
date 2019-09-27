
import 'money_data.dart';

abstract class MoneyEncoder<T> {
  /// Returns encoded representation of money data.
  T encode(MoneyData data);
}

abstract class MoneyDecoder<T> {
  /// Returns decoded [MoneyData] or throws a [FormatException].
  MoneyData decode(T encoded);
}
