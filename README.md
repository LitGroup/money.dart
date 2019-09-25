# Money

This is a Dart implementation of the Money pattern, as described in
[\[Fowler PoEAA\]](https://martinfowler.com/books/eaa.html):

> A large proportion of the computers in this world manipulate money, so it’s
> always puzzled me that money isn’t actually a first class data type in any
> mainstream programming language. The lack of a type causes problems, the most
> obvious surrounding currencies. If all your calculations are done in a single
> currency, this isn’t a huge problem, but once you involve multiple currencies
> you want to avoid adding your dollars to your yen without taking the currency
> differences into account. The more subtle problem is with rounding. Monetary
> calculations are often rounded to the smallest currency unit. When you do this
> it’s easy to lose pennies (or your local equivalent) because of rounding errors.
>
> _— Fowler, M., D. Rice, M. Foemmel, E. Hieatt, R. Mee, and R. Stafford,
> Patterns of Enterprise Application Architecture, Addison-Wesley, 2002._

Actual implementation uses `BigInt` to represent amount of money in the
smallest subunits of a currency. This enables computation of any arbitrary
amount of money in any currency.

* [Creating a Money Value](#creating-a-money-value)
* [Formatting](#formatting)
* [Comparison](#comparison)
* [Arithmetic Operations](#arithmetic-operations)
* [Allocation](#allocation)
  * [Allocation According to Ratios](#allocation-according-to-ratios)
  * [Allocation to N Targets](#allocation-to-n-targets)
* [Working with Currency](#working-with-currency)
  * [Directory of Currencies](#directory-of-currencies)
* [Money Coding](#money-coding)

## Creating a Money Value

`Money` can be instantiated providing amount in the minimal subunits of
currency (e.g. cents):

```dart
// Create a currency that normally displays 2 decimal places:
final usd = Currency.withCodeAndPrecision('USD', 2);

// Current a currency for Japan's yen with the correct symbol (we default to $)
final usd = Currency.withCodeAndPrecision('JPY', 0, '¥');

// Create a money value of $5.10 usd.
Money fiveDollars = Money.withInt(510, usd);

// Create a money value of $250.10 from a big int.
Money bigDollars = Money.withSubunits(BigInt.from(25010), usd);
```

## formatting

The money class provides a simple way of formatting currency using a pattern.

 pattern - 
     The supported patterns are:

     S outputs the currencies sign e.g. $.

     C outputs part of the currency symbol e.g. USD. You can specify 1,2 or 3 C's

        C - U

        CC - US

        CCC - USD

     # denotes a digit.

     0 denotes a digit and with the addition of defining leading and trailing zeros.

     , (comma) a placeholder for the grouping separtor

     . (period) a place holder fo rthe decimal separator 
     
     sign - the currencies sign. Defaults to $.

Examples:

```
final usd = Currency.withCodeAndPrecision('USD', 2);
Money costPrice = Money.withInt(100345.30, usd);  // 100,345.30 usd

costPrice.format("###,###.##); 
> 100,345.30

costPrice.format("S###,###.##); 
> $100,345.30

costPrice.format("CC###,###.##); 
> US100,345.30

costPrice.format("CCC###,###.##); 
> USD100,345.30

costPrice.format("SCC###,###.##); 
> $US100,345.30

final usd = Currency.withCodeAndPrecision('USD', 2);
Money costPrice = Money.withInt(45.30, usd);  // 45.30 usd
costPrice.format("SCC###,###.##); 
> $US100,345.30

final jpy = Currency.withCodeAndPrecision('JPY', 0, symbol = '¥');
Money costPrice = Money.withInt(345, jpy);  // 345 yen
costPrice.format("SCCC#); 
> ¥JPY245

// Bahraini dinar
final bhd = Currency.withCodeAndPrecision('BHD', 3, symbol='BD');
Money costPrice = Money.withInt(100345, jpy);  // 100.345 bhd
costPrice.format("SCCC0###.###); 
> BDBHD0100.345
```  

## Comparison

Equality operator (`==`) returns `true` when both operands are in the same
currency and have equal amount.

```dart
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
fiveDollars < sevenDollars; // => true
fiveDollars > sevenDollars; // => false
fiveEuros < fiveDollars;    // throws ArgumentError!
```

### Currency Predicates

To check that money value has an expected currency use methods
`isInCurrency(Currency)` and `isInSameCurrencyAs(Money)`:

```dart
fiveDollars.isInCurrency(usd); // => true
fiveDollars.isInCurrency(eur); // => false
```

```dart
fiveDollars.isInSameCurrencyAs(sevenDollars); // => true
fiveDollars.isInSameCurrencyAs(fiveEuros);    // => false
```

### Value Sign Predicates

To check if some money amount is a credit, a debit or zero, use predicates:

* `Money.isNegative` — returns `true` only if amount is less than `0`.
* `Money.isPositive` — returns `true` only if amount is greater than `0`.
* `Money.isZero` — returns `true` only if amount is `0`.

## Arithmetic Operations

`Money` provides next arithmetic operators:

* unary `-()`
* `+(Money)`
* `-(Money)`
* `*(num)`
* `/(num)`

**Operators `+` and `-` must be used with operands in same currency,
`ArgumentError` will be thrown otherwise.**

```dart
final tenDollars = fiveDollars + fiveDollars;
final zeroDollars = fiveDollars - fiveDollars;
```

Operators `*`, `/` receive a `num` as the second operand. Both operators use
_schoolbook rounding_ to round result up to a minimal subunit of a currency.

```dart
final fifteenCents = Money.withSubunits(BigInt.from(15), usd);

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
final profit = Money.withSubunits(BigInt.from(5), usd); // 5¢

var allocation = profit.allocationAccordingTo([70, 30]);
assert(allocation[0] == Money.withSubunits(BigInt.from(4), usd)); // 4¢
assert(allocation[1] == Money.withSubunits(BigInt.from(1), usd)); // 1¢

// The order of ratios is important:
allocation = profit.allocationAccordingTo([30, 70]);
assert(allocation[0] == Money.withSubunits(BigInt.from(2), usd)); // 2¢
assert(allocation[1] == Money.withSubunits(BigInt.from(3), usd)); // 3¢
```

### Allocation to N Targets

An amount of money can be allocated to N targets using `allocateTo()`.

```dart
final value = Money.withSubunits(BigInt.from(800), usd); // $8.00

final allocation = value.allocationTo(3);
assert(allocation[0] == Money.withSubunits(BigInt.from(267), usd)); // $2.67
assert(allocation[1] == Money.withSubunits(BigInt.from(267), usd)); // $2.67
assert(allocation[2] == Money.withSubunits(BigInt.from(266), usd)); // $2.66
```

## Working with Currency

`Currency` value-type carries the most important information about a currency:
`code` and `precision` (number of decimal places):

```dart
final usd = Currency.withCodeAndPrecision('USD', 2);

print(usd.code);      // => USD
print(usd.precision); // => 2
```

As a value-object, currency can be checked for equality (`==`) and used
as a key for map.

### Directory of Currencies

Usually you will not instantiate a `Currency` each time you need one.
Instead you can have some directory with currencies used in the application.

The interface `Currencies` is provided by the package for this purpose:

```dart
abstract class Currencies {
  /// Returns a [Currency] if found or `null`.
  Currency find(String code);
}
```

_**NOTE:** The method `find()` is synchronous! If you need to fetch currency
from a database or external service — make a component with asynchronous API
for fetching a whole directory of currencies at once._

The package also provides a few implementations of `Currencies`.

You can instantiate a directory from an `Iterable<Currency>`:

```dart
final currencies = Currencies.from([
  Currency.withCodeAndPrecision('USD', 2),
  Currency.withCodeAndPrecision('EUR', 2),
  Currency.withCodeAndPrecision('BTC', 8),
  Currency.withCodeAndPrecision('ETH', 18),
  // ...
]);
```

Or aggregate other directories:
```dart
final currencies = Currencies.aggregating([
  Currencies.from([usd, eur]),
  Currencies.from([btc, eth]),
  // ...
]);
```

## Money Coding

API for encoding/decoding a money value enables an application to store
value in a database or send over the network.

A money value can be encoded to any type. For example it can be coded
as a string in the format like "USD 5.00".

### Encoding

```dart
class MyMoneyEncoder implements MoneyEncoder<String> {
  String encode(MoneyData data) {
    // Receives MoneyData DTO and produce
    // a string representation of money value...
    
    double precisionFactor = BigInt.from(pow(10, data.currency.precision)

     String major =
        (data.subunits ~/ precisionFactor)).toString();
    String minor = (data.subunits % precisionFactor).toString();

    return major + "." + minor;
  }
}
```

```dart
final encoded = fiveDollars.encodedBy(MyMoneyEncoder());
// Now we can save `encoded` to database...
```

### Decoding

```dart
class MyMoneyDecoder implements MoneyDecoder<String> {

  Currencies _currencies;

  MyMoneyDecoder(this._currencies) {
    if (_currencies == null) {
      throw ArgumentError.notNull('currencies');
    }
  }

  /// Returns decoded [MoneyData] or throws a [FormatException].
  MoneyData decode(String encoded) {
    // If `encoded` has an invalid format throws FormatException;
    
    // Extracts currency code from `encoded`:
    final currencyCode = ...;

    // Tries to find information about a currency:
    final currency = _currencies.find(currencyCode);
    if (currency == null) {
      throw FormatException('Unknown currency: $currencyCode.');
    }
    
    // Using `currency.precision`, extracts subunits from `encoded`:
    final subunits = ...;
    
    return MoneyData.from(subunits, currency);
  }
}
```

```dart
try {
  final value = Money.decoding('USD 5.00', MyMoneyDecoder(myCurrencies));

  // ...
} on FormatException {
  // ...
}
```
