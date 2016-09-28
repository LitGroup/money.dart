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

class AllocationExample {
  final int amount;
  final List<int> ratios;
  final List<int> allocatedAmounts;

  const AllocationExample(this.amount, this.ratios, this.allocatedAmounts);
}

const allocationExamples = const TestExamples<AllocationExample>(const[
  const AllocationExample(0, const[1, 1], const[0, 0]),
  const AllocationExample(1, const[1, 1], const[1, 0]),
  const AllocationExample(2, const[1, 1], const[1, 1]),
  const AllocationExample(2, const[1, 0], const[2, 0]),
  const AllocationExample(2, const[0, 1], const[0, 2]),
  const AllocationExample(100, const[1, 1, 1], const[34, 33, 33]),
  const AllocationExample(101, const[1, 1, 1], const[34, 34, 33]),
  const AllocationExample(5, const[3, 7], const[2, 3]),
  const AllocationExample(5, const[7, 3], const[4, 1]),
  const AllocationExample(-5, const[1, 1], const[-2, -3]),
  const AllocationExample(-5, const[7, 3], const[-3, -2]),
  const AllocationExample(-5, const[3, 7], const[-1, -4]),
]);

class AllocationToTargetsExample {
  final int amount;
  final int numberOfTargets;
  final List<int> allocatedAmounts;

  const AllocationToTargetsExample(this.amount, this.numberOfTargets,
      this.allocatedAmounts);
}

const allocationToTargetsExamples = const TestExamples<
    AllocationToTargetsExample>(const[
  const AllocationToTargetsExample(15, 1, const[15]),
  const AllocationToTargetsExample(15, 2, const[8, 7]),
  const AllocationToTargetsExample(10, 2, const[5, 5]),
  const AllocationToTargetsExample(10, 3, const[4, 3, 3]),
  const AllocationToTargetsExample(15, 3, const[5, 5, 5]),
]);
