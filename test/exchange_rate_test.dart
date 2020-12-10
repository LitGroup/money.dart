import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('Exchange Rates', () {
    test('Exchange Rates', () {
      final aud = Currency.create('AUD', 2);
      final usd = Currency.create('USD', 2);
      final invoiceAmount = Money.fromInt(1000, aud);
      final auToUsExchangeRate = Money.fromInt(68, usd);
      final us680 = Money.fromInt(680, usd);

      expect(invoiceAmount.exchangeTo(auToUsExchangeRate), equals(us680));
    });
  });
}
