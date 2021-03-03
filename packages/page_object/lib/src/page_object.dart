import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// This class exists so page objects can seamlessly be passed to widget testing
/// APIs as Finders. This helps to remove code noise from tests. See the tests
/// in this package for an example.
class PageObject extends Finder {
  /// Creates a [PageObject] for this [Finder]
  PageObject(this._finder);
  final Finder _finder;

  @override
  Iterable<Element> apply(Iterable<Element> candidates) => _finder.apply(candidates);

  @override
  String get description => _finder.description;

  @override
  Iterable<Element> evaluate() => _finder.evaluate();

  @override
  bool precache() => _finder.precache();
}
