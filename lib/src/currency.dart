// The MIT License (MIT)
//
// Copyright (c) 2015 - 2016 Roman Shamritskiy
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

part of money;

/// Currency Value Object.
///
/// Holds Currency specific data.
class Currency {
  /// This currency code.
  final String code;

  /// Constructor.
  ///
  /// Argument [code] is required, it must not be null or empty.
  Currency(this.code) {
    if (code == null) {
      throw new ArgumentError.notNull("code");
    }
    if (code.trim().isEmpty) {
      throw new ArgumentError.value(code, "code", "Cannot be empty");
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Currency && other.code == code;
  }

  @override
  int get hashCode {
    return 17 * 37 + code.hashCode;
  }
}
