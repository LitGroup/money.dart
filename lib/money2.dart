/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 - 2019 LitGroup LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/// Money2 is a fork of LitGroup's Money package.
///
/// The aim of this fork is to improve the documentation and introduce a
/// number of convenience methods to make it easier to work with Money.
/// This package also changes some of the naming convention to provide
/// a (hopefully) more intuiative api.
///
/// The [Currency] class allows you to define the key attributes of a currency
/// such as Symbol, Code, precision and a default format.
///
/// The [Money] class stores the underlying values using a BigInt. The value
/// is stored using the currencies 'minor' units (e.g. cents).
///
/// This allows for precise calculations as required when handling money.
///
/// Key features of Money2:
/// * simple and expressive formating.
/// * simple parsing of monetary amounts.
/// * multi-currency support.
/// * intuitive maths operations.
/// * fixed precision storage to ensure precise calcuation.
/// * detailed documentation and extensive examples to get you up and running.
/// * pure dart implementation.
/// * Open Source MIT license.
/// * Using Money2 will make you taller.
///
/// The package use the following terms:
/// * Minor Units - the smallest unit of a currency e.g. cents.
/// * Major Units - the integer component of a currency - e.g. dollars
/// * code - the currency code. e.g. USD
/// * symbol - the currency symbol. e.g. '$'. It should be noted that not
/// every currency has a symbol.
/// * pattern - a pattern used to control the display format.
/// * precision - the number of decimal places assumed when a minor unit value (e.g. cents) is passed.
/// * decimal separator - the character that separates the fraction part
/// from the integer of a number e.g. '10.99'. This defaults to '.'
/// but can be changed to ',' * thousands separator - the character
/// that is used to format thousands (e.g. 100,000). This can be changed to '.'
///
///  Using the [Money] and [Currency] classes is easy.
///
/// ```dart
/// import 'money2.dart';
/// Currency aud = Currency.create('AUD', 2, pattern:r'$0.00');
/// Money costPrice = Money.fromInt(1000, aud);
/// print(costPrice.toString());
///   > $10.00
///
/// Money spareChange = Money.parse('$10.50', aud);
///
/// Money lunchMoney = aud.parse('$11.50');
///
/// Money taxInclusive = costPrice * 1.1;
/// print(taxInclusive.toString());
///   > $11.00
///
/// print(taxInclusive.format('SCCC0.00'));
///   > $AUD11.00
///
/// print(taxInclusive.format('SCCC0'));
///   > $AUD11
/// ```

library money2;

export 'src/common_currencies.dart';
export 'src/currencies.dart';
export 'src/currency.dart';
export 'src/encoders.dart';
export 'src/money.dart';
export 'src/pattern_encoder.dart' show IllegalPatternException;
export 'src/exchange_rates/exchange_rate.dart';
export 'src/exchange_rates/exchange_platform.dart';
export 'package:fixed/fixed.dart';
