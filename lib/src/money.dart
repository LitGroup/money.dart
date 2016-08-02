// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>

// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

part of ru.litgroup.money;

/// Money Value Object.
class Money implements Comparable<Money> {
  final int amount;
  final Currency currency;

  /// Constructs money value initialized with [amount] and [currency].
  ///
  /// Where [amount] expressed in the smallest units of currency (eg cents).
  Money(this.amount, this.currency) {
    if (amount == null) {
      throw new ArgumentError.notNull('amount');
    }
    if (currency == null) {
      throw new ArgumentError.notNull('currency');
    }
  }

  /// Checks whether a Money has the same Currency as this.
  bool isSameCurrency(Money other) {
    return currency == other.currency;
  }

  /// Returns `true` if [other] is [Money] with same amount and currency.
  @override
  bool operator ==(Object other) {
    return other is Money && isSameCurrency(other) && amount == other.amount;
  }

  @override
  int get hashCode {
    var result = 17;
    result = result * 37 + amount.hashCode;
    result = result * 37 + currency.hashCode;

    return result;
  }

  @override
  int compareTo(Money other) {
    _assertAcceptableMoneyArgument(other);

    return amount.compareTo(other.amount);
  }

  bool operator <(Money other) {
    return compareTo(other) < 0;
  }

  bool operator <=(Money other) {
    return compareTo(other) <= 0;
  }

  bool operator >(Money other) {
    return compareTo(other) > 0;
  }

  bool operator >=(Money other) {
    return compareTo(other) >= 0;
  }

  Money operator +(Money other) {
    _assertAcceptableMoneyArgument(other);

    return new Money(amount + other.amount, currency);
  }

  Money operator -(Money other) {
    _assertAcceptableMoneyArgument(other);

    return new Money(amount - other.amount, currency);
  }

  Money operator *(num multiplier) {
    _assertNotNull(multiplier, 'multiplier');

    return new Money(_round(amount * multiplier), currency);
  }

  Money operator /(num divider) {
    _assertNotNull(divider, 'divider');

    return new Money(
        _round(amount / divider),
        currency
    );
  }

  void _assertAcceptableMoneyArgument(Money money, [String name = 'other']) {
    _assertNotNull(money, name);
    _assertSameCurrency(money, name);
  }

  void _assertNotNull(Object arg, String name) {
    if (arg == null) {
      throw new ArgumentError.notNull(name);
    }
  }

  void _assertSameCurrency(Money other, String name) {
    if (!isSameCurrency(other)) {
      throw new ArgumentError.value(other, name, 'Currencies must be equal');
    }
  }

  int _round(num number) {
    return number.round();
  }
}
