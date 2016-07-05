// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

part of ru.litgroup.money;

class Money {
  final int amount;
  final Currency currency;

  Money(this.amount, this.currency) {
    if (amount == null) {
      throw new ArgumentError.notNull('amount');
    }
    if (currency == null) {
      throw new ArgumentError.notNull('currency');
    }
  }
}