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

  bool get isZero => amount == 0;
  bool get isPositive => amount > 0;
  bool get isNegative => amount < 0;

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

    return _newMoney(amount + other.amount);
  }

  Money operator -() {
    return _newMoney(-amount);
  }

  Money operator -(Money other) {
    _assertAcceptableMoneyArgument(other);

    return _newMoney(amount - other.amount);
  }

  Money operator *(num multiplier) {
    _assertNotNull(multiplier, 'multiplier');

    return _newMoney(_round(amount * multiplier));
  }

  Money operator /(num divider) {
    _assertNotNull(divider, 'divider');
    if (divider == 0) {
      throw new ArgumentError.value(
          divider, 'divider', 'Division of a money by zero is forbidden.');
    }

    return _newMoney(_round(amount / divider));
  }

  List<Money> allocate(List<int> ratios) {
    _assertNotNull(ratios, 'ratios');

    final shares = new List<int>(ratios.length);
    final total = _calculateRatiosTotal(ratios);
    var remainder = amount;

    for (var i = 0; i < ratios.length; ++i) {
      var share = (amount * ratios[i] / total).floor();
      remainder -= share;
      shares[i] = share;
    }

    for (var i = 0; remainder > 0; ++i) {
      shares[i] += 1;
      remainder -= 1;
    }

    return new List<Money>.unmodifiable(shares.map(_newMoney));
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

  Money _newMoney(int amount) => new Money(amount, currency);

  int _round(num number) {
    return number.round();
  }

  int _calculateRatiosTotal(List<int> ratios) {
    var total = 0;
    for (var ratio in ratios) {
      if (ratio == null) {
        throw new ArgumentError.value(ratios, 'ratios', 'Cannon contain null');
      }
      if (ratio < 0) {
        throw new ArgumentError.value(
            ratio, 'ratios', 'Cannot contain a negative value.');
      }
      total += ratio;
    }

    if (total == 0) {
      throw new ArgumentError.value(
          ratios, 'ratios', 'Sum of ratios must not be 0');
    }

    return total;
  }
}
