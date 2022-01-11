# Changelog

## 0.13.0

- Updated to Flutter 2.8 / Dart 2.15
- Resolved an issue where testGoldens() tests were mis-labeled as test groups, which caused issues in VSCode's text explorer. Thanks @DanTup for the fix!
- Updated documentation. Thanks @HugoHeneault, @nilsreichardt

## 0.12.0

- Add new convenience method to GoldenBuilder: ```.addScenarioBuilder('scenario name', (context) => widgetUnderTest)```. Thanks to @toshiossada for the contribution.

## 0.11.0

- migrate from pedantic -> flutter_lints
- resolved warning that could appear for consumers ```package:golden_toolkit has `uses-material-design: true` set but the primary pubspec contains `uses-material-design: false`. If the application needs material icons, then `uses-material-design`  must be set to true```
- updated documentation to indicate that you no longer need to include an empty images folder to get fonts to render in goldens for packages that do not contain any images.

## 0.10.0

This release has a few updates & changes.

- DeviceBuilder now wraps the widget under test with default MediaQuery behavior if not already wrapped. Thanks @lunaticcoding
- The signature of testGoldens() was made more flexible to allow for non String descriptions to better match the underlying support of testWidgets. Thanks @kuhnroyal
- testGoldens() no longer applies a default value for skipping tests, which allows for testGoldens tests to be skipped if their parent group has been marked as skipped.
- **BREAKING** The way that testGoldens() marks tests as "Goldens" is now achieved with Dart test tags, rather than by creating a test group with a nested test named Golden. This makes for a more intuitive experience in your IDE. Thanks @kuhnroyal

Note, this potentially can be a breaking change. If you previously ran tests by as such:

```sh
flutter test --update-goldens --name=Golden
```

you should now run

```sh
flutter test --update-goldens --tags=golden
```

## 0.9.0

This release adds null safety support for Flutter 2.0 / Dart 2.12.

Thanks to @daohoangson for the work on this!

## 0.8.0

Thanks to @tsimbalar for this enhancement.

A new configuration property has been added to `GoldenToolkitConfiguration` which allows you to opt-in to displaying real shadows in your goldens. By default, real shadows are disabled in Flutter tests due to inconsistencies in their implementation across versions. This behavior could always be toggled off in flutter tests via an obscure global variable. Now, you can easily specify a scoped value it in your configuration overrides.

## 0.7.0

Thanks to @moonytoes29 for the following enhancements:

A new helper widget `DeviceBuilder` has been added. This works conceptually similar to `GoldenBuilder` but is used for displaying multiple device renderings of a widget in a single golden. This is an alternative to the existing `multiScreenGolden()` API which captures separate golden images for each device variation under test.

To assist with usage of `DeviceBuilder`, there is a new helper API: `tester.pumpDeviceBuilder(builder)` which assists in easily pumping a DeviceBuilder widget in your tests. Check out the documentation for more details.

## 0.6.0

Added the ability to configure the default set of devices to use for `multiScreenGolden` assertions globally.

For example:
`GoldenToolkitConfiguration(defaultDevices: [Device.iphone11, Device.iphone11.dark()])`

As part of this, the default parameter value has been removed from `multiScreenGolden`.

There was also a minor breaking change in that the const constructor of GoldenToolkitConfiguration is no longer const.

## 0.5.1

Improved the reliability of the default behavior for `tester.waitForAssets()` to handle additional cases.

## 0.5.0

### More intelligent behavior for loading assets

A new mechanism has been added for ensuring that images have been decoded before capturing goldens. The old implementation worked most of the time, but was non-deterministic and hacky. The new implementation inspects the widget tree to identify images that need to be loaded. It should display images more consistently in goldens.

This may be a breaking change for some consumers. If you run into issues, you can revert to the old behavior, by applying the following configuration:

`GoldenToolkitConfiguration(primeAssets: legacyPrimeAssets);`

Additionally, you can provide your own implementation that extends the new default behavior:

```dart
GoldenToolkitConfiguration(primeAssets: (tester) async {
 await defaultPrimeAssets(tester);
 /* do anything custom */
});
```

If you run into issues, please submit issues so we can expand on the default behavior. We expect that it is likely missing some cases.

### New API for configuring the toolkit

Reworked the configuration API introduced in 0.4.0. The prior method relied on global state and could be error prone. The old implementation still functions, but has been marked as deprecated and will be removed in a future release.

