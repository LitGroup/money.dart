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

    test('Exchange Rates - precision 1', () {
      final Currency twd = Currency.create('TWD', 0, symbol: 'NT\$');
      final Currency usd = Currency.create('USD', 2);

      final Money twdM = Money.fromInt(1000, twd);
      expect(twdM.toString(), equals(r'NT$1000.00'));

      final twdToUsdRate = Money.fromInt(3, usd); // 1 TWD = 0.03 USD
      expect(twdToUsdRate.toString(), equals(r'$0.03'));

      final usdM = twdM.exchangeTo(twdToUsdRate);
      expect(usdM.toString(), equals(r'$30.00'));

      final Currency usdExchange =
          Currency.create('USD', 6, pattern: 'S0.000000');

      final acurateTwdToUsdRate =
          Money.fromInt(35231, usdExchange); // 1 TWD = 0.035231 USD
      expect(acurateTwdToUsdRate.toString(), equals(r'$0.035231'));

      expect(acurateTwdToUsdRate.format('S0.00'), equals(r'$0.03'));

      final usdMaccurate = twdM.exchangeTo(acurateTwdToUsdRate);
      expect(usdMaccurate.toString(), equals(r'$35.231000'));
    });

    test('Exchange Rates - precision 2', () {
      final jpy = Currency.create('JPY', 0, symbol: '¥');
      final twd = Currency.create('TWD', 0, symbol: 'NT\$');

      final twdM = Money.fromInt(1000, twd);
      expect(twdM.toString(), equals(r'NT$1000.00'));

      final twdToJpyRate = Money.fromInt(3, jpy);
      expect(twdToJpyRate.toString(), equals('¥3.00'));

      final jpyM = twdM.exchangeTo(twdToJpyRate);
      expect(jpyM.toString(), equals('¥3000.00'));
    });
  });
}
