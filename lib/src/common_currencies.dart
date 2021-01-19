import '../money2.dart';

/// Provides a list of the most common currencies.
/// You can use individual currencies from this list or
/// register the complete list.
///
/// ```dart
///
/// // register just one currency
/// Currencies.register(CommonCurrencies().usd);
///
/// // register all common currencies.
/// CommonCurrencies().registerAll();
///
/// ```
///
class CommonCurrencies {
  static final CommonCurrencies _self = CommonCurrencies._internal();

  /// Factory constructor.
  factory CommonCurrencies() {
    return _self;
  }

  CommonCurrencies._internal();

  /// Australia
  final Currency aud = Currency.create('AUD', 2);

  /// Brazilian Real
  final Currency brl = Currency.create('BRL', 2, symbol: r'R$');

  /// Bit coin dollar
  final Currency btc = Currency.create('BTC', 8, symbol: '₿', pattern: 'S0');

  /// Canada
  final Currency cad = Currency.create('CAD', 2);

  /// Swiss Franc
  final Currency chf = Currency.create('CHF', 2, symbol: 'fr');

  /// Chinese renminbi
  final Currency cny = Currency.create('CNY', 2, symbol: '¥');

  /// euro
  final Currency euro = Currency.create('EUR', 2,
      symbol: '€', invertSeparators: true, pattern: 'S0.000,00');

  /// British Pound Sterling
  final Currency gbp = Currency.create('GBP', 2, symbol: '£');

  /// Indian Rupee
  final Currency inr = Currency.create('INR', 2,
      symbol: '₹', invertSeparators: true, pattern: 'S000.00,00');

  /// Japanese Yen
  final Currency jpy = Currency.create('JPY', 0, symbol: '¥', pattern: 'S0');

  /// South Korean Won
  final Currency krw = Currency.create('KRW', 0, symbol: '₩', pattern: 'S0');

  /// Turkish Lira
  final Currency ltry = Currency.create('TRY', 2, symbol: '₺');

  /// Mexican Peso
  final Currency mxn = Currency.create('MXN', 2);

  /// Norwegian krone
  final Currency nok = Currency.create('NOK', 2, symbol: 'kr');

  /// New Zealand
  final Currency nzd = Currency.create('NZD', 2);

  /// Russian Ruble
  final Currency rub = Currency.create('RUB', 2, symbol: '₽');

  /// New Taiwan dollar
  final Currency twd = Currency.create('TWD', 0, symbol: r'NT$', pattern: 'S0');

  /// USA
  final Currency usd = Currency.create('USD', 2);

  /// South African Rand
  final Currency zar = Currency.create('ZAR', 2, symbol: 'R');

  /// Registers all of the common currency.
  void registerAll() {
    Currencies.registerList([
      aud,
      cad,
      chf,
      brl,
      btc,
      cny,
      euro,
      inr,
      gbp,
      jpy,
      krw,
      ltry,
      mxn,
      nok,
      nzd,
      rub,
      twd,
      usd,
      zar
    ]);
  }
}
