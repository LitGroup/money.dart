import 'package:money2/money2.dart';

void main() {
  final usd = Currency.create('USD', 2);
  Money costPrice = Money.fromInt(10034530, usd); // 100,345.30 usd

  costPrice.format("###,###.##");
// > 100,345.30

  costPrice.format("S###,###.##");
// > $100,345.3

  costPrice.format("CC###,###.#0");
// > US100,345.30
}
