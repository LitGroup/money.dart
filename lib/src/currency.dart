// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

part of ru.litgroup.money;

/// Currency Value Object.
///
/// Holds Currency specific data.
class Currency {
  /// This currency code.
  final String code;

  /// Constructor.
  ///
  /// Argument [code] is required, it cannot be null or empty string.
  Currency(this.code) {
    if (code == null) {
      throw new ArgumentError.notNull('code');
    }
    if (code.trim().isEmpty) {
      throw new ArgumentError('Argument "code" cannot be an empty string');
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Currency && other.code == code;
  }

  @override
  int get hashCode {
     return 54 * 37 + code.hashCode;
  }
}