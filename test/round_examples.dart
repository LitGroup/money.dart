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

import 'test_examples.dart';

class RoundExample {
  final num operand;
  final int expectedResult;

  const RoundExample(this.operand, this.expectedResult);
}

const roundExamples = const TestExamples<RoundExample>(
    const[
      const RoundExample(2.2, 2),
      const RoundExample(2.4, 2),
      const RoundExample(2.5, 3),
      const RoundExample(2.6, 3),
      const RoundExample(2, 2),
      const RoundExample(-2.5, -3),
      const RoundExample(-2, -2),
      const RoundExample(-1.5, -2),
      const RoundExample(-8328.578947368, -8329),
      const RoundExample(-8328.5, -8329),
    ]
);