The new API can be invoked in `flutter_test_config.dart` to be applied for all tests within a given folder (or the entire package). Additionally, if there is a need to override configuration at a narrower scope, this API can be invoked in-line as well.

```dart
GoldenToolkit.runWithConfiguration((){/* callback() */}, config: GoldenToolkitConfiguration(/* custom config here */));
```

### Added the ability to customize the generated filenames

When using `screenMatchesGolden` or `multiGoldenFile`, you can now supply your own functions for controlling the naming of the files. This can be done using the configuration API mentioned above.

```dart
GoldenToolkit.runWithConfiguration((){ /* callback() */}, config: GoldenToolkitConfiguration(fileNameFactory: (filename) => '' /*output filename*/));
```

There are two methods that can be overridden:

- `fileNameFactory` is used for screenMatchesGolden
- `deviceFileNameFactory` is used for multiScreenGolden

Future releases will likely consolidate these APIs.

Thanks to @christian-muertz for this enhancement.

### Added additional utility functions for preparing for goldens

Extracted out some public extension methods that were previously private implementation details of `multiScreenGolden` & `screenMatchesGolden`

Added the following extensions. These can be used with any vanilla golden assertions and do not require `multiScreenGolden`, `screenMatchesGolden`, or `GoldenBuilder`.

```dart
// configures the simulated device to mirror the supplied device configuration (dimensions, pixel density, safe area, etc)
await tester.binding.applyDeviceOverrides(device);

// resets any configuration applied by applyDeviceOverrides
await tester.binding.resetDeviceOverrides();

// runs a block of code with the simulated device settings and automatically clears upon completion
await tester.binding.runWithDeviceOverrides(device, body: (){});

// convenience helper for configurating the safe area... the built-in paddingTestValue is difficult to work with
tester.binding.window.safeAreaTestValue = EdgeInsets.all(8);

// a stand-alone version of the image loading mechanism described at the top of these release notes. Will wait for all images to be decoded
// so that they will for sure appear in the golden.
await tester.waitForAssets();
```

### Misc Changes

A few API / parameters were marked as deprecated and will be removed in future releases.

## 0.4.0

### Configuration API

Added a configuration API so that you can control the behavior of skipping golden assertions in a single location, rather than at each call to `screenMatchesGolden` or `multiScreenGolden`.

You can now call:

```dart
//place in /test/test_config.dart
// typical conditions will be platform checks:
//    () => TargetPlatform.isLinux
//    () => !TargetPlatform.isMacOS
GoldenToolkit.configure(GoldenToolkitConfiguration(skipGoldenAssertion: () => /* some condition */));
```

### Auto-Sized Goldens

A new optional parameter `autoHeight` has been added to `screenMatchesGolden` and `multiScreenGolden`. If set to true, the height of the golden will adapt to fit the widget under test. Thanks to @christian-muertz!

## 0.3.2

Additional support for Cupertino fonts in Goldens.

## 0.3.1+1

Corrected the update command in `README.md`.

## 0.3.1

Resolve an issue where configuration performed on WidgetTester during multiScreenGolden could bleed over to other tests in the same file. Add additional convenience helpers for the Device class.

## 0.3.0

Add support for configuring safe area (to simulate a device notch) and platform brightness (light/dark mode) on a multiScreenGolden device.

## 0.2.3

Breaking: Removed Future return type from `testGoldens`.

## 0.2.2

Added `deviceSetup` to multiscreenGolden to allow pumping customization when device configuration (ex: screen size) changes

## 0.2.1

Dropping pre-release tag. Improved documentation.

## 0.2.1-dev

Resolved an issue when using `loadAppFonts()` to unit test a non-application package which includes one or more custom fonts.

## 0.2.0-dev

Improved the mechanism for loading font assets. Consumers no longer need to supply a directory to read the .ttf files from.

They can now simply call: `await loadAppFonts()` and the package will automatically load any font assets from their pubspec.yaml or
from any packages they depend on.

## 0.1.0-dev

Initial release. Includes utility methods for easily pumping complex widgets, loading real fonts, and for writing more advanced Golden-based tests.

Features

- `GoldenBuilder` for widget integration tests that visually indicate different states of a widgets in a single Golden test.
- `multiScreenGolden` for pumping a widget and performing multiple Golden assertions with different device characteristics (e.g. screen size, accessibility options, etc)

_We expect to make breaking changes over the next few releases as we stabilize the API._
