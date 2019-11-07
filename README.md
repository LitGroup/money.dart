# Money2

This is a Dart implementation of Money and Currency classes 

* [Overview](#overview)
* [Creating Currencies](#registering-a-currency)
* [Creating Money](#creating-money)
* [Formatting](#formatting)
* [Exchange Rates](#exchange-rates)
* [Comparison](#comparison)
* [Arithmetic Operations](#arithmetic-operations)
* [Allocation](#allocation)
  * [Allocation According to Ratios](#allocation-according-to-ratios)
  * [Allocation to N Targets](#allocation-to-n-targets)
* [Money encoding/decoding](#Money-encoding/decoding)

## Overview

Money2 is a fork of LitGroup's Money package.

The aim of this fork is to improve the documentation and introduce a number of convenience methods to make it easier to work with Money.
This package also changes some of the naming convention to provide a (hopefully) more intuiative api.

Key features of Money2:
* simple and expressive formating.
* simple parsing of monetary amounts.
* multi-currency support.
* intuitive maths operations.
* fixed precision storage to ensure precise calcuation.
* detailed documentation and extensive examples to get you up and running.
* pure dart implementation.
* Open Source MIT license.
* Using Money2 will make you taller.


The Money class stores the underlying values using a BigInt. The value is stored using the currencies' "minor units" (e.g. cents).
This allows for precise calculations as required when handling money.

Lets start with some examples:

```dart
import 'money2.dart';

Currency usdCurrency = Currency.create('USD', 2);

// Create money from an int.
Money costPrice = Money.fromInt(1000, usdCurrency);
print(costPrice.toString());
  > $10.00

final taxInclusive = costPrice * 1.1;
print(taxInclusive.toString())
  > $11.00

print(taxInclusive.format("SCC #.00"));
  > $US 11.00

// Create money from an String using the `Currency` instance.
Money parsed = usdCurrency.parse("\$10.00");
print(parsed.format("SCCC 0.0"));
  > $USD 10.00

// Create money from an int which contains the MajorUnit (e.g dollars)
Money buyPrice = Money.from(10);
print(buyPrice.toString());
  > $10.00

// Create money from a double which contains Major and Minor units (e.g. dollars and cents)
// We don't recommend transporting money as a double as you will get rounding errors.
Money sellPrice = Money.from(10.50);
print(sellPrice.toString());
  > $10.50
```

The package use the following terms:

* Minor Units - the smallest unit of a currency e.g. cents.
* Major Units - the integer component of a currency - e.g. dollars
* code - the currency code. e.g. USD
* symbol - the currency symbol. e.g. '$'. It should be noted that not every currency has a symbol.
* pattern - a pattern used to control parsing and the display format.
* minorDigits - the number of minor Units (e.g. cents) which should be used when storing the currency.
* decimal separator - the character that separates the fraction part from the integer of a number e.g. '10.99'. This defaults to '.' but can be changed to ','
* thousands separator - the character that is used to format thousands (e.g. 100,000). Defaults to ',' but can be changed to '.' 


## Creating a Currency

Before you can start creating Money instances you first need a Currency.

The Money2 package does not contain any 'built-in' Currency types. Instead you must create your own Currency instances as required.

Creating a Currency is simple:

```dart
import 'money2.dart';
// US dollars which have 2 digits after the decimal place.
final usd = Currency.create('USD', 2);

```

You would normally create a single instance of a Currency and re-use that throughout your code base.

### Registering a Currency

To make your life easier we provide the Currencies class which is a singleton that allows you to register your currencies 
and quickly retrieve them from anywhere in your code.

Note: it is NOT a requirement to register a currency. You can just recreate and use currencies whenever and wherever you choose.

```dart
import 'money2.dart';
Currency usd = Currency.create('USD', 2);
Currencies.register(usd);
Currency aud = Currency.create('AUD', 2);
Currencies.register(aud);
Currency euro = Currency.create('EUR', 2, symbol: '€', invertSeparators: true, pattern: "S0.000,00");
Currencies.register(euro);
final Currency jpy = Currency.create('JPY', 0, symbol: '¥', pattern: 'S0');
Currencies.register(jpy);
// find a registred currency.
Currency nowUseIt = Currencies.find('USD');
Money cost = Money.fromInt(1000, nowUseIt);
cost.toString();
> $10.00

```

### Default format

The Currency class also allows you to specify a default format which is used when parsing or formating a `Money` instance.

Note: if you don't specify a pattern it defaults to  "S0.00"

```dart
import 'money2.dart';
Currency aud = Currency.create('AUD', 2, pattern:"S0.00");
Money costPrice = Money.fromInt(1099, aud);
print(costPrice.toString());
  > $10.99

final Currency jpy = Currency.create('JPY', 0, symbol: '¥', pattern: 'S0');
Money yenCostPrice = Money.fromInt(1099, jpy);
print(yenCostPrice.toString());
  > ¥1099

Currency euro = Currency.create('EUR', 2, symbol: '€', invertSeparators: true, pattern: "S0.000,00");
Money euroCostPrice = Money.fromInt(899, euro);
print(euroCostPrice.toString());
  > €8,99

Money usdValue = usd.parse("€7,10");
print(euroCostPrice.toString());
  > €7,10

Money euroValue = euro.parse("\$2.99");
print(euroValue.toString());
  > $2.99

```

You can also use the `Money.format` method to define a specific format where required. [See details below](#formatting)


### Symbols

A number of currency have different symbols, you can specify the symbol when creating the currency.

```dart
import 'money2.dart';
// Create a currency for Japan's yen with the correct symbol
final jpy = Currency.create('JPY', 0, symbol: '¥');
```

### Separators

#### Decimal Separator
Numbers use a decimal separator to separate the integer and factional component of a number.

In the english speaking world the period (.) is used as the decimal separator, however in large parts of the world the comma (,) is used as the decimal separator.

e.g. 

* $USD1,000.99 (one thousand dollars and 99 cents)

* €EUR1.000,99 (one thousand euro and 99 cents)

Money2 use the English convention. To switch to the Euro style convention set the invertSeparators argument to true when creating a currency.

You will also need to provide an appropriate pattern.

```dart
import 'money2.dart';
Currency euro = Currency.create('EUR', 2, symbol: '€', invertSeparators: true, pattern: "S0.000,00");

```

### Thousand Separator
Numbers also use a thousands separator to help format large numbers by placing a separator every few digits.
e.g.
$100,000.00

In the english speaking world the comma (,) is used as the thousands separator however in large parts of the world the period (.) is used as the thousands separator.

Money2 use the English convention. To switch to the Euro style convention set the invertSeparators argument to true when creating a currency.

You will also need to provide an appropriate pattern.

```dart
import 'money2.dart';
Currency euro = Currency.create('EUR', 2, symbol: '€', invertSeparators: true, pattern: "S0.000,00");
```

## Creating Money

For you convience we provide a number of methods to create a `Money` instance.

* Money.parse - parse a monetary string containing an amount.
* Money.fromInt - from a minorUnit (e.g. cents)
* Money.fromBigInt - from a minorUnit
* Money.from - from a num (int or double)
* Currency.parse - parse a monetary string assuming the currency
* Currencies.parse - parse a monetary amount and determine the currency from the 
     embedded currency code.

The `Money` variants all require you to pass in the `Currency`.
The `Currency` variant requires only the monetary value.
The `Currencies` variant is able to determine the `Currency` if the
  passed string amount contains a currency code.

The two most common methods are: 
* Money.fromInt
* Currency.parse

### Money.parse

Parses a string containing a monetary value.

`Money.fromInt` is faster if you already have the value represented as an integer in minor units.

The simplest variant of `Money.parse` relies on the default `pattern` of
the passed currency.

```dart
import 'money2.dart';
final Currency usd = Currency.create('USD', 2);
final Money amount = Money.parse("\$10.25", usd);
```

You can also pass an explict pattern.

```dart
import 'money2.dart';
final Currency usd = Currency.create('USD', 2);
final Money amount = Money.parse("\$10.25", usd, 'S0.0');
```

### Currency.parse

The simplest variant of `Currency.parse` relies on the default pattern of
the currency.

```dart
import 'money2.dart';
final Currency usd = Currency.create('USD', 2);
Money value = usd.parse("\$10.25");
```

You can also pass an explict pattern.

```dart
import 'money2.dart';
final Currency usd = Currency.create('USD', 2);
Money value = usd.parse("\$10.25", 'S0.0');
```


### Money.fromInt

`Money` can be instantiated by providing the amount in the minor units of the
currency (e.g. cents):

```dart
// Create a currency that normally displays 2 decimal places:
final Currency usd = Currency.create('USD', 2);

// Create a currency for Japan's yen with the correct symbol (we default to $)
final Currency jpy = Currency.create('JPY', 0, symbol: '¥');


// Create a money value of $5.10 usd from an int
Money fiveDollars = Money.fromInt(510, usd);

// Create a money value of ¥25010 from a big int.
Money bigDollars = Money.fromBigInt(BigInt.from(25010), jpy);
```


### Currencies.parse

This method is extremely useful if you have a database/list of monetary amounts
that contain their currency code.
'Currencies.parse' will create a `Money` instance of the correct 
currency based on the currency code embedded in the monetary amount.

An exception will be thrown if the monetary amount does not include a currency
code.

Before you can use `Currencies.parse` you must first register the list
of `Currency's` that you need to support.

If you try to create a `Money` instance for an unregistered `Currency` an 
`UknownCurrencyException` will be thrown.


```dart
import 'money2.dart';
final Currency usd = Currency.create('USD', 2);
final Currency jpy = Currency.create('JPY', 0, symbol: '¥');

Currencies.register(usd);
Currencies.register(jpy);

Money usdAmount = Currencies.parse("\$USD10.25", "SCCC0.0");
Money jpyAmount = Currencies.parse("JPY100", "CCC0");
```


## Formatting

The money class provides a simple way of formatting currency using a pattern.

When you create a Currency instance you can provide a default format pattern which is used to format
a Money instance when you call `Money.toString()`.

In some cases you may however want to format a Money instances in a specific manner. In this case you can use:

`Money.format(String pattern)`

```dart
import 'money2.dart';
final Currency usd = Currency.create('USD', 2);
Money one = Money.fromInt(100, usd);
print(one.format("S0"));
  > $1

```

### Formatting Patterns

Note: the same patterns are used for both formatting and parsing monetary amounts.

The supported pattern characters are:
 
     * S outputs the currencies symbol e.g. $.
     * C outputs part of the currency code e.g. USD. You can specify 1,2 or 3 C's. Specifying CCC will output the full code regardless of its length.
         * C - U
         * CC - US
         * CCC - USD - outputs the full currency code regardless of length.
     * # denotes a digit.
     * 0 denotes a digit and and forces padding with leading and trailing zeros.
     * , (comma) a placeholder for the grouping separtor
     * . (period) a place holder for the decimal separator 
     


Examples:

```dart
import 'money2.dart';
final Currency usd = Currency.create('USD', 2);
Money lowPrice = Money.fromInt(1099, usd);
print(lowPrice.format("S000.000"));
  > $010.990

Money costPrice = Money.fromInt(10034530, usd);  // 100,345.30 usd

print(costPrice.format("###,###.##"));
  > 100,345.30

print(costPrice.format("S###,###.##"));
  > $100,345.3

print(costPrice.format("CC###,###.#0"));
  > US100,345.30

print(costPrice.format("CCC###,###.##"));
  > USD100,345.3

print(costPrice.format("SCC###,###.#0"));
  > $US100,345.30

final usd = Currency.create('USD', 2);
Money costPrice = Money.fromInt(10034530, usd);  // 100,345.30 usd
print(costPrice.format("SCC###,###.##"));
  > $US100,345.3

final jpy = Currency.create('JPY', 0, symbol: '¥');
Money costPrice = Money.fromInt(345, jpy);  // 345 yen
print(costPrice.format("SCCC#"));
  > ¥JPY345

// Bahraini dinar
final bhd = Currency.create('BHD', 3, symbol: 'BD', invertSeparators: true);
Money costPrice = Money.withInt(100345, bhd);  // 100.345 bhd
print(costPrice.format("SCCC0000,###")); 
  > BDBHD0100,345
```  

## Exchange Rates

When manipulating monetary amounts you often need to convert between currencies.

Money2 provide a simple method to convert a `Money` instance to another
currency using an exchange rate.

To converts a `Money` instance into a target `Currency` use the 
`Money.exchangeTo` method.

To do this you need to define an exchange rate which is simply 
another `Money` instance. That 'exchange rate' `Money` instance is 
created with the target `Currency` and having a monetary value which 
represents the exchange rate.

### Example

Lets say you have an invoice in Australian Dollars (AUD) which
you need to convert to US Dollars (USD).

Start by google the exchange rate for AUD to USD.
You are likely to find something similar to:

1 AUD = 0.68c USD

Which means that for each Australian Dollar you will recieve
0.68 US cents. (AKA I'm not traveling to the USA this year).


To do the above conversion:
```dart
import 'money2.dart';
// Create the source and the target Currencies
Currency aud = Currency.create("AUD", 2, pattern="SCCC 0.00");
Currency usd = Currency.create("USD", 2, pattern="SCCC 0.00");

// Create the AUD invoice amount ($10.00)
Money invoiceAmount = Money.fromInt(1000, aud);
print(invoiceAmount);
  > $AUD 10.00

// Define the exchange rate in USD (0.68c)
Money auToUsExchangeRate = Money.fromInt(68, usd);
print(auToUsExchangeRate);
  > $USD 0.68

// Now do the conversion.
Money usdAmount = invoiceAmount.exchangeTo(auToUsExchangeRate);
print(usdAmount);
  > $USD 6.80
```

## Comparison

Equality operator (`==`) returns `true` when both operands are in the same
currency and have equal amount.

```dart
import 'money2.dart';
fiveDollars == fiveDollars;  // => true
fiveDollars == sevenDollars; // => false
fiveDollars == fiveEuros;    // => false (different currencies)
```

Money values can be compared with operators `<`, `<=`, `>`, `>=`, or method
`compareTo()` from the interface `Comparable<Money>`.

**This operators and method `compareTo()` can be used
only between money values in the same currency. Runtime error will be thrown
on attempt to compare values in different currencies.**

```dart
import 'money2.dart';
fiveDollars < sevenDollars; // => true
fiveDollars > sevenDollars; // => false
fiveEuros < fiveDollars;    // throws ArgumentError!
```


### Currency Predicates

To check that money value has an expected currency use methods
`isInCurrency(Currency)` and `isInSameCurrencyAs(Money)`:

```dart
import 'money2.dart';
fiveDollars.isInCurrency(usd); // => true
fiveDollars.isInCurrency(eur); // => false
```

```dart
import 'money2.dart';
fiveDollars.isInSameCurrencyAs(sevenDollars); // => true
fiveDollars.isInSameCurrencyAs(fiveEuros);    // => false
```

### Value Sign Predicates

To check if some money amount is a credit, a debit or zero, use predicates:

* `Money.isNegative` — returns `true` only if amount is less than `0`.
* `Money.isPositive` — returns `true` only if amount is greater than `0`.
* `Money.isZero` — returns `true` only if amount is `0`.

## Arithmetic Operations

The Money class is immutable, so each operation returns a new Money instance.

`Money` provides next arithmetic operators:

* unary `-()`
* `+(Money)`
* `-(Money)`
* `*(num)`
* `/(num)`

**Operators `+` and `-` must be used with operands in same currency,
`ArgumentError` will be thrown otherwise.**

```dart
import 'money2.dart';
final tenDollars = fiveDollars + fiveDollars;
final zeroDollars = fiveDollars - fiveDollars;
```

Operators `*`, `/` receive a `num` as the second operand. Both operators use
_schoolbook rounding_ to round result up to a minorUnits of a currency.

```dart
import 'money2.dart';
final fifteenCents = Money.fromBigInt(BigInt.from(15), usd);

final thirtyCents = fifteenCents * 2;  // $0.30
final eightCents = fifteenCents * 0.5; // $0.08 (rounded from 0.075)
```

## Allocation

### Allocation According to Ratios

Let our company have made a profit of 5 cents, which has ro be divided amongst
a company (70%) and an investor (30%). Cents cant' be divided, so We can't
give 3.5 and 1.5 cents. If we round up, the company gets 4 cents, the investor
gets 2, which means we need to conjure up an additional cent.

The best solution to avoid this pitfall is to use allocation according
to ratios.

```dart
import 'money2.dart';
final profit = Money.fromBigInt(BigInt.from(5), usd); // 5¢

var allocation = profit.allocationAccordingTo([70, 30]);
assert(allocation[0] == Money.fromBigInt(BigInt.from(4), usd)); // 4¢
assert(allocation[1] == Money.fromBigInt(BigInt.from(1), usd)); // 1¢

// The order of ratios is important:
allocation = profit.allocationAccordingTo([30, 70]);
assert(allocation[0] == Money.fromBigInt(BigInt.from(2), usd)); // 2¢
assert(allocation[1] == Money.fromBigInt(BigInt.from(3), usd)); // 3¢
```

### Allocation to N Targets

An amount of money can be allocated to N targets using `allocateTo()`.

```dart
import 'money2.dart';
final value = Money.fromBigInt(BigInt.from(800), usd); // $8.00

final allocation = value.allocationTo(3);
assert(allocation[0] == Money.fromBigInt(BigInt.from(267), usd)); // $2.67
assert(allocation[1] == Money.fromBigInt(BigInt.from(267), usd)); // $2.67
assert(allocation[2] == Money.fromBigInt(BigInt.from(266), usd)); // $2.66
```


## Money encoding/decoding

API for encoding/decoding a money value enables an application to store
value in a database or send over the network.

A money value can be encoded to any type. For example it can be coded
as a string in the format like "USD 5.00".

Note: this is a trivial example and you would simply use the parse/format methods
to encode/decode from/to a string.

### Encoding

```dart
import 'money2.dart';
class MoneyToStringEncoder implements MoneyEncoder<String> {
  String encode(MoneyData data) {
    // Receives MoneyData DTO and produce
    // a string representation of money value...
    String major = data.getMajorUnits().toString();
    String mainor = data.getMinorUnits().toString();

    return data.currency.code + " " + major + "." + minor;
  }
}


final encoded = fiveDollars.encodedBy(MoneyToStringEncoder());
// Now we can save `encoded` to database...
```

### Decoding

```dart
import 'money2.dart';
class StringToMoneyDecoder implements MoneyDecoder<String> {

  Currencies _currencies;

  StringToMoneyDecoder(this._currencies) {
    if (_currencies == null) {
      throw ArgumentError.notNull('currencies');
    }
  }

  /// Returns decoded `MoneyData` or throws a `FormatException`.
  MoneyData decode(String encoded) {
    // If `encoded` has an invalid format throws FormatException;
    
    // Extracts currency code from `encoded`:
    final currencyCode = ...;

    // Tries to find information about a currency:
    final currency = _currencies.find(currencyCode);
    if (currency == null) {
      throw FormatException('Unknown currency: $currencyCode.');
    }
    
    // Using `currency.precision`, extracts minorUnits from `encoded`:
    final minorUnits = ...;
    
    return MoneyData.from(minorUnits, currency);
  }
}
```

```dart
import 'money2.dart';
try {
  final value = Money.decoding('USD 5.00', MyMoneyDecoder(myCurrencies));

  // ...
} on FormatException {
  // ...
}
```
