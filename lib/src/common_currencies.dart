import 'currency.dart';

/// Provides a list of the most common currencies.
///
/// The full list of currencies are available when you
/// parse an amount.
///
/// ```dart
/// Currencies.parse('$AUD10.00', pattern: 'SCCC#.#');
/// ```
///
class CommonCurrencies {
  static final CommonCurrencies _self = CommonCurrencies._internal();

  /// Factory constructor.
  factory CommonCurrencies() {
    return _self;
  }

  CommonCurrencies._internal();

  /// Australian Dollar
  final Currency aud = Currency.create('AUD', 2,
      pattern: 'S0.00',
      country: 'Australian',
      unit: 'Dollar',
      name: 'Australian Dollar');

  /// Bitcoin
  final Currency btc = Currency.create('BTC', 8,
      symbol: '₿',
      pattern: 'S0.00000000',
      country: 'Digital',
      unit: 'Bitcoin',
      name: 'Bitcon');

  /// Brazilian Real
  final Currency brl = Currency.create('BRL', 2,
      symbol: r'R$',
      invertSeparators: true,
      pattern: 'S0,00',
      country: 'Brazil',
      unit: 'Real',
      name: 'Brazilian Real');

  /// British Pound Sterling
  final Currency gbp = Currency.create('GBP', 2,
      symbol: '£',
      country: 'Britan',
      unit: 'Pound Sterling',
      name: 'British Pound Sterling');

  /// Canadian Dollar
  final Currency cad = Currency.create('CAD', 2,
      country: 'Canada', unit: 'Dollar', name: 'Canadian Dollar');

  /// Chinese Renminbi
  final Currency cny = Currency.create('CNY', 2,
      symbol: '¥',
      country: 'China',
      unit: 'Renminbi',
      name: 'Chinese Renminbi');

  /// Czech Koruna
  final Currency czk = Currency.create('CZK', 2,
      symbol: 'Kč',
      invertSeparators: true,
      pattern: '0,00S',
      country: 'Czech',
      unit: 'Koruna',
      name: 'Czech Koruna');

  /// European Union Euro
  final Currency euro = Currency.create('EUR', 2,
      symbol: '€',
      invertSeparators: true,
      pattern: '0,00S',
      country: 'European Union',
      unit: 'Euro',
      name: 'European Union Euro');

  /// Ghana Cedi
  final Currency ghs = Currency.create('GHS', 2,
      symbol: '₵',
      pattern: 'S0.00',
      country: 'Ghana',
      unit: 'Cedi',
      name: 'Ghana Cedi');

  /// Indian Rupee
  final Currency inr = Currency.create('INR', 2,
      symbol: '₹',
      pattern: 'S0.00',
      country: 'Indian',
      unit: 'Rupee',
      name: 'Indian Rupee');

  /// Japanese Yen
  final Currency jpy = Currency.create('JPY', 0,
      symbol: '¥',
      pattern: 'S0',
      country: 'Japanese',
      unit: 'Yen',
      name: 'Japanese Yen');

  /// Mexican Peso
  final Currency mxn = Currency.create('MXN', 2,
      country: 'Mexican', unit: 'Peso', name: 'Mexican Peso');

  /// New Zealand Dollar
  final Currency nzd = Currency.create('NZD', 2,
      country: 'New Zealand', unit: 'Dollar', name: 'New Zealand Dollar');

  /// Nigerian Naira
  final Currency ngn = Currency.create('NGN', 2,
      symbol: '₦',
      pattern: 'S0.00',
      country: 'Nigerian',
      unit: 'Naira',
      name: 'Nigerian Naira');

  /// Norwegian Krone
  final Currency nok = Currency.create('NOK', 2,
      symbol: 'kr',
      country: 'Norwegian',
      unit: 'Krone',
      name: 'Norwegian Krone');

  /// Polish Zloty
  final Currency pln = Currency.create('PLN', 2,
      symbol: 'zł',
      invertSeparators: true,
      pattern: '0,00S',
      country: 'Polish',
      unit: 'Zloty',
      name: 'Polish Zloty');

  /// South African Rand
  final Currency zar = Currency.create('ZAR', 2,
      symbol: 'R',
      country: 'South African',
      unit: 'Rand',
      name: 'South African Rand');

  /// South Korean Won
  final Currency krw = Currency.create('KRW', 0,
      symbol: '₩',
      pattern: 'S0',
      country: 'South Korean',
      unit: 'Won',
      name: 'South Korean Won');

  /// Swiss Franc
  final Currency chf = Currency.create('CHF', 2,
      symbol: 'fr', country: 'Switzerland', unit: 'Franc', name: 'Swiss Franc');

  /// New Taiwan Dollar
  final Currency twd = Currency.create('TWD', 0,
      symbol: r'NT$',
      pattern: 'S0',
      country: 'New Taiwan',
      unit: 'Dollar',
      name: 'New Taiwan Dollar');

  /// Turkish Lira
  final Currency ltry = Currency.create('TRY', 2,
      symbol: '₺', country: 'Turkish', unit: 'Lira', name: 'Turkish Lira');

  /// Russian Ruble
  final Currency rub = Currency.create('RUB', 2,
      symbol: '₽', country: 'Russia', unit: 'Ruble', name: 'Russian Ruble');

  /// United States Dollar
  final Currency usd = Currency.create('USD', 2,
      country: 'United States of America',
      unit: 'Dollar',
      name: 'United States Dollar');

  /// Return list of all of the common currency.
  List<Currency> asList() {
    return [
      aud,
      brl,
      btc,
      cad,
      chf,
      cny,
      czk,
      euro,
      gbp,
      ghs,
      inr,
      jpy,
      krw,
      ltry,
      mxn,
      ngn,
      nok,
      nzd,
      pln,
      rub,
      twd,
      usd,
      zar,
    ];
  }
}
