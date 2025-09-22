// Author: Claude Code
// Created Date: September 22, 2025

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/src/routes/fade_scale_page_route.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestPage extends StatelessWidget {
  const _TestPage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Page')),
      body: Center(
        child: Text(text),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              FadeScalePageRoute(
                child: _TestPage(text: 'Fade Scale Page'),
              ),
            );
          },
          child: Text('Navigate with Fade Scale'),
        ),
      ),
    );
  }
}

void main() {
  group('FadeScalePageRoute tests', () {
    group('constructor and properties', () {
      test('creates with required child parameter', () {
        const testWidget = Text('Test');
        final route = FadeScalePageRoute(child: testWidget);

        expect(route, isA<PageRouteBuilder<void>>());
        expect(route.transitionDuration,
            equals(const Duration(milliseconds: 300)));
      });

      test('creates with custom duration', () {
        const testWidget = Text('Test');
        final route = FadeScalePageRoute(
          child: testWidget,
          duration: 500,
        );

        expect(route.transitionDuration,
            equals(const Duration(milliseconds: 500)));
      });

      test('creates with zero duration', () {
        const testWidget = Text('Test');
        final route = FadeScalePageRoute(
          child: testWidget,
          duration: 0,
        );

        expect(route.transitionDuration, equals(Duration.zero));
      });

      test('inherits from PageRouteBuilder', () {
        const testWidget = Text('Test');
        final route = FadeScalePageRoute(child: testWidget);

        expect(route, isA<PageRouteBuilder<void>>());
        expect(route, isA<PageRoute<void>>());
        expect(route, isA<ModalRoute<void>>());
        expect(route, isA<TransitionRoute<void>>());
        expect(route, isA<OverlayRoute<void>>());
        expect(route, isA<Route<void>>());
      });

      test('has correct generic type', () {
        const testWidget = Text('Test');
        final route = FadeScalePageRoute<String>(child: testWidget);

        expect(route, isA<FadeScalePageRoute<String>>());
        expect(route, isA<PageRouteBuilder<String>>());
      });
    });

    group('page builder functionality', () {
      testWidgets('builds correct child widget', (WidgetTester tester) async {
        const testText = 'Test Page Content';
        const testWidget = Text(testText);
        final route = FadeScalePageRoute(child: testWidget);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // Test the pageBuilder function
                final child = route.pageBuilder(
                  context,
                  AlwaysStoppedAnimation(1.0),
                  AlwaysStoppedAnimation(0.0),
                );
                return child;
              },
            ),
          ),
        );

        expect(find.text(testText), findsOneWidget);
      });

      testWidgets('pageBuilder returns provided child',
          (WidgetTester tester) async {
        final testWidget = Container(
          key: const Key('test-container'),
          child: const Text('Test'),
        );
        final route = FadeScalePageRoute(child: testWidget);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final child = route.pageBuilder(
                  context,
                  AlwaysStoppedAnimation(1.0),
                  AlwaysStoppedAnimation(0.0),
                );
                return child;
              },
            ),
          ),
        );

        expect(find.byKey(const Key('test-container')), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('buildTransitions functionality', () {
      testWidgets('buildTransitions creates FadeScaleTransition',
          (WidgetTester tester) async {
        const testWidget = Text('Test Child');
        final route = FadeScalePageRoute(child: testWidget);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final transition = route.buildTransitions(
                  context,
                  AlwaysStoppedAnimation(0.5),
                  AlwaysStoppedAnimation(0.0),
                  testWidget,
                );
                return transition;
              },
            ),
          ),
        );

        // The transition should contain the child
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('buildTransitions works with different animation values',
          (WidgetTester tester) async {
        const testWidget = Text('Test Child');
        final route = FadeScalePageRoute(child: testWidget);

        // Test with animation at start
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final transition = route.buildTransitions(
                  context,
                  AlwaysStoppedAnimation(0.0),
                  AlwaysStoppedAnimation(0.0),
                  testWidget,
                );
                return transition;
              },
            ),
          ),
        );

        expect(find.text('Test Child'), findsOneWidget);

        // Test with animation at end
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final transition = route.buildTransitions(
                  context,
                  AlwaysStoppedAnimation(1.0),
                  AlwaysStoppedAnimation(0.0),
                  testWidget,
                );
                return transition;
              },
            ),
          ),
        );

        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('buildTransitions handles secondary animation',
          (WidgetTester tester) async {
        const testWidget = Text('Test Child');
        final route = FadeScalePageRoute(child: testWidget);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final transition = route.buildTransitions(
                  context,
                  AlwaysStoppedAnimation(1.0),
                  AlwaysStoppedAnimation(0.5), // Non-zero secondary animation
                  testWidget,
                );
                return transition;
              },
            ),
          ),
        );

        expect(find.text('Test Child'), findsOneWidget);
      });
    });

    group('integration with Navigator', () {
      testWidgets('works with Navigator.push', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _HomePage(),
          ),
        );

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Navigate with Fade Scale'), findsOneWidget);

        // Tap the button to navigate
        await tester.tap(find.text('Navigate with Fade Scale'));
        await tester.pumpAndSettle();

        // Should navigate to the new page
        expect(find.text('Test Page'), findsOneWidget);
        expect(find.text('Fade Scale Page'), findsOneWidget);
      });

      testWidgets('supports back navigation', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _HomePage(),
          ),
        );

        // Navigate to the test page
        await tester.tap(find.text('Navigate with Fade Scale'));
        await tester.pumpAndSettle();

        expect(find.text('Fade Scale Page'), findsOneWidget);

        // Navigate back
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Should be back on home page
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Navigate with Fade Scale'), findsOneWidget);
      });

      testWidgets('works with Navigator.pushReplacement',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        FadeScalePageRoute(
                          child: _TestPage(text: 'Replacement Page'),
                        ),
                      );
                    },
                    child: Text('Replace with Fade Scale'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Replace with Fade Scale'));
        await tester.pumpAndSettle();

        expect(find.text('Replacement Page'), findsOneWidget);
        // No back button should be present since we used pushReplacement
        expect(find.byType(BackButton), findsNothing);
      });
    });

    group('animation duration behavior', () {
      testWidgets('respects custom duration during transition',
          (WidgetTester tester) async {
        final route = FadeScalePageRoute(
          child: _TestPage(text: 'Custom Duration'),
          duration: 1000, // 1 second
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => Navigator.of(context).push(route),
                    child: Text('Navigate'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pump(); // Start the transition

        // After 500ms (half the duration), transition should still be in progress
        await tester.pump(const Duration(milliseconds: 500));

        // The new page should be visible but transition not complete
        expect(find.text('Custom Duration'), findsOneWidget);

        // Complete the transition
        await tester.pumpAndSettle();
        expect(find.text('Custom Duration'), findsOneWidget);
      });

      testWidgets('zero duration completes immediately',
          (WidgetTester tester) async {
        final route = FadeScalePageRoute(
          child: _TestPage(text: 'Instant'),
          duration: 0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => Navigator.of(context).push(route),
                    child: Text('Navigate'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pump(); // Should complete immediately

        expect(find.text('Instant'), findsOneWidget);
      });
    });

    group('complex widget integration', () {
      testWidgets('works with complex widget trees',
          (WidgetTester tester) async {
        final complexChild = Scaffold(
          appBar: AppBar(title: Text('Complex Page')),
          body: Column(
            children: [
              Container(
                height: 100,
                color: Colors.red,
                child: Center(child: Text('Header')),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => ListTile(
                    title: Text('Item $index'),
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add),
              ),
            ],
          ),
        );

        final route = FadeScalePageRoute(child: complexChild);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => Navigator.of(context).push(route),
                    child: Text('Navigate to Complex'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate to Complex'));
        await tester.pumpAndSettle();

        expect(find.text('Complex Page'), findsOneWidget);
        expect(find.text('Header'), findsOneWidget);
        expect(find.text('Item 0'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
      });

      testWidgets('works with stateful widgets', (WidgetTester tester) async {
        final statefulChild = _StatefulTestPage();
        final route = FadeScalePageRoute(child: statefulChild);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => Navigator.of(context).push(route),
                    child: Text('Navigate to Stateful'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate to Stateful'));
        await tester.pumpAndSettle();

        expect(find.text('Counter: 0'), findsOneWidget);

        // Interact with the stateful widget
        await tester.tap(find.text('Increment'));
        await tester.pump();

        expect(find.text('Counter: 1'), findsOneWidget);
      });
    });

    group('edge cases and error handling', () {
      testWidgets('handles widgets with keys', (WidgetTester tester) async {
        final keyedChild = Container(
          key: GlobalKey(),
          child: Text('Keyed Widget'),
        );

        final route = FadeScalePageRoute(child: keyedChild);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => Navigator.of(context).push(route),
                    child: Text('Navigate'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.text('Keyed Widget'), findsOneWidget);
      });

      testWidgets('works with nested routes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _HomePage(),
          ),
        );

        // First navigation
        await tester.tap(find.text('Navigate with Fade Scale'));
        await tester.pumpAndSettle();

        expect(find.text('Fade Scale Page'), findsOneWidget);

        // Add another nested navigation
        final nestedRoute = FadeScalePageRoute(
          child: _TestPage(text: 'Nested Page'),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: _HomePage(),
            routes: {
              '/nested': (context) => Builder(
                    builder: (context) {
                      Navigator.of(context).push(nestedRoute);
                      return Container();
                    },
                  ),
            },
          ),
        );

        // Navigate again from the current page
        final context = tester.element(find.text('Fade Scale Page'));
        Navigator.of(context).push(nestedRoute);
        await tester.pumpAndSettle();

        expect(find.text('Nested Page'), findsOneWidget);
      });

      testWidgets('route disposal works correctly',
          (WidgetTester tester) async {
        final route = FadeScalePageRoute(
          child: _TestPage(text: 'Disposal Test'),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => Navigator.of(context).push(route),
                    child: Text('Navigate'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.text('Disposal Test'), findsOneWidget);

        // Navigate back to dispose the route
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Route should be disposed
        expect(find.text('Disposal Test'), findsNothing);
      });
    });

    group('performance and behavior', () {
      testWidgets('maintains widget state during transition',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        FadeScalePageRoute(child: _StatefulTestPage()),
                      );
                    },
                    child: Text('Navigate'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));

        // During transition, pump a few frames
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Widget should be building correctly during transition
        expect(find.text('Counter: 0'), findsOneWidget);

        await tester.pumpAndSettle();

        // Increment counter
        await tester.tap(find.text('Increment'));
        await tester.pump();

        expect(find.text('Counter: 1'), findsOneWidget);
      });

      testWidgets('does not interfere with other routes',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            FadeScalePageRoute(
                                child: _TestPage(text: 'Fade Scale')),
                          );
                        },
                        child: Text('Fade Scale Route'),
                      );
                    },
                  ),
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    _TestPage(text: 'Material Route')),
                          );
                        },
                        child: Text('Material Route'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        // Test both routes work independently
        await tester.tap(find.text('Fade Scale Route'));
        await tester.pumpAndSettle();
        expect(find.text('Fade Scale'), findsOneWidget);

        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Material Route'));
        await tester.pumpAndSettle();
        expect(find.text('Material Route'), findsOneWidget);
      });
    });
  });
}

// Helper widget for stateful testing
class _StatefulTestPage extends StatefulWidget {
  @override
  State<_StatefulTestPage> createState() => _StatefulTestPageState();
}

class _StatefulTestPageState extends State<_StatefulTestPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stateful Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: $counter'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  counter++;
                });
              },
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
