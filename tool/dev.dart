// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

library tool.dev;

import 'package:dart_dev/dart_dev.dart' show dev, config;

main(List<String> args) async {

  config.analyze
    ..fatalWarnings = true
    ..hints = true
    ..fatalHints = true
    ..strong = true;

  config.test
    ..unitTests = const['test/'];

  config.coverage
    ..html = true
    ..output = 'build/coverage/';

  await dev(args);
}
