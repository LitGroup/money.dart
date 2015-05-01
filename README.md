Money
=====

Dart implementation of Fowler's Money pattern.

[![Coverage Status](https://coveralls.io/repos/Dartiny/money/badge.svg)](https://coveralls.io/r/Dartiny/money)

Example
-------

```dart
import 'package:money/money.dart';

void main() {
    final a = new Money(100, new Currency('USD');
    final b = new Money(200, new Currency('USD');
    
    final sum = a + b;
    
    print(sum); // Prints "3.00 USD"
}
```
