import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

Future<void> saveGeneratedPage(String fileName, String contents) async {
  File file = File(fileName);
  await file.writeAsString(contents);
}

Future<void> moveGoldensToAssets(String projectName) async {
  Directory assetsDir = Directory('$projectName/assets');
  if (!await assetsDir.exists()) {
    await assetsDir.create();
  }

  final goldenImages = await findAllGoldenImages();
  for (final FileSystemEntity image in goldenImages) {
    var entityType = await FileSystemEntity.type(image.path);
    if (entityType != FileSystemEntityType.file) {
      continue;
    }

    File imageFile = File(image.path);
    try {
      await imageFile.copy('$projectName/assets/${encodedImagePath(image)}');
    } catch (e) {
      print("Error copying file: $e");
    }
  }
}

String subtractTestPath(FileSystemEntity image) {
  final String currentDirectory = Directory.current.path + "\\test";
  String relative = path.relative(image.path, from: currentDirectory);
  return relative;
}

String relativePath(FileSystemEntity image) {
  String relative = subtractTestPath(image);
  // strip file name
  relative = relative.substring(0, relative.lastIndexOf(path.basename(image.path)));
  relative = relative.replaceAll("\\", "/");
  return relative;
}

String encodedImagePath(FileSystemEntity image) {
  String relative = subtractTestPath(image);

  relative = relative.replaceAll("\\", "__");
  relative = relative.replaceAll("/", "__");

  return relative;
}

String encodedDartPath(FileSystemEntity image) {
  String relative = subtractTestPath(image);

  relative = relative.replaceAll("\\", "__");
  relative = relative.replaceAll("/", "__");

  return path.basenameWithoutExtension(relative);
}

String encodedKebabPath(FileSystemEntity image) {
  String relative = subtractTestPath(image);

  relative = relative.replaceAll("\\", "_");
  relative = relative.replaceAll("/", "_");

  return path.basenameWithoutExtension(relative);
}

String getPascalCaseName(FileSystemEntity image) {
  String imagePath = encodedKebabPath(image);
  String basename = path.withoutExtension(imagePath);
  ReCase reCase = ReCase(basename);
  basename = reCase.pascalCase;
  return basename;
}

Future<List<FileSystemEntity>> findAllGoldenImages() async {
  final String currentDirectory = Directory.current.path;

  final dir = Directory('$currentDirectory\\test');
  final List<FileSystemEntity> entities = await checkDirectoryForImages(dir);
  return entities;
}

Future<List<FileSystemEntity>> checkDirectoryForImages(Directory dir) async {
  final List<FileSystemEntity> entities = await dir.list().toList();
  final List<FileSystemEntity> result = [];

  for (final FileSystemEntity entity in entities) {
    var entityType = await FileSystemEntity.type(entity.path);
    if (entityType == FileSystemEntityType.file) {
      if (!path.extension(entity.path).toLowerCase().endsWith(".dart")) {
        result.add(entity);
      }
    } else if (entityType == FileSystemEntityType.directory) {
      result.addAll(
        await checkDirectoryForImages(Directory(entity.path)),
      );
    }
  }

  return result;
}
