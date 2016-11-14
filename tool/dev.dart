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

  config.copyLicense
    ..directories = const['lib/', 'test/', 'example/'];

  await dev(args);
}
