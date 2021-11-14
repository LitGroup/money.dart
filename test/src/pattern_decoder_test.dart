import 'package:money2/src/common_currencies.dart';
import 'package:money2/src/money.dart';
import 'package:money2/src/pattern_decoder.dart';
import 'package:test/test.dart';

void main() {
  test('pattern decoder unexpected minor units', () async {
    final btc = CommonCurrencies().btc;
    final btcDecoder = PatternDecoder(btc, btc.pattern);

    var moneyData = btcDecoder.decode('₿1');
    expect(moneyData.currency, equals(btc));
    expect(moneyData.integerPart.toInt(), equals(1));
    expect(moneyData.getMinorUnits().toInt(), equals(0));
    expect(moneyData.amount.minorUnits.toInt(), equals(100000000));

    moneyData = btcDecoder.decode('₿1.1999');
    expect(moneyData.currency, equals(btc));
    expect(moneyData.integerPart.toInt(), equals(1));

    expect(moneyData.getMinorUnits().toInt(), equals(19990000));
    expect(moneyData.amount.minorUnits.toInt(), equals(119990000));

    moneyData = btcDecoder.decode('₿.1999');
    expect(moneyData.currency, equals(btc));
    expect(moneyData.integerPart.toInt(), equals(0));

    expect(moneyData.getMinorUnits().toInt(), equals(19990000));
    expect(moneyData.amount.minorUnits.toInt(), equals(019990000));

    moneyData = btcDecoder.decode('₿0.1999');
    expect(moneyData.currency, equals(btc));
    expect(moneyData.integerPart.toInt(), equals(0));

    expect(moneyData.getMinorUnits().toInt(), equals(19990000));
    expect(moneyData.amount.minorUnits.toInt(), equals(019990000));

    final euro = CommonCurrencies().euro;
    final euroDecoder = PatternDecoder(euro, euro.pattern);
    moneyData = euroDecoder.decode('1€');
    expect(moneyData.currency, equals(euro));
    expect(moneyData.integerPart.toInt(), equals(1));
    expect(moneyData.getMinorUnits().toInt(), equals(0));
    expect(moneyData.amount.minorUnits.toInt(), equals(100));

    moneyData = euroDecoder.decode('1,1999€');
    expect(moneyData.currency, equals(euro));
    expect(moneyData.integerPart.toInt(), equals(1));

    expect(moneyData.getMinorUnits().toInt(), equals(19));
    expect(moneyData.amount.minorUnits.toInt(), equals(119));
  });

  test('Issue #53', () {
    final money = Money.parseWithCurrency('₿1.99', CommonCurrencies().btc);
    expect(money.format('#.###'), '1.990');
  });
}
