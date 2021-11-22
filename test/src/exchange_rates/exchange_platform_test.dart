import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  test('default scale ...', () async {
    final platform = ExchangePlatform();

    final aud = Money.fromNum(1, scale: 2, code: 'AUD');
    final usd = Money.fromNum(0.75312, scale: 2, code: 'USD');

    /// use target currency scale
    platform.register(ExchangeRate.fromFixed(
      Fixed.fromNum(0.75312, scale: 5),
      fromCode: 'AUD',
      toCode: 'USD',
    ));

    final t1 = platform.exchangeTo(aud, 'USD');
    expect(t1, equals(Money.fromNum(0.75312, scale: 2, code: 'USD')));
    expect(t1.scale, equals(2));

    /// Use the automatic inverse rate
    final t2 = platform.exchangeTo(usd, 'AUD');
    expect(t2, equals(Money.fromNum(1, scale: 2, code: 'AUD')));
    expect(t2.scale, equals(2));
  });

  test('controlled scale ...', () async {
    final platform = ExchangePlatform();

    final aud = Money.fromNum(1, scale: 2, code: 'AUD');
    final usd = Money.fromNum(0.75312, scale: 5, code: 'USD');

    /// control the target scale.
    platform.register(ExchangeRate.fromFixed(Fixed.fromNum(0.75312, scale: 5),
        fromCode: 'AUD', toCode: 'USD', toScale: 5));

    final t1 = platform.exchangeTo(aud, 'USD');
    expect(t1, equals(Money.fromNum(0.75312, scale: 5, code: 'USD')));
    expect(t1.scale, equals(5));

    /// Use the automatic inverse rate
    final t2 = platform.exchangeTo(usd, 'AUD');
    expect(t2, equals(Money.fromNum(1, scale: 5, code: 'AUD')));
    expect(t2.scale, equals(5));
  });
}
