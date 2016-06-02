library tool.dev;

import 'package:dart_dev/dart_dev.dart' show dev, config;

main(List<String> args) async {

  config.coverage
    ..html = true
    ..output = 'build/coverage/';

  await dev(args);
}
