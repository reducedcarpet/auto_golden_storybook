import 'dart:io';

import 'code_gen_utils.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

import 'code_gen_constants.dart';

Future<String> generateStoryFile(
    String projectName, String testDirectory) async {
  final List<FileSystemEntity> goldenImages =
      await findAllGoldenImages(testDirectory);
  final List<Expression> stories = await generateAllStories(goldenImages);
  final List<Directive> directives = await generateAllDirectives(
    goldenImages,
    projectName,
  );

  final field = Field((b) => b
    ..name = 'stories'
    ..type = refer('List<Story>')
    ..modifier = FieldModifier.final$
    ..assignment = literalList(stories, refer('Story')).code);

  final library = Library(
    (b) => b
      ..body.add(field)
      ..directives.addAll(
        [
          Directive.import('package:storybook_flutter/storybook_flutter.dart'),
          ...directives,
        ],
      ),
  );

  final emitter = DartEmitter();

  return DartFormatter().format('${library.accept(emitter)}');
}

Future<void> saveGeneratedStoryFile(
    String projectName, String testDirectory) async {
  final content = generateStoryFile(projectName, testDirectory);
  final file = File('$projectName/lib/generated/$storiesFileName');
  file.writeAsStringSync(await content);
}

Expression generateStoryObjectForImage(String image, String path, String name) {
  final field = refer('Story').newInstance(
    [],
    {
      'name': literal("$path$name"),
      'builder': Method(
        (b) => b
          ..lambda = true
          ..requiredParameters.add(Parameter((b) => b..name = '_'))
          ..body = refer('${image}StorybookScreen').constInstance(
            [],
          ).code,
      ).closure,
    },
  );

  return field;
}

Directive generateDirectiveForImage(String image, String projectName) {
  return Directive.import('package:$projectName/generated/$image.g.dart');
}

Future<List<Directive>> generateAllDirectives(
  List<FileSystemEntity> goldenImages,
  String projectName,
) async {
  final List<Directive> directives = [];

  for (final FileSystemEntity image in goldenImages) {
    var entityType = await FileSystemEntity.type(image.path);
    if (entityType != FileSystemEntityType.file) {
      continue;
    }

    Logger.standard().stdout('Generating Story object for $image');

    final relative = encodedDartPath(image);

    directives.add(generateDirectiveForImage(relative, projectName));
  }

  return directives;
}

Future<List<Expression>> generateAllStories(
    List<FileSystemEntity> goldenImages) async {
  final List<Expression> stories = [];

  for (final FileSystemEntity image in goldenImages) {
    var entityType = await FileSystemEntity.type(image.path);
    if (entityType != FileSystemEntityType.file) {
      continue;
    }

    Logger.standard().stdout('Generating Story object for $image');

    String basename = getPascalCaseName(image);
    String originalName = path.basenameWithoutExtension(image.path);
    originalName = ReCase(originalName).pascalCase;

    String relative = relativePath(image);

    stories.add(
      generateStoryObjectForImage(
        basename,
        relative,
        originalName,
      ),
    );
  }

  return stories;
}
