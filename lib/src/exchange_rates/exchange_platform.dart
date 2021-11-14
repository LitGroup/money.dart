import '../money.dart';
import 'exchange_rate.dart';

typedef CodePair = String;
typedef Code = String;

class ExchangePlatform {
  final exchangeMap = <Code, ExchangeRateMap>{};
  void registerExchangeRate(ExchangeRateMap exchangeRate) {
    exchangeMap[_generate(exchangeRate.from.code, exchangeRate.to.code)] =
        exchangeRate;
  }

  Money exchangeTo(Money from, Code to) {
    var exchangeRate = exchangeMap[_generate(from.currency.code, to)];

    if (exchangeRate != null) {
      return exchangeRate.applyRate(from);
    }

    /// try the inverse code pari
    exchangeRate = exchangeMap[_generate(
      to,
      from.currency.code,
    )];

    if (exchangeRate != null) {
      return exchangeRate.applyInverseRate(from);
    }
    throw UnknownExchangeRateException(from.currency.code, to);
  }

  CodePair _generate(Code from, Code to) {
    return '$from:$to';
  }
}

/// Thrown if an attempt is made to calcuate the value of a [Money] amount
/// in another currency for which there isn't a registered exchange rate.
class UnknownExchangeRateException implements Exception {
  /// The from currency code in the unknown exchange
  Code from;

  /// The to  currency code in the unknown exchange
  Code to;

  ///
  UnknownExchangeRateException(this.from, this.to);

  @override
  String toString() {
    return "An unknown currency exchange was attempted from: '$from' to: '$to'. Register the ExchangeRate"
        ' via [ExchangePlatform.register()] and try again.';
  }
}
