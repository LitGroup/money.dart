// Copyright (c) 2023 LLC "LitGroup"
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is furnished
// to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import 'package:meta/meta.dart';

/// An alphabetic currency code.
///
/// ## Format Description
/// The code can contain from 3 to 10 Latin letters in uppercase only.
/// For example: 'RUR', 'USDT'.
@immutable
final class CurrencyCode {
  /// Creates self.
  ///
  /// Throws [ArgumentError] if the given [value] contains an invalid string.
  static CurrencyCode from(String value) {
    return tryFrom(value) ??
        (throw ArgumentError.value(value, 'value', 'Invalid currency code.'));
  }

  /// Creates self.
  ///
  /// Makes the same as [from()] factory, but returns `null` in case of invalid [value].
  static CurrencyCode? tryFrom(String value) {
    final pattern = RegExp(r'^[A-Z]{3,10}$');

    if (!pattern.hasMatch(value)) {
      return null;
    }

    return CurrencyCode._internal(value);
  }

  CurrencyCode._internal(this._value) {
    assert(_value.isNotEmpty,
        'Currency code cannot be created from empty string.');
  }

  final String _value;

  @override
  String toString() => _value;

  @override
  bool operator ==(Object other) =>
      other is CurrencyCode && other._value == _value;

  @override
  int get hashCode => _value.hashCode;
}
