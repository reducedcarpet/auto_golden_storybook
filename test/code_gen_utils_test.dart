import 'dart:io';

import '../bin/src/code_gen/code_gen_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('subtractTestPath', () {
    test('should return correct path', () {
      // Arrange
      final testDirectory = Directory.current.path + '/test';
      final imagePath = '$testDirectory/image.jpg';
      final imageFile = File(imagePath);

      // Act
      final result = subtractTestPath(imageFile);

      // Assert
      expect(result, 'image.jpg');
    });

  });

  group('relativePath', () {
    test('should return relative path without file name', () {
      // Arrange
      final testDirectory = Directory.current.path + '/test';
      final imagePath = '$testDirectory/images/image.jpg';
      final imageFile = File(imagePath);

      // Act
      final result = relativePath(imageFile);

      // Assert
      expect(result, 'images/');
    });

    test('should return empty string if image is directly inside test directory', () {
      // Arrange
      final testDirectory = Directory.current.path + '/test';
      final imagePath = '$testDirectory/image.jpg';
      final imageFile = File(imagePath);

      // Act
      final result = relativePath(imageFile);

      // Assert
      expect(result, '');
    });
  });

  group('getPascalCaseName', () {
    test('should return PascalCase name for image with kebab-case filename', () {
      // Arrange
      final testDirectory = Directory.current.path + '/test';
      final imagePath = '$testDirectory/my-image-file.jpg';
      final imageFile = File(imagePath);

      // Act
      final result = getPascalCaseName(imageFile);

      // Assert
      expect(result, 'MyImageFile');
    });

    test('should return PascalCase name for image with snake_case filename', () {
      // Arrange
      final testDirectory = Directory.current.path + '/test';
      final imagePath = '$testDirectory/my_image_file.jpg';
      final imageFile = File(imagePath);

      // Act
      final result = getPascalCaseName(imageFile);

      // Assert
      expect(result, 'MyImageFile');
    });

    test('should return PascalCase name for image with mixed-case filename', () {
      // Arrange
      final testDirectory = Directory.current.path + '/test';
      final imagePath = '$testDirectory/My_Image-file.jpg';
      final imageFile = File(imagePath);

      // Act
      final result = getPascalCaseName(imageFile);

      // Assert
      expect(result, 'MyImageFile');
    });
  });
}
