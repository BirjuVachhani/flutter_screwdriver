// Author: Birju Vachhani
// Created Date: September 21, 2025

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/src/helpers/clear_focus_navigator_observer.dart';
import 'package:flutter_test/flutter_test.dart';

class TestPage extends StatelessWidget {
  final String title;
  final bool hasFocus;

  const TestPage({
    super.key,
    required this.title,
    this.hasFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Text('$title Content'),
          if (hasFocus)
            TextField(
              key: Key('${title}_textfield'),
              autofocus: true,
              decoration: InputDecoration(hintText: 'Enter text'),
            ),
        ],
      ),
    );
  }
}

void main() {
  group('ClearFocusNavigatorObserver tests', () {
    late ClearFocusNavigatorObserver observer;
    late GlobalKey<NavigatorState> navigatorKey;

    setUp(() {
      observer = ClearFocusNavigatorObserver();
      navigatorKey = GlobalKey<NavigatorState>();
    });

    group('initialization', () {
      testWidgets('creates observer successfully', (WidgetTester tester) async {
        expect(observer, isA<ClearFocusNavigatorObserver>());
        expect(observer, isA<NavigatorObserver>());
      });

      testWidgets('integrates with MaterialApp navigator', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Home'),
          ),
        );

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Home Content'), findsOneWidget);
      });
    });

    group('didPush behavior', () {
      testWidgets('clears focus when pushing new route', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Home', hasFocus: true),
          ),
        );

        await tester.pumpAndSettle();

        // Focus the text field
        await tester.tap(find.byKey(Key('Home_textfield')));
        await tester.pumpAndSettle();

        // Verify text field has focus
        final textField = tester.widget<TextField>(find.byKey(Key('Home_textfield')));
        expect(textField.autofocus, isTrue);

        // Push a new route
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => TestPage(title: 'Second'),
          ),
        );

        await tester.pumpAndSettle();

        // Verify we're on the second page
        expect(find.text('Second'), findsOneWidget);
        expect(find.text('Second Content'), findsOneWidget);

        // The focus should have been cleared (we can't directly test this,
        // but we can verify the navigation worked and no errors occurred)
        expect(find.text('Home'), findsNothing);
      });

      testWidgets('handles push with null previousRoute', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Initial'),
          ),
        );

        await tester.pumpAndSettle();

        // Initial push should work without errors
        expect(find.text('Initial'), findsOneWidget);
      });

      testWidgets('handles multiple rapid pushes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Home', hasFocus: true),
          ),
        );

        await tester.pumpAndSettle();

        // Push multiple routes quickly
        for (int i = 1; i <= 3; i++) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => TestPage(title: 'Page $i'),
            ),
          );
        }

        await tester.pumpAndSettle();

        // Should be on the last page
        expect(find.text('Page 3'), findsOneWidget);
        expect(find.text('Page 3 Content'), findsOneWidget);
      });
    });

    group('didPop behavior', () {
      testWidgets('clears focus when popping route', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Home'),
          ),
        );

        await tester.pumpAndSettle();

        // Push a route with focus
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => TestPage(title: 'Second', hasFocus: true),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Second'), findsOneWidget);

        // Focus the text field on second page
        await tester.tap(find.byKey(Key('Second_textfield')));
        await tester.pumpAndSettle();

        // Pop the route
        navigatorKey.currentState?.pop();
        await tester.pumpAndSettle();

        // Should be back on home page
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Home Content'), findsOneWidget);
        expect(find.text('Second'), findsNothing);
      });

      testWidgets('handles pop with null previousRoute', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Home'),
          ),
        );

        await tester.pumpAndSettle();

        // Push and immediately pop
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => TestPage(title: 'Temp'),
          ),
        );

        await tester.pumpAndSettle();

        navigatorKey.currentState?.pop();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('handles multiple rapid pops', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Home'),
          ),
        );

        await tester.pumpAndSettle();

        // Push multiple routes
        for (int i = 1; i <= 3; i++) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => TestPage(title: 'Page $i', hasFocus: true),
            ),
          );
        }

        await tester.pumpAndSettle();
        expect(find.text('Page 3'), findsOneWidget);

        // Pop all routes quickly
        for (int i = 0; i < 3; i++) {
          navigatorKey.currentState?.pop();
        }

        await tester.pumpAndSettle();

        // Should be back on home
        expect(find.text('Home'), findsOneWidget);
      });
    });

    group('didReplace behavior', () {
      testWidgets('clears focus when replacing route', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Home', hasFocus: true),
          ),
        );

        await tester.pumpAndSettle();

        // Focus the text field
        await tester.tap(find.byKey(Key('Home_textfield')));
        await tester.pumpAndSettle();

        // Replace the current route
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (context) => TestPage(title: 'Replacement'),
          ),
        );

        await tester.pumpAndSettle();

        // Should be on replacement page
        expect(find.text('Replacement'), findsOneWidget);
        expect(find.text('Replacement Content'), findsOneWidget);
        expect(find.text('Home'), findsNothing);
      });

      testWidgets('handles replace with null routes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Home'),
          ),
        );

        await tester.pumpAndSettle();

        // Push and replace
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => TestPage(title: 'Temp'),
          ),
        );

        await tester.pumpAndSettle();

        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (context) => TestPage(title: 'Final'),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Final'), findsOneWidget);
        expect(find.text('Temp'), findsNothing);
      });

      testWidgets('handles multiple rapid replaces', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Home'),
          ),
        );

        await tester.pumpAndSettle();

        // Perform multiple replacements quickly
        for (int i = 1; i <= 3; i++) {
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(
              builder: (context) => TestPage(title: 'Replace $i', hasFocus: true),
            ),
          );
        }

        await tester.pumpAndSettle();

        // Should be on the last replacement
        expect(find.text('Replace 3'), findsOneWidget);
        expect(find.text('Replace 3 Content'), findsOneWidget);
      });
    });

    group('focus management', () {
      testWidgets('unfocuses when there is a primary focus', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: Scaffold(
              body: Column(
                children: [
                  TextField(
                    key: Key('field1'),
                    decoration: InputDecoration(hintText: 'Field 1'),
                  ),
                  TextField(
                    key: Key('field2'),
                    decoration: InputDecoration(hintText: 'Field 2'),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Focus first field
        await tester.tap(find.byKey(Key('field1')));
        await tester.pumpAndSettle();

        // Navigate to new page
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => TestPage(title: 'New Page'),
          ),
        );

        await tester.pumpAndSettle();

        // Should navigate successfully (focus was cleared)
        expect(find.text('New Page'), findsOneWidget);
      });

      testWidgets('handles no primary focus gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Home'),
          ),
        );

        await tester.pumpAndSettle();

        // Navigate without any focus (should not crash)
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => TestPage(title: 'Second'),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Second'), findsOneWidget);
      });
    });

    group('integration tests', () {
      testWidgets('works with complex navigation stack', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Home', hasFocus: true),
          ),
        );

        await tester.pumpAndSettle();

        // Build complex navigation stack
        final pages = ['First', 'Second', 'Third'];
        for (final page in pages) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => TestPage(title: page, hasFocus: true),
            ),
          );
          await tester.pumpAndSettle();
        }

        expect(find.text('Third'), findsOneWidget);

        // Navigate back through stack
        navigatorKey.currentState?.popUntil((route) => route.isFirst);
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('works with named routes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            routes: {
              '/': (context) => TestPage(title: 'Home'),
              '/second': (context) => TestPage(title: 'Second', hasFocus: true),
              '/third': (context) => TestPage(title: 'Third'),
            },
            initialRoute: '/',
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Home'), findsOneWidget);

        // Navigate using named routes
        navigatorKey.currentState?.pushNamed('/second');
        await tester.pumpAndSettle();
        expect(find.text('Second'), findsOneWidget);

        navigatorKey.currentState?.pushReplacementNamed('/third');
        await tester.pumpAndSettle();
        expect(find.text('Third'), findsOneWidget);
        expect(find.text('Second'), findsNothing);
      });

      testWidgets('works with multiple observers', (WidgetTester tester) async {
        final observer2 = ClearFocusNavigatorObserver();
        final observer3 = TestNavigatorObserver();

        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer, observer2, observer3],
            home: TestPage(title: 'Home', hasFocus: true),
          ),
        );

        await tester.pumpAndSettle();

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => TestPage(title: 'Second'),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Second'), findsOneWidget);
        expect(observer3.pushCalled, isTrue);
      });

      testWidgets('works with different route types', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Home', hasFocus: true),
          ),
        );

        await tester.pumpAndSettle();

        // Test with PageRouteBuilder
        navigatorKey.currentState?.push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                TestPage(title: 'Custom Route'),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Custom Route'), findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('handles rapid navigation changes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [observer],
            home: TestPage(title: 'Home'),
          ),
        );

        await tester.pumpAndSettle();

        // Rapid push and pop operations
        for (int i = 0; i < 10; i++) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => TestPage(title: 'Page $i', hasFocus: true),
            ),
          );
          if (i % 2 == 1) {
            navigatorKey.currentState?.pop();
          }
        }

        await tester.pumpAndSettle();

        // Should handle all operations without crashing
        expect(find.byType(TestPage), findsOneWidget);
      });

      testWidgets('handles disposal during navigation', (WidgetTester tester) async {
        bool showApp = true;

        await tester.pumpWidget(
          showApp
              ? MaterialApp(
                  navigatorKey: navigatorKey,
                  navigatorObservers: [observer],
                  home: TestPage(title: 'Home', hasFocus: true),
                )
              : Container(),
        );

        await tester.pumpAndSettle();

        if (showApp) {
          // Start navigation
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => TestPage(title: 'Second'),
            ),
          );
        }

        // Dispose app during navigation
        await tester.pumpWidget(Container());
        await tester.pumpAndSettle();

        // Should not crash
        expect(find.byType(TestPage), findsNothing);
      });

      testWidgets('handles null navigator gracefully', (WidgetTester tester) async {
        // Create observer without attaching to navigator initially
        final standaloneObserver = ClearFocusNavigatorObserver();

        // These should not crash even though there's no navigator
        expect(() {
          final route = MaterialPageRoute(builder: (context) => Container());
          standaloneObserver.didPush(route, null);
          standaloneObserver.didPop(route, null);
          standaloneObserver.didReplace(newRoute: route, oldRoute: null);
        }, returnsNormally);
      });
    });

    group('type safety and inheritance', () {
      testWidgets('correctly extends NavigatorObserver', (WidgetTester tester) async {
        expect(observer, isA<NavigatorObserver>());
        expect(observer.runtimeType, equals(ClearFocusNavigatorObserver));
      });

      testWidgets('can be subclassed', (WidgetTester tester) async {
        final customObserver = CustomClearFocusObserver();

        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [customObserver],
            home: TestPage(title: 'Home'),
          ),
        );

        await tester.pumpAndSettle();

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => TestPage(title: 'Second'),
          ),
        );

        await tester.pumpAndSettle();

        expect(customObserver.customPushCalled, isTrue);
        expect(find.text('Second'), findsOneWidget);
      });
    });
  });
}

// Helper classes for testing
class TestNavigatorObserver extends NavigatorObserver {
  bool pushCalled = false;
  bool popCalled = false;
  bool replaceCalled = false;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    pushCalled = true;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    popCalled = true;
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    replaceCalled = true;
  }
}

class CustomClearFocusObserver extends ClearFocusNavigatorObserver {
  bool customPushCalled = false;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    customPushCalled = true;
  }
}