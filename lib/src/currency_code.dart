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

/// The value-type representing an alphabetical currency code.
///
/// ```dart
///  final rur = CurrencyCode('RUR');
/// ```
///
/// [CurrencyCode] interprets the given value in the case insensitive way:
///
/// ```dart
/// assert(CurrencyCode('RUR') == CurrencyCode('rur'));
/// ```
///
/// DO NOT use an empty value for the instantiation of the code, this ends up
/// with an assertion failure in the debug mode.
@immutable
final class CurrencyCode {
  CurrencyCode(String value)
      : assert(value.isNotEmpty, 'Currency code should not be empty.'),
        _value = value,
        _canonicalValue = value.toUpperCase();

  final String _value;

  final String _canonicalValue;

  /// Returns the original value of the code provided during the instantiation.
  @override
  String toString() => _value;

  /// Makes case insensitive check for equality.
  ///
  /// ```dart
  /// assert(CurrencyCode('RUR') == CurrencyCode('rur'));
  /// ```
  @override
  bool operator ==(Object other) =>
      other is CurrencyCode && other._canonicalValue == _canonicalValue;

  @override
  int get hashCode => _canonicalValue.hashCode;
}
