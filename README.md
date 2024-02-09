# Auto Generate Storybook

## Description
A command-line tool to auto generate a [storybook](https://pub.dev/packages/storybook_flutter) of your golden images. It automatically sets up a storybook subdirectory within your project, and populates it with 'story' objects for each golden image it finds in the test directory.  

## Usage
```shell
dart run auto_golden_storybook:create
```

## Configuration
You can put configuration in your pubspec.yaml or use them on the command line. For example:

```yaml
auto_golden_storybook:
  name: "project_storybook"
```
Or: 

```shell
dart run auto_golden_storybook:create --name=project_storybook
```

By default the created web project will be called: "storybook". It will assume your test directory is called "test" and will generate stories for all images found in all subdirectories of the test directory.

## Roadmap
Automatically choose frame based on golden image size. 

## Contributing
Please suggest features or bugs on the issue tracker in Github. 

## License
MIT License - see the [LICENSE.md](LICENSE.md) file for details
