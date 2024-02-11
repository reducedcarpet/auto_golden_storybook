import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'code_gen_constants.dart';

Future<String> generateDeviceFile(String projectName, String testDirectory) async {
  final deviceField = refer('final device')
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
      .statement;

  final library = Library(
    (b) => b
      ..body.add(deviceField)
      ..directives.addAll(
        [
          Directive.import('package:flutter/material.dart'),
          Directive.import('package:storybook_flutter/storybook_flutter.dart'),
        ],
      ),
  );

  final emitter = DartEmitter();

  return DartFormatter().format('${library.accept(emitter)}');
}

Future<void> saveGeneratedDeviceFrameFile(
    String projectName, String testDirectory) async {
  final content = generateDeviceFile(projectName, testDirectory);
  final file = File('$projectName/lib/generated/$deviceFrameFileName');
  file.writeAsStringSync(await content);
}
