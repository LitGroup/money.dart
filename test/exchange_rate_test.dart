import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('Exchange Rates', () {
    test('Exchange Rates', () {
      var aud = Currency.create('AUD', 2);
      var usd = Currency.create('USD', 2);
      var invoiceAmount = Money.fromInt(1000, aud);
      var auToUsExchangeRate = Money.fromInt(68, usd);
      var us680 = Money.fromInt(680, usd);

      expect(invoiceAmount.exchangeTo(auToUsExchangeRate), equals(us680));
    });
  });
}
