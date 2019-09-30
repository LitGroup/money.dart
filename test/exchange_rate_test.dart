import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('Exchange Rates', () {
    test('Exchange Rates', () {
      Currency aud = Currency.create("AUD", 2);
      Currency usd = Currency.create("USD", 2);
      Money invoiceAmount = Money.fromInt(1000, aud);
      Money auToUsExchangeRate = Money.fromInt(68, usd);
      Money us680 = Money.fromInt(680, usd);

      expect(invoiceAmount.exchangeTo(auToUsExchangeRate), equals(us680));
    });
  });
}
