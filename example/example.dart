/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'package:money2/money2.dart';
// ignore_for_file: avoid_print

void main() {
  /// Create money from Fixed amount

  final usdtCurrency = Currency.create('USDT', 8, name: 'USDT', symbol: 'USDT');
  final ethCurrency = Currency.create('ETH', 18,
      name: 'ETH', symbol: 'ETH', pattern: '#,##0.0000############## ¤');
  // final ethCurrency2 = Currency.create('ETH', 8, name: 'ETH', symbol: 'ETH');
  final idrCurrency = Currency.create('BIDR', 2, name: 'IDR', symbol: 'IDR');
  //add 2 new currency withdifferent decimal
  Currencies().registerList([usdtCurrency, idrCurrency, ethCurrency]);

  final money = Money.fromBigIntWithCurrency(
      BigInt.parse('4115000000000010000000'), ethCurrency);

  print(money.formatICU(
      pattern: '#,##0.0000############## ¤', maxDisplayPrecision: 4));

  // final fixed = Fixed.fromInt(100);
  // Money.parse('1.23', code: 'AUD');
  // final angka1 = Decimal.fromInt(1);
  // final angka2 = Decimal.fromInt(3);
  // final totalUang = Money.fromDecimal(Decimal.fromInt(1), code: 'USDT');
  // final bunga = Decimal.fromInt(3);
  // final case1 = totalUang.amount.toDecimal() / bunga;
  // final hasilHitung =
  //     case1.toDecimal(scaleOnInfinitePrecision: totalUang.currency.scale);
  // final newTotalUang = Money.fromDecimal(hasilHitung, code: 'USDT');

  // final hasil = angka1 / angka2;
  // print(hasil.toDecimal(scaleOnInfinitePrecision: 5));

  // Money.fromFixed(fixed, code: 'AUD');

  // Money.fromDecimal(Decimal.parse('1.23'), code: 'EUR');

  // ///
  // /// Create a money which stores $USD 10.00
  // ///
  // /// Note: we use the minor unit (e.g. cents) when passing in the
  // ///   monetary value.
  // /// So $10.00 is 1000 cents.
  // ///
  // final costPrice = Money.fromInt(1000, code: 'USD');

  // print(costPrice.toString());
  // // > $10.00

  // ///
  // /// Create a [Money] instance from a String
  // /// using [Currency.parse]
  // /// The [Currency] of salePrice is USD.
  // ///
  // final salePrice = CommonCurrencies().usd.parse(r'$10.50');
  // print(salePrice.format('SCC 0.0'));
  // // > $US 10.50

  // ///
  // /// Create a [Money] instance from a String
  // /// using [Money.parse]
  // ///
  // final taxPrice = Money.parse(r'$1.50', code: 'USD');
  // print(taxPrice.format('CC 0.0 S'));
  // // > US 1.50 $

  // ///
  // /// Create a [Money] instance from a String
  // /// with an embedded Currency Code
  // /// using [Currencies.parse]
  // ///
  // /// Create a custom currency
  // /// USD currency uses 2 decimals, we need 3.
  // ///
  // final usd = Currency.create('USD', 3);

  // final cheapIPhone = Currencies().parse(r'$USD1500.0', pattern: 'SCCC0.0');
  // print(cheapIPhone.format('SCC0.0'));
  // // > $US1500.00

  // final expensiveIPhone = Currencies().parse(r'$AUD2000.0', pattern: 'SCCC0.0');
  // print(expensiveIPhone.format('SCC0.0'));
  // // > $AUD2000.00

  // /// Register a non-common currency (dogecoin)
  // Currencies().register(Currency.create('DODGE', 5, symbol: 'Ð'));
  // final dodge = Currencies().find('DODGE');
  // Money.fromNumWithCurrency(0.1123, dodge!);
  // Money.fromNum(0.1123, code: 'DODGE');

  // ///
  // /// Do some maths
  // ///
  // final taxInclusive = costPrice * 1.1;

  // ///
  // /// Output the result using the default format.
  // ///
  // print(taxInclusive.toString());
  // // > $11.00

  // ///
  // /// Do some custom formatting of the ouput
  // /// S - the symbol e.g. $
  // /// CC - first two digits of the currency code provided when creating
  // ///     the currency.
  // /// # - a digit if required
  // /// 0 - a digit or the zero character as padding.
  // print(taxInclusive.format('SCC #.00'));
  // // > $US 11.00

  // ///
  // /// Explicitly define the symbol and the default pattern to be used
  // ///    when calling [Money.toString()]
  // ///
  // /// JPY - code for japenese yen.
  // /// 0 - the number of minor units (e.g cents) used by the currency.
  // ///     The yen has no minor units.
  // /// ¥ - currency symbol for the yen
  // /// S0 - the default pattern for [Money.toString()].
  // ///      S output the symbol.
  // ///      0 - force at least a single digit in the output.
  // ///
  // final jpy = Currency.create('JPY', 0, symbol: '¥', pattern: 'S0');
  // final jpyMoney = Money.fromIntWithCurrency(500, jpy);
  // print(jpyMoney.toString());
  // // > ¥500

  // ///
  // /// Define a currency that has inverted separators.
  // /// i.e. The USD uses '.' for the integer/fractional separator
  // ///      and ',' for the group separator.
  // ///      -> 1,000.00
  // /// The EURO use ',' for the integer/fractional separator
  // ///      and '.' for the group separator.
  // ///      -> 1.000,00
  // ///
  // final euro = Currency.create('EUR', 2,
  //     symbol: '€', invertSeparators: true, pattern: '#.##0,00 S');

  // final bmwPrice = Money.fromIntWithCurrency(10025090, euro);
  // print(bmwPrice.toString());
  // // > 100.250,90 €

  // ///
  // /// Formatting examples
  // ///
  // ///

  // // 100,345.30 usd
  // final teslaPrice = Money.fromInt(10034530, code: 'USD');

  // print(teslaPrice.format('###,###'));
  // // > 100,345

  // print(teslaPrice.format('S###,###.##'));
  // // > $100,345.3

  // print(teslaPrice.format('CC###,###.#0'));
  // // > US100,345.30

  // // 100,345.30 EUR
  // final euroCostPrice = Money.fromInt(10034530, code: 'EUR');
  // print(euroCostPrice.format('###.###'));
  // // > 100.345

  // print(euroCostPrice.format('###.###,## S'));
  // // > 100.345,3 €

  // print(euroCostPrice.format('###.###,#0 CC'));
  // // > 100.345,30 EU

  // ///
  // /// Make the currencies available globally by registering them
  // ///     with the [Currencies] singleton factory.
  // ///
  // Currencies().register(usd);
  // Currencies().register(euro);
  // Currencies().register(jpy);

  // // use a registered currency by finding it in the registry using
  // // the currency code that the currency was created with.
  // final usDollar = Currencies().find('USD');

  // final invoicePrice = Money.fromIntWithCurrency(1000, usDollar!);

  // ///
  // print(invoicePrice.format('SCCC 0.00'));
  // // $USD 10.00

  // // Do some maths
  // final taxInclusivePrice = invoicePrice * 1.1;
  // print(taxInclusivePrice.toString());
  // // $11.00

  // print(taxInclusivePrice.format('SCC 0.00'));
  // // $US 11.00

  // // retrieve all registered currencies
  // final registeredCurrencies = Currencies().getRegistered();
  // final codes = registeredCurrencies.map((c) => c.code);
  // print(codes);
  // // (USD, AUD, EUR, JPY)

  // // format ICU
}
