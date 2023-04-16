import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  const maxScale = 100;
  const maxInts = 100;

  test('scale 0-$maxScale test', () {
    for (var scale = 0; scale <= maxScale; scale++) {
      final str = scale == 0 ? '1' : '1.${'0' * (scale - 1)}1';
      final fmt = scale == 0 ? 'S#' : '#.${'#' * scale}';
      expect(Fixed.parse(str, scale: scale).format(fmt), str,
          reason: 'Failed with $scale scale');
    }
  });

  test('integers 0-$maxInts test', () {
    for (var ints = 0; ints <= maxInts; ints++) {
      final str = ints == 0 ? '0' : '9' * ints;
      const fmt = '#';
      expect(Fixed.parse(str, scale: 0).format(fmt), str,
          reason: 'Failed with $ints ints');
    }
  });

  test('scale 0-$maxScale and integers 0-$maxInts test', () {
    for (var scale = 0; scale <= maxScale; scale++) {
      for (var ints = 0; ints <= maxInts; ints++) {
        final intsStr = ints == 0 ? '0' : '9' * ints;
        final str = scale == 0 ? intsStr : '$intsStr.${'0' * (scale - 1)}1';

        // Fixed doesn't like leading zeroes!
        final expectIntsStr = (ints == 0 && scale == 0)
            ? '0'
            : ints == 0
                ? ''
                : '9' * ints;
        final expectStr =
            scale == 0 ? expectIntsStr : '$expectIntsStr.${'0' * (scale - 1)}1';

        final fmt = scale == 0 ? '#' : '#.${'#' * scale}';

        expect(Fixed.parse(str, scale: scale).format(fmt), expectStr,
            reason: 'Failed with $scale scale, $ints ints');
      }
    }
  });
}
