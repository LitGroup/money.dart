# Money2

This is a Dart implementation of Money and Currency classes 

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

Full documentation can be found at: 

https://bsutton.gitbook.io/money/


Api documenation can be found at:

https://pub.dev/documentation/money2/latest/


# Examples

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

print(taxInclusive.format('SCC #.00'));
  > $US 11.00

// Create money from an String using the `Currency` instance.
Money parsed = usdCurrency.parse(r'$10.00');
print(parsed.format('SCCC 0.0'));
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
