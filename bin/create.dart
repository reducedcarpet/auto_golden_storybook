import 'package:args/args.dart';
import 'src/code_gen/code_gen_device_frame.dart';
import 'src/code_gen/code_gen_golden_container.dart';
import 'src/code_gen/code_gen_goldens.dart';
import 'src/code_gen/code_gen_main.dart';
import 'src/code_gen/code_gen_manual_stories.dart';
import 'src/code_gen/code_gen_pubspec_yaml.dart';
import 'src/code_gen/code_gen_stories.dart';
import 'src/code_gen/code_gen_utils.dart';
import 'src/utils/file_utils.dart';
import 'package:cli_util/cli_logging.dart';

import 'src/defaults.dart';
import 'src/flutter_commands.dart';
import 'src/utils/utils.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser();

  parser.addOption('name');
  parser.addOption('test_dir');

  final parsedArgs = parser.parse(args);

  String? projectName = parsedArgs['name'];
  projectName ??= await getProjectName();

  final superProjectName = await getPackageName();

  String? testDirectory = parsedArgs['test_dir'];
  testDirectory ??= await getProjectArgument("test_dir");

  createFlutterWebProject(
    projectName ?? projectNameDefault,
    superProjectName!,
    testDirectory ?? testDirectoryDefault,
  );
}

Future<void> createFlutterWebProject(
  String projectName,
  String superPackageName,
  String testDirectory,
) async {
  final int exitCode = await flutterCreateWeb(projectName);

  if (exitCode != 0) {
    return;
  }

  Logger.standard().stdout('Project $projectName created successfully.');

  deleteTestDirectory(projectName);
  Logger.standard().stdout('Deleted Test Directory of new Project.');

  await generateGoldenCode(projectName, testDirectory);

  await dartFixApply(projectName);

  await flutterBuildWeb(projectName);
}

Future<void> generateGoldenCode(
    String projectName, String testDirectory) async {
  // TODO check first for test directory to find goldens.

  // generate code
  await codeGenGoldens(projectName, testDirectory);
  Logger.standard().stdout(
    'Project $projectName generated goldens successfully.',
  );

  await moveGoldensToAssets(projectName, testDirectory);
  Logger.standard().stdout(
    'Project $projectName copied golden images to assets successfully.',
  );

  saveGeneratedDeviceFrameFile(projectName, testDirectory);
  Logger.standard().stdout(
    'Project $projectName generated device_frame.dart successfully.',
  );

  saveGeneratedGoldenContainerFile(projectName, testDirectory);
  Logger.standard().stdout(
    'Project $projectName generated golden_image_container.dart for story widgets successfully.',
  );

  saveGeneratedStoryFile(projectName, testDirectory);
  Logger.standard().stdout(
    'Project $projectName generated stories.dart successfully.',
  );

  saveGeneratedManualStoryFile(projectName, testDirectory);
  Logger.standard().stdout(
    'Project $projectName generated manual_stories.dart successfully.',
  );

  saveGeneratedMainFile(projectName);
  Logger.standard().stdout(
    'Project $projectName generated main.dart successfully.',
  );

  saveGeneratedPubSpecFile(projectName);
  Logger.standard().stdout(
    'Project $projectName generated pubspec.yaml successfully.',
  );
}
