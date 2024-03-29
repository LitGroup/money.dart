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

import 'currency_code.dart';

@immutable
final class Currency {
  Currency(this.code, {required this.precision}) {
    if (precision.isNegative) {
      throw ArgumentError(
          'Precision of the currency cannot be negative', 'precision');
    }
  }

  final CurrencyCode code;

  final int precision;

  @override
  bool operator ==(Object other) {
    if (other is Currency && other.code == code) {
      assert(precision == other.precision,
          'Semantic error: the precision of currencies with same code must be the same.');

      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code.toString();
}
