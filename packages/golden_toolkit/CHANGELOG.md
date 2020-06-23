# Changelog

## 0.5.0

### New API for configuring the toolkit

Reworked the configuration API introduced in 0.4.0. The prior method relied on global state and could be error prone. The old implementation still functions, but has been marked as deprecated and will be removed in a future release.

The new API can be invoked in `flutter_test_config.dart` to be applied for all tests within a given folder (or the entire package). Additionally, if there is a need to override configuration at a narrower scope, this API can be invoked in-line as well.

```dart
GoldenToolkit.runWithConfiguration((){/* callback() */}, config: GoldenToolkitConfiguration(/* custom config here */));
```

### Added the ability to customize the generated filenames

When using ```screenMatchesGolden``` or ```multiGoldenFile```, you can now supply your own functions for controlling the naming of the files. This can be done using the configuration API mentioned above.

```dart
GoldenToolkit.runWithConfiguration((){ /* callback() */}, config: GoldenToolkitConfiguration(fileNameFactory: (filename) => '' /*output filename*/));
```

There are two methods that can be overridden:

* ```fileNameFactory``` is used for screenMatchesGolden
* ```deviceFileNameFactory``` is used for multiScreenGolden

Future releases will likely consolidate these APIs.

Thanks to @christian-muertz for this enhancement.

### Misc Changes

A few API / parameters were marked as deprecated and will be removed in future releases.

## 0.4.0

### Configuration API

Added a configuration API so that you can control the behavior of skipping golden assertions in a single location, rather than at each call to ```screenMatchesGolden``` or ```multiScreenGolden```.

You can now call:

```dart
//place in /test/test_config.dart
// typical conditions will be platform checks:
//    () => TargetPlatform.isLinux
//    () => !TargetPlatform.isMacOS
GoldenToolkit.configure(GoldenToolkitConfiguration(skipGoldenAssertion: () => /* some condition */));
```

### Auto-Sized Goldens

A new optional parameter ```autoHeight``` has been added to ```screenMatchesGolden``` and ```multiScreenGolden```. If set to true, the height of the golden will adapt to fit the widget under test. Thanks to @christian-muertz!

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
