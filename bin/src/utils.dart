import 'dart:io';
import 'package:yaml/yaml.dart';

Future<String?> getPackageName() async {
  // Path to the pubspec.yaml file
  const pubspecPath = 'pubspec.yaml';
  try {
    // Read the pubspec.yaml file
    final pubspecContent = await File(pubspecPath).readAsString();

    // Parse the content of the pubspec.yaml file
    final doc = loadYaml(pubspecContent);

    // Extract the package name
    final packageName = doc['name'];

    return packageName?.toString();
  } catch (e) {
    print('Error reading pubspec.yaml: $e');
    return null;
  }
}

Future<String?> getProjectName() async {
  // Path to the pubspec.yaml file
  const pubspecPath = 'pubspec.yaml';
  try {
    // Read the pubspec.yaml file
    final pubspecContent = await File(pubspecPath).readAsString();

    // Parse the content of the pubspec.yaml file
    final doc = loadYaml(pubspecContent);

    // Extract the package name
    final projectName = doc['auto_golden_storybook']['name'];

    print("FOUND STORY BOOK NAME: $projectName");
    return projectName?.toString();
  } catch (e) {
    print('Error reading pubspec.yaml: $e');
    return null;
  }
}


