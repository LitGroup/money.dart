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
  /// From Fixed
  factory ExchangeRate.fromFixed(Fixed exchangeRate,
          {required CurrencyCode fromCode,
          required CurrencyCode toCode,
          int? toScale}) =>
      ExchangeRate.fromFixedWitCurrency(exchangeRate,
          fromCurrency: _findCurrency(fromCode),
          toCurrency: _findCurrency(toCode),
          toScale: toScale);

  ExchangeRate.fromFixedWitCurrency(this.exchangeRate,
      {required this.fromCurrency, required this.toCurrency, this.toScale});

  // From MinorUnits
  factory ExchangeRate.fromMinorUnits(int exchangeRateMinorUnits,
          {required int scale,
          required CurrencyCode fromCode,
          required CurrencyCode toCode,
          int? toScale}) =>
      ExchangeRate.fromMinorUnitsWithCurrency(exchangeRateMinorUnits,
          scale: scale,
          fromCurrency: _findCurrency(fromCode),
          toCurrency: _findCurrency(toCode),
          toScale: toScale);

  ExchangeRate.fromMinorUnitsWithCurrency(int exchangeRateMinorUnits,
      {required int scale,
      required this.fromCurrency,
      required this.toCurrency,
      this.toScale})
      : exchangeRate = Fixed.fromInt(exchangeRateMinorUnits, scale: scale);

  /// fromNum
  factory ExchangeRate.fromNum(
    num exchangeRate, {
    required int scale,
    required CurrencyCode fromCode,
    required CurrencyCode toCode,
    int? toScale,
  }) =>
      ExchangeRate.fromNumWithCurrency(exchangeRate,
          scale: scale,
          fromCurrency: _findCurrency(fromCode),
          toCurrency: _findCurrency(toCode),
          toScale: toScale);

  ExchangeRate.fromNumWithCurrency(
    num rateAsNum, {
    required int scale,
    required this.fromCurrency,
    required this.toCurrency,
    this.toScale,
  }) {
    exchangeRate = Fixed.fromNum(rateAsNum, scale: scale);
  }

  /// fromBigInt
  factory ExchangeRate.fromBigInt(BigInt exchangeRateMinorUnits,
          {required int scale,
          required CurrencyCode fromCode,
          required CurrencyCode toCode,
          int? toScale}) =>
      ExchangeRate.fromBigIntWithCurrency(exchangeRateMinorUnits,
          scale: scale,
          fromCurrency: _findCurrency(fromCode),
          toCurrency: _findCurrency(toCode));

  ExchangeRate.fromBigIntWithCurrency(
    BigInt exchangeRateMinorUnits, {
    required int scale,
    required this.fromCurrency,
    required this.toCurrency,
    this.toScale,
  }) {
    exchangeRate = Fixed.fromBigInt(exchangeRateMinorUnits, scale: scale);
  }

  /// The Currency that we are converting from.
  late final Currency fromCurrency;

  late final Fixed exchangeRate;

  /// After the exchange rate is applied this
  /// is the resulting [Currency]
  late final Currency toCurrency;

  /// The scale of the resulting [Currency]
  /// If not passed then we use the default scale
  /// of the [toCurrency]
  final int? toScale;

  Money applyRate(Money amount) {
    if (fromCurrency != amount.currency) {
      throw MismatchedCurrencyException(
          expected: fromCurrency.code, actual: amount.currency.code);
    }

    /// convertedUnits now has this.scale + exchangeRate.scale
    /// scale.
    var convertedUnits = amount.amount * exchangeRate;

    return Money.fromFixed(convertedUnits,
        code: toCurrency.code, scale: toScale ?? toCurrency.scale);
  }

  Money applyInverseRate(Money fromAmount) {
    return Money.fromFixedWithCurrency(
        fromAmount.amount *
            Fixed.fromNum(1, scale: toScale ?? toCurrency.scale) /
            exchangeRate,
        fromCurrency,
        scale: toScale ?? toCurrency.scale);
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
  String toString() => '${toCurrency.symbol}$exchangeRate';

  String format(String pattern) =>
      Money.fromFixed(exchangeRate, code: toCurrency.code).format(pattern);
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
        convertedUnits + Fixed.fromNum(round),
        scale: convertedUnits.scale);

    return Money.fromFixed(convertedUnits, code: to.code);
  }

  Money applyInverseRate(Money fromAmount) {
    return Money.fromFixed(fromAmount.amount * Fixed.fromNum(1) / rate,
        code: to.code);
  }

  Currency from;
  Currency to;
  Fixed rate;
  Fixed? inverseRate;
}
