// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

import 'package:test/test.dart' as testlib;

class TestExamples<E> {
  final List<E> _examples;

  const TestExamples(List<E> examples)
      : _examples = examples;

  void test(String name, body(E example)) {
    for (var i = 0; i < _examples.length; ++i) {
      testlib.test('$name (Example #$i)', () {
        body(_examples[i]);
      });
    }
  }
}