import '../../money2.dart';

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
/// The [scale] for the [exchangeRate] should normally be quoted to
/// a high precision such as 8 decimal places.
///
/// The [toScale] is the scale of the resulting [Money] amount. If not
/// supplied the scale of the [toCode]'s currency is used.
///
class ExchangeRate {
  /// Create an exchnage rate from a [Fixed] decimal.
  ///
  /// The [toScale] is the scale of the resulting [Money] amount. If not
  /// supplied the scale of the [toCode]'s currency is used.
  factory ExchangeRate.fromFixed(Fixed exchangeRate,
          {required CurrencyCode fromCode,
          required CurrencyCode toCode,
          int? toScale}) =>
      ExchangeRate.fromFixedWitCurrency(exchangeRate,
          fromCurrency: _findCurrency(fromCode),
          toCurrency: _findCurrency(toCode),
          toScale: toScale);

  /// Create an exchange rate from a [Fixed] decimal.
  ///
  /// The [toScale] is the scale of the resulting [Money] amount. If not
  /// supplied the scale of the [toCode]'s currency is used.
  ExchangeRate.fromFixedWitCurrency(this.exchangeRate,
      {required this.fromCurrency, required this.toCurrency, this.toScale});

  /// Create an exchange rate from an integer holding minor units
  /// to the provided [scale].
  ///
  /// The [toScale] is the scale of the resulting [Money] amount. If not
  /// supplied the scale of the [toCode]'s currency is used.
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

  /// Create an exchange rate from an integer holding minor units
  /// to the provided [scale].
  ///
  /// The [toScale] is the scale of the resulting [Money] amount. If not
  /// supplied the scale of the [toCode]'s currency is used.
  ExchangeRate.fromMinorUnitsWithCurrency(int exchangeRateMinorUnits,
      {required int scale,
      required this.fromCurrency,
      required this.toCurrency,
      this.toScale})
      : exchangeRate = Fixed.fromInt(exchangeRateMinorUnits, scale: scale);

  /// Create an exchange rate from an integer or decimal holding major units
  ///
  /// The amount is stored with  [scale] decimal places.
  ///
  /// The [toScale] is the scale of the resulting [Money] amount. If not
  /// supplied the scale of the [toCode]'s currency is used.
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

  /// Create an exchange rate from an integer or decimal holding major units
  ///
  /// The amount is stored with  [scale] decimal places.
  ///
  /// The [toScale] is the scale of the resulting [Money] amount. If not
  /// supplied the scale of the [toCode]'s currency is
  ExchangeRate.fromNumWithCurrency(
    num rateAsNum, {
    required int scale,
    required this.fromCurrency,
    required this.toCurrency,
    this.toScale,
  }) {
    exchangeRate = Fixed.fromNum(rateAsNum, scale: scale);
  }

  /// Create an exchange rate from an BigInt holding minor units
  /// to the provided [scale].
  ///
  /// The amount is stored with  [scale] decimal places.
  ///
  /// The [toScale] is the scale of the resulting [Money] amount. If not
  /// supplied the scale of the [toCode]'s currency is
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

  /// The exchange rate
  late final Fixed exchangeRate;

  /// After the exchange rate is applied this
  /// will the resulting [Currency] of the returned [Money]
  late final Currency toCurrency;

  /// The scale of the resulting [Currency]
  /// If not passed then we use the default scale
  /// of the [toCurrency]
  final int? toScale;

  /// Apply the exchange rate to [amount] and return
  /// a new [Money] in the [toCurrency].
  ///
  /// The [Currency] of the [amount] must be the same as
  /// the [fromCurrency] otherwise a [MismatchedCurrencyException] is thown.
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

  /// Applies the exchange rate in the reverse direction.
  /// The [Currency] of the [amount] must be the same as
  /// the [toCurrency] otherwise a [MismatchedCurrencyException] is thown.
  Money applyInverseRate(Money amount) {
    if (toCurrency != amount.currency) {
      throw MismatchedCurrencyException(
          expected: toCurrency.code, actual: amount.currency.code);
    }

    return Money.fromFixedWithCurrency(
        amount.amount *
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

  /// Formats the [exchangeRate] using the given [pattern]
  String format(String pattern) =>
      Money.fromFixed(exchangeRate, code: toCurrency.code).format(pattern);
}
