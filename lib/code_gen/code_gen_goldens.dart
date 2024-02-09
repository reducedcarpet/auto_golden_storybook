import 'dart:io';

import 'package:auto_golden_storybook/code_gen/code_gen_utils.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as path;

String generateImagePage(FileSystemEntity image) {
  String basename = getPascalCaseName(image);

  final imagePage = Class(
    (b) => b
      ..name = '${basename}StorybookScreen'
      ..extend = refer('StatelessWidget', 'package:flutter/material.dart')
      ..constructors.add(
        Constructor(
          (b) => b
            ..constant = true // Make the constructor constant
            ..optionalParameters.add(
              Parameter(
                (b) => b
                  ..name = 'key'
                  ..toSuper = true // Forward to the super class constructor
                  ..named = true
                  ..type = refer('Key?', 'package:flutter/material.dart'),
              ),
            ),
        ),
      )
      ..methods.add(
        Method(
          (b) => b
            ..name = 'build'
            ..annotations.add(
              refer('override'),
            )
            ..returns = refer('Widget', 'package:flutter/material.dart')
            ..requiredParameters.add(
              Parameter(
                (b) => b
                  ..name = 'context'
                  ..type = refer('BuildContext'),
              ),
            )
            ..body = Block.of(
              [
                refer('Image', 'package:flutter/material.dart')
                    .constInstance(
                      [],
                      {
                        'image': refer('AssetImage', 'package:flutter/painting.dart')
                            .newInstance(
                          [
                            literalString("assets/${encodedImagePath(image)}"),
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
      ..body.add(imagePage)
      ..directives.addAll(
        [
          Directive.import('package:flutter/material.dart'),
          Directive.import('package:flutter/painting.dart'),
        ],
      ),
  );

  final emitter = DartEmitter();

  return DartFormatter().format('${library.accept(emitter)}');
}

Future<void> codeGenGoldens(String projectName) async {
  final goldenImages = await findAllGoldenImages();
  Directory generateDir = Directory('$projectName/lib/generated');
  if (!await generateDir.exists()) {
    await generateDir.create();
  }

  for (final FileSystemEntity image in goldenImages) {
    var entityType = await FileSystemEntity.type(image.path);
    if (entityType != FileSystemEntityType.file) {
      continue;
    }

    String basename = path.basename(image.path);
    String relative = encodedImagePath(image);

    final encodedName = basename.endsWith('.png')
        ? '${path.withoutExtension(relative)}.g.dart'
        : relative;

    final imagePage = generateImagePage(image);
    await saveGeneratedPage('$projectName/lib/generated/$encodedName', imagePage);
  }
}
