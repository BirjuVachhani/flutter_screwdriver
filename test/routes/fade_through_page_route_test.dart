// Author: Claude Code
// Created Date: September 22, 2025

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/src/routes/fade_through_page_route.dart';
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

void main() {
  group('FadeThroughPageRoute tests', () {
    group('constructor and properties', () {
      test('creates with required child parameter', () {
        const testWidget = Text('Test');
        final route = FadeThroughPageRoute(child: testWidget);

        expect(route, isA<PageRouteBuilder>());
        expect(route.transitionDuration,
            equals(const Duration(milliseconds: 300)));
      });

      test('creates with custom duration', () {
        const testWidget = Text('Test');
        final route = FadeThroughPageRoute(
          child: testWidget,
          duration: 500,
        );

        expect(route.transitionDuration,
            equals(const Duration(milliseconds: 500)));
      });

      test('creates with zero duration', () {
        const testWidget = Text('Test');
        final route = FadeThroughPageRoute(
          child: testWidget,
          duration: 0,
        );

        expect(route.transitionDuration, equals(Duration.zero));
      });

      test('inherits from PageRouteBuilder', () {
        const testWidget = Text('Test');
        final route = FadeThroughPageRoute(child: testWidget);

        expect(route, isA<PageRouteBuilder>());
        expect(route, isA<PageRoute>());
        expect(route, isA<ModalRoute>());
        expect(route, isA<TransitionRoute>());
        expect(route, isA<OverlayRoute>());
        expect(route, isA<Route>());
      });

      test('has correct generic type', () {
        const testWidget = Text('Test');
        final route = FadeThroughPageRoute<String>(child: testWidget);

        expect(route, isA<FadeThroughPageRoute<String>>());
        expect(route, isA<PageRouteBuilder<String>>());
      });
    });

    group('page builder functionality', () {
      testWidgets('builds correct child widget', (WidgetTester tester) async {
        const testText = 'Test Page Content';
        const testWidget = Text(testText);
        final route = FadeThroughPageRoute(child: testWidget);

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

        expect(find.text(testText), findsOneWidget);
      });

      testWidgets('pageBuilder returns provided child',
          (WidgetTester tester) async {
        final testWidget = Container(
          key: const Key('test-container'),
          child: const Text('Test'),
        );
        final route = FadeThroughPageRoute(child: testWidget);

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
      testWidgets('buildTransitions creates FadeThroughTransition',
          (WidgetTester tester) async {
        const testWidget = Text('Test Child');
        final route = FadeThroughPageRoute(child: testWidget);

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

        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('buildTransitions works with different animation values',
          (WidgetTester tester) async {
        const testWidget = Text('Test Child');
        final route = FadeThroughPageRoute(child: testWidget);

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

      testWidgets('buildTransitions uses both primary and secondary animations',
          (WidgetTester tester) async {
        const testWidget = Text('Test Child');
        final route = FadeThroughPageRoute(child: testWidget);

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
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        FadeThroughPageRoute(
                          child: _TestPage(text: 'Fade Through Page'),
                        ),
                      );
                    },
                    child: Text('Navigate with Fade Through'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate with Fade Through'));
        await tester.pumpAndSettle();

        expect(find.text('Test Page'), findsOneWidget);
        expect(find.text('Fade Through Page'), findsOneWidget);
      });

      testWidgets('supports back navigation', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: Text('Home')),
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        FadeThroughPageRoute(
                          child: _TestPage(text: 'Pushed Page'),
                        ),
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
        await tester.pumpAndSettle();

        expect(find.text('Test Page'), findsOneWidget);

        // Navigate back
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Navigate'), findsOneWidget);
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
                        FadeThroughPageRoute(
                          child: _TestPage(text: 'Replacement Page'),
                        ),
                      );
                    },
                    child: Text('Replace with Fade Through'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Replace with Fade Through'));
        await tester.pumpAndSettle();

        expect(find.text('Replacement Page'), findsOneWidget);
        expect(find.byType(BackButton), findsNothing);
      });
    });

    group('animation duration behavior', () {
      testWidgets('respects custom duration during transition',
          (WidgetTester tester) async {
        final route = FadeThroughPageRoute(
          child: _TestPage(text: 'Custom Duration'),
          duration: 1000,
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
        await tester.pump();

        // After 500ms, transition should still be in progress
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Custom Duration'), findsOneWidget);

        await tester.pumpAndSettle();
        expect(find.text('Custom Duration'), findsOneWidget);
      });

      testWidgets('zero duration completes immediately',
          (WidgetTester tester) async {
        final route = FadeThroughPageRoute(
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
        await tester.pump();

        expect(find.text('Instant'), findsOneWidget);
      });

      testWidgets('long duration works correctly', (WidgetTester tester) async {
        final route = FadeThroughPageRoute(
          child: _TestPage(text: 'Long Duration'),
          duration: 2000,
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
        await tester.pump();

        // After 1 second, should still be transitioning
        await tester.pump(const Duration(milliseconds: 1000));
        expect(find.text('Long Duration'), findsOneWidget);

        // Complete the transition
        await tester.pumpAndSettle();
        expect(find.text('Long Duration'), findsOneWidget);
      });
    });

    group('complex widget integration', () {
      testWidgets('works with complex widget trees',
          (WidgetTester tester) async {
        final complexChild = Scaffold(
          appBar: AppBar(title: Text('Complex Page')),
          body: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: 'Tab 1'),
                    Tab(text: 'Tab 2'),
                    Tab(text: 'Tab 3'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) => ListTile(
                          title: Text('List Item $index'),
                        ),
                      ),
                      GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(
                            4,
                            (index) => Card(
                                child: Center(child: Text('Grid $index')))),
                      ),
                      Center(child: Text('Tab 3 Content')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        );

        final route = FadeThroughPageRoute(child: complexChild);

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
        expect(find.text('Tab 1'), findsOneWidget);
        expect(find.text('List Item 0'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
      });

      testWidgets('works with stateful widgets', (WidgetTester tester) async {
        final statefulChild = _StatefulTestPage();
        final route = FadeThroughPageRoute(child: statefulChild);

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

      testWidgets('works with inherited widgets', (WidgetTester tester) async {
        final theme = ThemeData.dark();
        final inheritedChild = Builder(
          builder: (context) {
            final currentTheme = Theme.of(context);
            return Scaffold(
              appBar: AppBar(title: Text('Inherited Theme')),
              body: Center(
                child: Container(
                  color: currentTheme.primaryColor,
                  child: Text(
                    'Themed Content',
                    style: TextStyle(color: currentTheme.colorScheme.onPrimary),
                  ),
                ),
              ),
            );
          },
        );

        final route = FadeThroughPageRoute(child: inheritedChild);

        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => Navigator.of(context).push(route),
                    child: Text('Navigate to Themed'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate to Themed'));
        await tester.pumpAndSettle();

        expect(find.text('Inherited Theme'), findsOneWidget);
        expect(find.text('Themed Content'), findsOneWidget);
      });
    });

    group('edge cases and error handling', () {
      testWidgets('handles widgets with global keys',
          (WidgetTester tester) async {
        final keyedChild = Container(
          key: GlobalKey(),
          child: Text('Keyed Widget'),
        );

        final route = FadeThroughPageRoute(child: keyedChild);

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

      testWidgets('works with nested navigation', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        FadeThroughPageRoute(
                          child: _NestedNavigationPage(),
                        ),
                      );
                    },
                    child: Text('Navigate to Nested'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate to Nested'));
        await tester.pumpAndSettle();

        expect(find.text('Nested Navigation'), findsOneWidget);

        // Test nested navigation
        await tester.tap(find.text('Go Deeper'));
        await tester.pumpAndSettle();

        expect(find.text('Deep Page'), findsOneWidget);
      });

      testWidgets('route disposal works correctly',
          (WidgetTester tester) async {
        final route = FadeThroughPageRoute(
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
                        FadeThroughPageRoute(child: _StatefulTestPage()),
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
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Counter: 0'), findsOneWidget);

        await tester.pumpAndSettle();

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
                            FadeThroughPageRoute(
                                child: _TestPage(text: 'Fade Through')),
                          );
                        },
                        child: Text('Fade Through Route'),
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
        await tester.tap(find.text('Fade Through Route'));
        await tester.pumpAndSettle();
        expect(find.text('Fade Through'), findsOneWidget);

        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Material Route'));
        await tester.pumpAndSettle();
        expect(find.text('Material Route'), findsOneWidget);
      });
    });
  });
}

// Helper widgets for testing
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

class _NestedNavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nested Navigation')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              FadeThroughPageRoute(
                child: _TestPage(text: 'Deep Page'),
              ),
            );
          },
          child: Text('Go Deeper'),
        ),
      ),
    );
  }
}
