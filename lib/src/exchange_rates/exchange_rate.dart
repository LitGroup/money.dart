import 'package:fixed/fixed.dart';
import '../../money2.dart';

import '../currency.dart';

typedef CurrencyCode = String;

/// When defining an exchange rate we need to specify
/// the conditions under which the exchange is calculated.
///
/// An [ExchangeRate] allows us to convert a [Money] instance
/// from one [Currency] to another.
///
/// e.g.
///
/// AUD 1.00 = USD 65c.
///
/// The target currency as defined by [toCode] describes the
/// currency of the [Money] instance that is returned by the excchange.
///
/// Whilst technially a given exchange rate is always applied to
/// a specific source currency, we allow the [ExchangeRate] to be specified
/// without the source currency as the [ExchangeRate] is always
/// applied to a [Money] instance which already knows its [Currency]
/// and which is the source currency.
///
/// The [scale] for the exchange rate which is normally quoted to
/// a high precision such as 8 decimal places.
///
/// The [toScale] for the scale of the resulting [Money] amount.
///
/// The target [Currency] also has a default scale which is used
/// if the [toScale] isn't specified.
class ExchangeRate {
  ExchangeRate.fromMinorUnits(int rateAsMinorUnits,
      {required int scale, required CurrencyCode toCode, this.toScale}) {
    currency = _findCurrency(toCode);

    rate = Fixed.fromMinorUnits(rateAsMinorUnits, scale: scale);
  }

  ExchangeRate.from(
    num rateAsNum, {
    required int scale,
    required CurrencyCode toCode,
    this.toScale,
  }) {
    currency = _findCurrency(toCode);
    rate = Fixed.from(rateAsNum, scale: scale);
  }

  ExchangeRate.fromBigInt(BigInt minorUnits,
      {required int scale, required CurrencyCode toCode, this.toScale})
      : rate = Fixed.fromBigInt(minorUnits, scale: scale);

  late final Fixed rate;
  late final Currency currency;
  final int? toScale;

  Money applyRate(Money amount) {
    //d  return Money.fromFixed(fromAmount.amount * rate, code: to.code);
    /// convertedUnits now has this.scale + exchangeRate.scale
    /// scale.
    var convertedUnits = amount.amount * rate;

    /// reduce minor digits back to the exchangeRates no. of minor digits
    final round = Fixed.fromMinorUnits(convertedUnits.isNegative ? -5 : 5,
        scale: convertedUnits.scale + 1);

    convertedUnits = Fixed(
        //  (convertedUnits / _currency.scaleFactor) + round,
        convertedUnits + round,
        scale: convertedUnits.scale);

    return Money.fromFixed(convertedUnits,
        code: currency.code, scale: toScale ?? currency.scale);
  }

  static Currency _findCurrency(String code) {
    final currency = Currencies().find(code);
    if (currency == null) {
      throw UnknownCurrencyException(code);
    }

    return currency;
  }

  // We use a [Money] to take advantage of its formatting capabiities.
  // An exchange rate isn't a money amount but we can use the same format
  // to display it.
  @override
  String toString() => '${currency.symbol}$rate';

  String format(String pattern) =>
      Money.fromFixed(rate, code: currency.code).format(pattern);
}

class ExchangeRateMap {
  ExchangeRateMap(
      {required String from,
      required String to,
      required this.rate,
      Fixed? inverseRate})
      : from = ExchangeRate._findCurrency(from),
        to = ExchangeRate._findCurrency(from);

  ExchangeRateMap.fromCurrency(this.from, this.to, {required this.rate});

  Money applyRate(Money amount) {
    //d  return Money.fromFixed(fromAmount.amount * rate, code: to.code);
    /// convertedUnits now has this.scale + exchangeRate.scale
    /// scale.
    var convertedUnits = amount.amount * rate;

    /// reduce minor digits back to the exchangeRates no. of minor digits
    final round = convertedUnits.isNegative ? -0.5 : 0.5;

    convertedUnits = Fixed(
        //  (convertedUnits / _currency.scaleFactor) + round,
        convertedUnits + Fixed.from(round),
        scale: convertedUnits.scale);

    return Money.fromFixed(convertedUnits, code: to.code);
  }

  Money applyInverseRate(Money fromAmount) {
    return Money.fromFixed(fromAmount.amount * Fixed.from(1) / rate,
        code: to.code);
  }

  Currency from;
  Currency to;
  Fixed rate;
  Fixed? inverseRate;
}
