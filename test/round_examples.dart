// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>

// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

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