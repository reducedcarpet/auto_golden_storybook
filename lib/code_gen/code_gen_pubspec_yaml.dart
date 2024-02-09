import 'dart:io';

String generatePubSpecFile(String projectName) {
  StringBuffer buffer = StringBuffer();

  buffer.writeln('name: $projectName');
  buffer.writeln('description: A new Flutter project.');
  buffer.writeln('publish_to: "none"');
  buffer.writeln("\n");
  buffer.writeln('version: 1.0.0+1');
  buffer.writeln("\n");
  buffer.writeln('environment:');
  buffer.writeln('  sdk: ">=3.0.0 <4.0.0"');
  buffer.writeln("\n");
  buffer.writeln('dependencies:');
  buffer.writeln('  flutter:');
  buffer.writeln('    sdk: flutter');
  buffer.writeln('  flutter_web_plugins:');
  buffer.writeln('    sdk: flutter');
  buffer.writeln('');
  buffer.writeln('  storybook_flutter: ^0.14.0');
  buffer.writeln("\n");
  buffer.writeln('dev_dependencies:');
  buffer.writeln('  flutter_test:');
  buffer.writeln('    sdk: flutter');
  buffer.writeln('  flutter_lints: ^3.0.1');
  buffer.writeln("\n");
  buffer.writeln('flutter:');
  buffer.writeln('  uses-material-design: true');
  buffer.writeln('  assets:');
  buffer.writeln('    - assets/');
  buffer.writeln("\n");

  return buffer.toString();
}

void saveGeneratedPubSpecFile(String projectName) {
  final content = generatePubSpecFile(projectName);
  final file = File('$projectName/pubspec.yaml');
  file.writeAsStringSync(content);
}