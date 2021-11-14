import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  group('Exchange Rates', () {
    test('Exchange Rates', () {
      final aud = Currency.create('AUD', 2);
      final usd = Currency.create('USD', 2);
      final invoiceAmount = Money.fromIntWithCurrency(1000, aud);
      final auToUsExchangeRate =
          ExchangeRate.fromMinorUnits(68, scale: 2, toCode: 'USD');
      final us680 = Money.fromIntWithCurrency(680, usd);

      expect(invoiceAmount.exchangeTo(auToUsExchangeRate), equals(us680));
    });

    test('Exchange Rates - precision 1', () {
      final Currency twd = Currency.create('TWD', 0, symbol: 'NT\$');
      final Currency usd = Currency.create('USD', 2);

      final Money twdM = Money.fromIntWithCurrency(1000, twd);
      expect(twdM.toString(), equals(r'NT$1000.00'));

      final twdToUsdRate = ExchangeRate.fromMinorUnits(3,
          scale: 2, toCode: 'USD'); // 1 TWD = 0.03 USD
      expect(twdToUsdRate.toString(), equals(r'$0.03'));

      final usdM = twdM.exchangeTo(twdToUsdRate);
      expect(usdM.toString(), equals(r'$30.00'));

      final Currency usdExchange =
          Currency.create('USD', 6, pattern: 'S0.000000');

      final acurateTwdToUsdRate = ExchangeRate.fromMinorUnits(35231,
          scale: 6, toCode: 'USD', toScale: 6); // 1 TWD = 0.035231 USD
      expect(acurateTwdToUsdRate.toString(), equals(r'$0.035231'));

      expect(acurateTwdToUsdRate.format('S0.00'), equals(r'$0.03'));

      final usdMaccurate = twdM.exchangeTo(acurateTwdToUsdRate);
      expect(usdMaccurate.format('S#.######'), equals(r'$35.231000'));
    });

    test('Exchange Rates - precision 2', () {
      final jpy = Currency.create('JPY', 0, symbol: '¥');
      final twd = Currency.create('TWD', 0, symbol: 'NT\$');

      final twdM = Money.fromWithCurrency(1000, twd);
      expect(twdM.toString(), equals(r'NT$1000.00'));

      final twdToJpyRate =
          ExchangeRate.fromMinorUnits(3, scale: 0, toCode: 'JPY');
      expect(twdToJpyRate.toString(), equals('¥3'));

      final jpyM = twdM.exchangeTo(twdToJpyRate);
      expect(jpyM.toString(), equals('¥3000'));
    });
  });
}
