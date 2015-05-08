Money
=====

Dart implementation of [Fowler's Money pattern](http://martinfowler.com/eaaCatalog/money.html).

[![Pub version](https://img.shields.io/pub/v/money.svg?style=flat-square)](https://pub.dartlang.org/packages/money)
[![Licnse](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/Dartiny/money/blob/master/LICENSE)
[![Coverage Status](https://img.shields.io/coveralls/Dartiny/money.svg?style=flat-square)](https://coveralls.io/r/Dartiny/money)


Usage Examples
--------------

### Creating a Money object and accessing its monetary value
```dart

// Create a money object that represents 1 USD
var money = new Money(100, new Currency('USD'));

// Access the Money object's monetary value
print(money.amount); // => 100

// -- OR --
print(money.amountAsString); // => 1.00
```

#### Creating a Money object from a string value
```dart
var money = new Money.fromString('12.50', new Currency('USD'));


print(money.amount); // => 1250
```

#### Creating a money from a double value
```dart
var money = new Money.fromDouble(12.34, new Currency('USD'));


print(money.amount); // => 1234
```


### Simple conversion to a string
```dart
var money = new Money(150, new Currency('USD'));

print(money.toString()); // => 1.50 USD
```


### Basic arithmetic using Money objects

```dart
// Create two Money objects that represent 1 USD and 2 USD, respectively
final a = new Money(100, new Currency('USD'));
final b = new Money(200, new Currency('USD'));

var c = null;

// Negate a Money object
c = -a;
print(c); // => -1.00 USD

// Calculate the sum of two Money objects
c = a + b;
print(c); // => 3.00 USD


// Calculate the difference of two Money objects
c = b - a;
print(c); // => 1.00 USD

// Multiply a Money object with a factor
c = a * 2;
print(c); // => 2.00 USD
```


### Comparing Money objects
```dart
final a = new Money(100, new Currency('USD'));
final b = new Money(200, new Currency('USD'));

a < b; // => true
a > b; // => false

b <= a; // => false
b => a; // => true

a.compareTo(b); // => -1
a.compareTo(a); // =>  0
b.compareTo(a); // =>  1
```

The `compareTo()` method returns an integer less than, equal to, or greater than zero if the value of one `Money` object is considered to be respectively less than, equal to, or greater than that of another `Money` object.

`Money` implements `Comparable` interface and you can sort a list of `Money` objects.

### Allocate the monetary value represented by a Money object using a list of ratios
```dart
final a = new Money(5, new Currency('USD'));

for (var c in a.allocate(3, 7)) {
  print(c);
}
```

The code above produces the output shown below:
```dart
2
3
```
