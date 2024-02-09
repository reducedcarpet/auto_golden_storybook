import 'dart:io';

Future<int> flutterCreateWeb(String projectName) async {
  // Define the command and arguments
  String command = "flutter";
  var arguments = ['create', '--platforms', 'web', projectName];

  // Start the process
  var process = await Process.start(command, arguments, runInShell: true);

  // Capture and print the output
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);

  // Wait for the process to complete and get the exit code
  final int exitCode = await process.exitCode;
  if (exitCode == 0) {
    print('Project $projectName created successfully.');
  } else {
    print('Failed to create project $projectName.');
  }

  return exitCode;
}

Future<void> flutterBuildWeb(String projectName) async {
  String commandBuild = "flutter";
  var argumentsBuild = ['build', 'web'];

  // Start the Build process
  var processBuild = await Process.start(
    commandBuild,
    argumentsBuild,
    runInShell: true,
    workingDirectory: projectName,
  );

  // Capture and print the output
  await stdout.addStream(processBuild.stdout);
  await stderr.addStream(processBuild.stderr);

  // Wait for the process to complete and get the exit code
  final int exitCode = await processBuild.exitCode;

  if (exitCode == 0) {
    print('Project $projectName built for web successfully.');
  } else {
    print('Failed to build web project $projectName.');
  }
}

Future<void> dartFixApply(String projectName) async {
  String commandBuild = "dart";
  var argumentsBuild = ['fix', '--apply'];

  // Start the Build process
  var processBuild = await Process.start(
    commandBuild,
    argumentsBuild,
    runInShell: true,
    workingDirectory: projectName,
  );

  // Capture and print the output
  await stdout.addStream(processBuild.stdout);
  await stderr.addStream(processBuild.stderr);

  // Wait for the process to complete and get the exit code
  final int exitCode = await processBuild.exitCode;

  if (exitCode == 0) {
    print('Project $projectName applied dart lints successfully.');
  } else {
    print('Failed to dart fix project $projectName.');
  }
}
