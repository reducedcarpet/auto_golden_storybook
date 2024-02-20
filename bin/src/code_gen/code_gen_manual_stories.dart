import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'code_gen_constants.dart';

Future<String> generateManualStoryFile(
  String projectName,
  String testDirectory,
) async {
  final field = Field(
    (b) => b
      ..name = 'manualStories'
      ..type = refer('List<Story>')
      ..modifier = FieldModifier.final$
      ..assignment = literalList(
        [],
        refer('Story'),
      ).code,
  );

  final library = Library(
    (b) => b
      ..body.add(field)
      ..directives.addAll(
        [
          Directive.import('package:storybook_flutter/storybook_flutter.dart'),
        ],
      ),
  );

  final emitter = DartEmitter();

  return DartFormatter().format('${library.accept(emitter)}');
}

Future<void> saveGeneratedManualStoryFile(
  String projectName,
  String testDirectory,
) async {
  final content = generateManualStoryFile(projectName, testDirectory);
  final file = File('$projectName/lib/generated/$manualStoriesFileName');
  file.writeAsStringSync(await content);
}
