# Changelog

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
