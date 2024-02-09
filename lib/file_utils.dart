import 'dart:io';

bool deleteTestDirectory(String projectName) {
  final String currentDirectory = Directory.current.path;
  final dir = Directory('$currentDirectory/$projectName/test');
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
    return true;
  }
  return false;
}