// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

part of ru.litgroup.money;

/// Money Value Object.
class Money {
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
}
