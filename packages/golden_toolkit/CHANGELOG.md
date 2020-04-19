# Changelog

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
