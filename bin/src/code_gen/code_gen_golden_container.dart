import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'code_gen_constants.dart';

Future<String> generateGoldenContainerFile(
    String projectName, String testDirectory) async {
  final classGen = Class(
    (b) => b
      ..name = 'GoldenImageContainer'
      ..extend = refer('StatelessWidget')
      ..constructors.add(
        Constructor(
          (b) => b
            ..constant = true
            ..optionalParameters.addAll(
              [
                Parameter(
                  (b) => b
                    ..name = 'key'
                    ..named = true
                    ..toSuper = true,
                ),
                Parameter(
                  (b) => b
                    ..name = 'image'
                    ..toThis = true
                    ..named = true
                    ..required = true,
                ),
              ],
            ),
        ),
      )
      ..fields.add(
        Field(
          (b) => b
            ..name = 'image'
            ..modifier = FieldModifier.final$
            ..type = refer('AssetImage'),
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
                refer('ListView')
                    .newInstance(
                      [],
                      {
                        'children': literalList(
                          [
                            refer('Transform.scale').newInstance(
                              [],
                              {
                                'scaleX': literal(1.045),
                                'scaleY': literal(1.03),
                                'child': refer('Center').newInstance(
                                  [],
                                  {
                                    'child': refer('Image').newInstance(
                                      [],
                                      {
                                        'image': refer('image'),
                                        'fit': refer('BoxFit.fitWidth'),
                                      },
                                    ),
                                  },
                                ),
                              },
                            ),
                          ],
                        ),
                      },
                    )
                    .returned
                    .statement,
              ],
            ),
        ),
      ),
  );

  final library = Library(
    (b) => b
      ..body.add(classGen)
      ..directives.addAll(
        [
          Directive.import('package:flutter/material.dart'),
        ],
      ),
  );

  final emitter = DartEmitter();

  return DartFormatter().format('${library.accept(emitter)}');
}

Future<void> saveGeneratedGoldenContainerFile(
    String projectName, String testDirectory) async {
  final content = generateGoldenContainerFile(projectName, testDirectory);
  final file = File('$projectName/lib/generated/$goldenContainerFileName');
  file.writeAsStringSync(await content);
}
