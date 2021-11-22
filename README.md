# Money2

This is a Dart implementation of Money and Currency classes 

## Overview

Money2 is a Dart package providing parsing, formatting and mathematical operations on monetary amounts.

Key features of Money2:
* simple and expressive formating.
* simple parsing of monetary amounts.
* multi-currency support.
* intuitive maths operations.
* fixed precision storage to ensure precise calculation.
* detailed documentation and extensive examples to get you up and running.
* pure Dart implementation.
* Open Source MIT license.
* using Money2 will make you taller.


The Money class stores the underlying values using a BigInt. The value is stored using the currencies' "minor units" (e.g. cents).
This allows for precise calculations as required when handling money.

Full documentation can be found at: 

https://money2.noojee.dev


Api documenation can be found at:

https://pub.dev/documentation/money2/latest/

# Another Dart tool by Noojee

<a href="https://noojee.dev">![Noojee](https://github.com/noojee/money.dart/blob/master/images/noojee-logo.png?raw=true)</a>


# Upgrading from v2 to v3
The Money2 3.0.0 release instroduces a number of breaking changes in an effort to clean up the api by making it more consistent.
The 3.0.0 release also moves to using the Fixed decimal package for storing the underlying amounts.
This should hopefully make the Money2 package easier to use.

The incorrectly used term 'precision' has been replaced with 'scale' meaning the no. of deciimal places we store.

Breaking Changes:

| old api | new api | Details |
| ----- | ----- | --- |
| Money.from | Money.fromNum | Name change only 
| ExchangeRate.from | ExchangeRate.fromNum | Requires a from and to Currency code.
| Money.fromMinorUnits | Money.fromInt | Name change only

When parsing Money with a pattern that includes 'C' or 'S' we the amounts no longer need to have either the symbol or the code. 

Patterns with trialing ## were being treated the same as trailing 00

e.g.
0.## === 0.00

These are now treated correctly.

The following now works correctlky
```dart
  final Currency t2 =
          Currency.create('BTC', 8, symbol: '₿', pattern: 'S0.########');

   expect(Money.parseWithCurrency('1', t2).toString(), equals('₿1'));
```

The default pattern for BTC has been changed to:
 'S0.00000000'

 This is to make it consistent with other currencies (i.e. the number of required decimal places matches the scale);

# Examples

```dart
import 'money2.dart';

Currency usdCurrency = Currency.create('USD', 2);

// Create money from an int.
Money costPrice = Money.fromInt(1000, usdCurrency);
print(costPrice);
  > $10.00

final taxInclusive = costPrice * 1.1;
print(taxInclusive)
  > $11.00

print(taxInclusive.format('SCC #.00'));
  > $US 11.00

// Create money from an String using the `Currency` instance.
Money parsed = usdCurrency.parse(r'$10.00');
print(parsed.format('SCCC 0.0'));
  > $USD 10.00

// Create money from an int which contains the MajorUnit (e.g dollars)
Money buyPrice = Money.fromNum(10);
print(buyPrice);
  > $10.00

// Create money from a double which contains Major and Minor units (e.g. dollars and cents)
// We don't recommend transporting money as a double as you will get rounding errors.
Money sellPrice = Money.fromNum(10.50);
print(sellPrice);
  > $10.50
```
