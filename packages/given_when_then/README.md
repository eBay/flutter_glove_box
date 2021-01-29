# given_when_then

A Flutter package for creating more readable tests. If you are not familiar with 
[Flutter's Widget tests](https://flutter.dev/docs/cookbook/testing/widget/introduction) please take a moment to review them.

**Given** we feel that our tests are the best documentation of the behaviors in our code.  
**When** we read our tests.  
**Then** we want them to be easy to understand.

Flutter widget tests are great but they can be a little verbose. The intention of this package is to 
enable code reuse while making our tests more readable. Consider this very simple widget test case 
from [Flutter's Widget tests documentation](https://flutter.dev/docs/cookbook/testing/widget/introduction).

### Without given_when_then
```dart
testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(title: 'T', message: 'M'));
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
});
```

### With given_when_then
```dart
testWidgets('MyWidget has a title and message', harness((given, when, then) async {
    await given.pumpMyWidget(title: 'T', message: 'M');
    then.myTitleIs('T');
    then.myMessageIs('M');
  }));
```

As you can see, we are able to remove the details that are not important by moving them into the classes [WidgetTestGiven](lib/src/widget_test_harness.dart), [WidgetTestWhen](lib/src/widget_test_harness.dart), and [WidgetTestThen](lib/src/widget_test_harness.dart).

For a complete example of how to use this please look at sample tests here: [example_widget_test_support.dart](test/example_widget_test_support.dart)

## License Information

Copyright 2019-2020 eBay Inc.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

- Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the following disclaimer
  in the documentation and/or other materials provided with the
  distribution.
- Neither the name of eBay Inc. nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.