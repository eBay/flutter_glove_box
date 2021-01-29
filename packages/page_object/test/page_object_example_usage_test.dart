import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:page_object/page_object.dart';

void main() {
  testWidgets('My home widget has a title and message, NOT using PageObject',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(MyWidget(title: 'T', message: 'M')));
    final titleFinder = find.descendant(
      of: find.descendant(
        of: find.byType(MyApp),
        matching: find.byType(MyWidget),
      ),
      matching: find.byKey(MyWidget.titleKey),
    );
    final messageFinder = find.descendant(
      of: find.descendant(
        of: find.byType(MyApp),
        matching: find.byType(MyWidget),
      ),
      matching: find.byKey(MyWidget.messageKey),
    );
    expect(titleFinder, allOf(findsOneWidget, _HasText('T')));
    expect(messageFinder, allOf(findsOneWidget, _HasText('M')));
  });

  testWidgets('My home widget has a title and message, using PageObject',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(MyWidget(title: 'T', message: 'M')));
    final app = MyAppPageObject();
    expect(app.home.title, allOf(findsOneWidget, _HasText('T')));
    expect(app.home.message, allOf(findsOneWidget, _HasText('M')));
  });
}

/// This is an example root widget in an application. It is used here to
/// demonstrate nested [PageObject]'s
class MyApp extends StatelessWidget {
  const MyApp(this.home);
  final MyWidget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: home);
  }
}

///This is just a simple widget used to show the concept of a [PageObject].
class MyWidget extends StatelessWidget {
  const MyWidget({
    Key key,
    @required this.title,
    @required this.message,
  }) : super(key: key);
  final String title;
  final String message;

  static const Key titleKey = Key('MyWidget.title');
  static const Key messageKey = Key('MyWidget.message');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            key: titleKey,
          ),
        ),
        body: Center(
          child: Text(
            message,
            key: messageKey,
          ),
        ),
      ),
    );
  }
}

/// This is an example of a PageObject for an applications root widget.
/// Here [MyAppPageObject] can be used as a [Finder] and it includes a child
/// [PageObject].
class MyAppPageObject extends PageObject {
  MyAppPageObject() : super(find.byType(MyApp));

  MyWidgetPageObject get home => MyWidgetPageObject(this);
}

/// This is an example of a PageObject. Here [MyWidgetPageObject] can be used as
/// a [Finder] and it can include child finders or other PageObjects.
class MyWidgetPageObject extends PageObject {
  MyWidgetPageObject(Finder finder)
      : super(find.descendant(of: finder, matching: find.byType(MyWidget)));

  Finder get title =>
      find.descendant(of: this, matching: find.byKey(MyWidget.titleKey));

  Finder get message =>
      find.descendant(of: this, matching: find.byKey(MyWidget.messageKey));
}

/// This example was include to make the test feel more like a real scenario.
class _HasText extends CustomMatcher {
  _HasText(dynamic matcher) : super('Text data', 'data', matcher);

  @override
  Object featureValueOf(dynamic actual) {
    if (actual is Finder) {
      final element = actual.evaluate().single;
      final widget = element.widget;
      if (widget is Text) {
        return widget.data;
      } else {
        throw Exception('_HasText matcher can\'t be applied to $element');
      }
    } else {
      throw Exception(
          '_HasText matcher can only be applied to a Finder object');
    }
  }
}
