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
  return getProjectArgument('name');
}

Future<String?> getProjectArgument(String arg) async {
  // Path to the pubspec.yaml file
  const pubspecPath = 'pubspec.yaml';
  try {
    // Read the pubspec.yaml file
    final pubspecContent = await File(pubspecPath).readAsString();

    // Parse the content of the pubspec.yaml file
    final doc = loadYaml(pubspecContent);

    String? projectName;

    // Extract the package name
    if (doc['auto_golden_storybook'] != null) {
      projectName = doc['auto_golden_storybook'][arg];
    }

    return projectName?.toString();
  } catch (e) {
    print('Error reading pubspec.yaml: $e');
    return null;
  }
}
