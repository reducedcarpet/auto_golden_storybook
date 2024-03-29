# Auto Generate Storybook
Pub.dev: [auto_golden_storybook](https://pub.dev/packages/auto_golden_storybook/score)

## Description
A command-line tool to auto generate a [storybook](https://pub.dev/packages/storybook_flutter) of your golden images. It automatically sets up a storybook subdirectory within your project, and populates it with 'story' objects for each golden image it finds in the test directory.  

Currently it will only use png images, and it will only accept one top level directory for the 'test' directory. 

## Usage
```shell
dart run auto_golden_storybook:create
```

## Configuration
You can put configuration in your pubspec.yaml or use them on the command line. For example:

```yaml
auto_golden_storybook:
  name: "project_storybook"
  test_dir: "test/goldens"
```
Or: 

```shell
dart run auto_golden_storybook:create --name=project_storybook --test_dir="test/goldens"
```

By default the created web project will be called: "storybook". It will assume your test directory is called "test" and will generate stories for all png images found in all subdirectories of the test directory.

There are a couple of generated files you can change for your own purposes, device_frame.dart and golden_image_container.dart. The device frame is part of the Storybook package and you can change that to use which ever frame you choose as a default. 

golden_image_container.dart is a widget that wraps the golden image in a container and scales away the border created by golden images. It also wraps it in a ListView so it can scroll. You can change how much scale it adds to deal with your own golden images.

## Roadmap
Automatically choose frame based on golden image size.
More Configuration Options
More Tests

## Contributing
Please suggest features or bugs on the issue tracker in Github. 

## License
MIT License - see the [LICENSE.md](LICENSE.md) file for details
