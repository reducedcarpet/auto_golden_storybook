import 'package:args/args.dart';
import 'package:auto_golden_storybook/code_gen/code_gen_goldens.dart';
import 'package:auto_golden_storybook/code_gen/code_gen_main.dart';
import 'package:auto_golden_storybook/code_gen/code_gen_pubspec_yaml.dart';
import 'package:auto_golden_storybook/code_gen/code_gen_stories.dart';
import 'package:auto_golden_storybook/code_gen/code_gen_utils.dart';
import 'package:auto_golden_storybook/file_utils.dart';
import 'package:cli_util/cli_logging.dart';

import 'src/defaults.dart';
import 'src/flutter_commands.dart';
import 'src/utils.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser();

  parser.addOption('name');

  final parsedArgs = parser.parse(args);

  String? projectName = parsedArgs['name'] as String?;
  projectName ??= await getProjectName();

  final superProjectName = await getPackageName();

  createFlutterWebProject(
    projectName ?? projectNameDefault,
    superProjectName!,
  );
}

Future<void> createFlutterWebProject(String projectName, String superPackageName) async {
  // TODO check first for test directory to find goldens.

  final int exitCode = await flutterCreateWeb(projectName);

  if (exitCode != 0) {
    return;
  }

  Logger.standard().stdout('Project $projectName created successfully.');

  deleteTestDirectory(projectName);
  Logger.standard().stdout('Deleted Test Directory of new Project.');

  await generateGoldenCode(projectName);

  await dartFixApply(projectName);

  await flutterBuildWeb(projectName);
}

Future<void> generateGoldenCode(String projectName) async {
  // generate code
  await codeGenGoldens(projectName);
  Logger.standard().stdout('Project $projectName generated goldens successfully.');

  await moveGoldensToAssets(projectName);
  Logger.standard()
      .stdout('Project $projectName copied golden images to assets successfully.');

  saveGeneratedStoryFile(projectName);
  Logger.standard().stdout('Project $projectName generated stories.dart successfully.');

  saveGeneratedMainFile(projectName);
  Logger.standard().stdout('Project $projectName generated main.dart successfully.');

  saveGeneratedPubSpecFile(projectName);
  Logger.standard().stdout('Project $projectName generated pubspec.yaml successfully.');
}
