import 'dart:io';

import 'code_gen_constants.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

String generateMainFile(String projectName) {
  String mainFileContents = "";

  final method = Method(
    (b) => b
      ..name = 'main'
      ..returns = refer('void')
      ..body = Block.of(
        [
          refer('runApp').call([refer('const StorybookApp()')]).statement,
        ],
      ),
  );

  final library = Library(
    (b) => b
      ..body.add(method)
      ..directives.addAll(
        [
          Directive.import('package:storybook_flutter/storybook_flutter.dart'),
          Directive.import('package:flutter/material.dart'),
          Directive.import('package:$projectName/generated/$storiesFileName'),
        ],
      ),
  );

  final emitter = DartEmitter();

  mainFileContents = DartFormatter().format('${library.accept(emitter)}');

  final deviceField = refer('DeviceFramePlugin').newInstance(
    [],
    {
      'initialData': refer('').newInstance(
        [],
        {
          'device': refer('device'),
          'orientation': refer('Orientation.portrait'),
          'isFrameVisible': literal(true),
        },
      ),
    },
  );

  final classGen = Class(
    (b) => b
      ..name = 'StorybookApp'
      ..extend = refer('StatelessWidget')
      ..constructors.add(
        Constructor(
          (b) => b
            ..constant = true
            ..optionalParameters.add(
              Parameter(
                (b) => b
                  ..name = 'key'
                  ..named = true
                  ..toSuper = true,
              ),
            ),
        ),
      )
      ..methods.add(
        Method(
          (b) => b
            ..name = 'build'
            ..annotations.add(refer('override'))
            ..returns = refer('Widget')
            ..requiredParameters.add(
              Parameter(
                (b) => b
                  ..name = 'context'
                  ..type = refer('BuildContext'),
              ),
            )
            ..body = Block.of(
              [
                refer('final device')
                    .assign(
                      refer('DeviceInfo.genericPhone').call(
                        [],
                        {
                          'platform': refer('TargetPlatform.iOS'),
                          'id': refer('"id"'),
                          'name': refer('"IPhone"'),
                          'screenSize': refer('const Size(428, 926)'),
                        },
                      ),
                    )
                    .statement,
                refer('Storybook')
                    .newInstance(
                      [],
                      {
                        'plugins': literalList([deviceField]),
                        'stories': refer('stories'),
                      },
                    )
                    .returned
                    .statement,
              ],
            ),
        ),
      ),
  );

  mainFileContents += "\n\n";
  mainFileContents += DartFormatter().format('${classGen.accept(emitter)}');

  return mainFileContents;
}

void saveGeneratedMainFile(String projectName) {
  final content = generateMainFile(projectName);
  final file = File('$projectName/lib/main.dart');
  file.writeAsStringSync(content);
}
