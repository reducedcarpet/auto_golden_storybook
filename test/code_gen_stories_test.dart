import '../bin/src/code_gen/code_gen_stories.dart';
import 'package:code_builder/code_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('generateStoryObjectForImage', () {
    test('should return Expression for image story with correct path and name', () {
      // Arrange
      final image = 'my_image';
      final path = 'path/to/';
      final name = 'images';
      final expected =
          "Story(name: 'path/to/images', builder: (_) => const my_imageStorybookScreen(), )";

      // Act
      final result = generateStoryObjectForImage(
        image,
        path,
        name,
      )
          .accept(
            DartEmitter(),
          )
          .toString();

      // Assert
      expect(result, expected);
    });

    test('should return Expression for image story with empty path', () {
      // Arrange
      final image = 'another_image';
      final path = '';
      final name = 'AnotherImage';
      final expected =
          "Story(name: 'AnotherImage', builder: (_) => const another_imageStorybookScreen(), )";

      // Act
      final result = generateStoryObjectForImage(
        image,
        path,
        name,
      )
          .accept(
            DartEmitter(),
          )
          .toString();

      // Assert
      expect(result, expected);
    });

    test('should return Expression for image story with empty name', () {
      // Arrange
      final image = 'yet_another_image';
      final path = 'another/path/';
      final name = '';
      final expected =
          "Story(name: 'another/path/', builder: (_) => const yet_another_imageStorybookScreen(), )";

      // Act
      final result = generateStoryObjectForImage(
        image,
        path,
        name,
      )
          .accept(
            DartEmitter(),
          )
          .toString();

      // Assert
      expect(result, expected);
    });
  });

  group('generateDirectiveForImage', () {
    test('should return Directive for image with correct project name and image name',
        () {
      // Arrange
      final image = 'my_image';
      final projectName = 'my_project';
      final expected = "import 'package:my_project/generated/my_image.g.dart';";

      // Act
      final result = generateDirectiveForImage(
        image,
        projectName,
      )
          .accept(
            DartEmitter(),
          )
          .toString();

      // Assert
      expect(result, expected);
    });

    test('should return Directive for image with empty project name', () {
      // Arrange
      final image = 'another_image';
      final projectName = '';
      final expected = "import 'package:/generated/another_image.g.dart';";

      // Act
      final result = generateDirectiveForImage(
        image,
        projectName,
      )
          .accept(
            DartEmitter(),
          )
          .toString();

      // Assert
      expect(result, expected);
    });

    test('should return Directive for image with empty image name', () {
      // Arrange
      final image = '';
      final projectName = 'yet_another_project';
      final expected = "import 'package:yet_another_project/generated/.g.dart';";

      // Act
      final result = generateDirectiveForImage(
        image,
        projectName,
      )
          .accept(
            DartEmitter(),
          )
          .toString();

      // Assert
      expect(result, expected);
    });
  });
}

