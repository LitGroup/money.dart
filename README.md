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

This package provides the value type `EmailAddress` to have a typed
representation of the e-mail address with the encapsulated validation.

## Getting started

1. Install the package as a dependency, running the command in the shell:

    ```sh
    dart pub add money
    ```

2. Import the library:

    ```dart
   import 'package:money/money.dart';
    ```
