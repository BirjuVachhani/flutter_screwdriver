// Author: Claude Code
// Created Date: September 22, 2025

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/src/routes/shared_axis_page_route.dart';
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
  group('SharedAxisPageRoute tests', () {
    group('constructor and properties', () {
      test('creates with required parameters', () {
        const testWidget = Text('Test');
        final route = SharedAxisPageRoute(
          child: testWidget,
          type: SharedAxisTransitionType.horizontal,
        );

        expect(route, isA<PageRouteBuilder<void>>());
        expect(route.transitionDuration,
            equals(const Duration(milliseconds: 300)));
        expect(route.type, equals(SharedAxisTransitionType.horizontal));
      });

      test('creates with custom duration', () {
        const testWidget = Text('Test');
        final route = SharedAxisPageRoute(
          child: testWidget,
          type: SharedAxisTransitionType.vertical,
          duration: 500,
        );

        expect(route.transitionDuration,
            equals(const Duration(milliseconds: 500)));
        expect(route.type, equals(SharedAxisTransitionType.vertical));
      });

      test('has correct generic type', () {
        const testWidget = Text('Test');
        final route = SharedAxisPageRoute<String>(
          child: testWidget,
          type: SharedAxisTransitionType.scaled,
        );

        expect(route, isA<SharedAxisPageRoute<String>>());
        expect(route, isA<PageRouteBuilder<String>>());
        expect(route.type, equals(SharedAxisTransitionType.scaled));
      });
    });

    group('named constructors', () {
      test('vertical constructor creates correct route', () {
        const testWidget = Text('Test');
        final route = SharedAxisPageRoute.vertical(child: testWidget);

        expect(route.type, equals(SharedAxisTransitionType.vertical));
        expect(route.transitionDuration,
            equals(const Duration(milliseconds: 300)));
      });

      test('vertical constructor with custom duration', () {
        const testWidget = Text('Test');
        final route = SharedAxisPageRoute.vertical(
          child: testWidget,
          duration: 600,
        );

        expect(route.type, equals(SharedAxisTransitionType.vertical));
        expect(route.transitionDuration,
            equals(const Duration(milliseconds: 600)));
      });

      test('horizontal constructor creates correct route', () {
        const testWidget = Text('Test');
        final route = SharedAxisPageRoute.horizontal(child: testWidget);

        expect(route.type, equals(SharedAxisTransitionType.horizontal));
        expect(route.transitionDuration,
            equals(const Duration(milliseconds: 300)));
      });

      test('horizontal constructor with custom duration', () {
        const testWidget = Text('Test');
        final route = SharedAxisPageRoute.horizontal(
          child: testWidget,
          duration: 400,
        );

        expect(route.type, equals(SharedAxisTransitionType.horizontal));
        expect(route.transitionDuration,
            equals(const Duration(milliseconds: 400)));
      });

      test('scaled constructor creates correct route', () {
        const testWidget = Text('Test');
        final route = SharedAxisPageRoute.scaled(child: testWidget);

        expect(route.type, equals(SharedAxisTransitionType.scaled));
        expect(route.transitionDuration,
            equals(const Duration(milliseconds: 300)));
      });

      test('scaled constructor with custom duration', () {
        const testWidget = Text('Test');
        final route = SharedAxisPageRoute.scaled(
          child: testWidget,
          duration: 800,
        );

        expect(route.type, equals(SharedAxisTransitionType.scaled));
        expect(route.transitionDuration,
            equals(const Duration(milliseconds: 800)));
      });
    });

    group('buildTransitions functionality', () {
      testWidgets('buildTransitions creates SharedAxisTransition',
          (WidgetTester tester) async {
        const testWidget = Text('Test Child');
        final route = SharedAxisPageRoute(
          child: testWidget,
          type: SharedAxisTransitionType.horizontal,
        );

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

      testWidgets('buildTransitions passes correct transition type',
          (WidgetTester tester) async {
        const testWidget = Text('Test Child');

        for (final type in SharedAxisTransitionType.values) {
          final route = SharedAxisPageRoute(
            child: testWidget,
            type: type,
          );

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
        }
      });

      testWidgets('buildTransitions handles secondary animation',
          (WidgetTester tester) async {
        const testWidget = Text('Test Child');
        final route = SharedAxisPageRoute(
          child: testWidget,
          type: SharedAxisTransitionType.vertical,
        );

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
      testWidgets('vertical route works with Navigator.push',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        SharedAxisPageRoute.vertical(
                          child: _TestPage(text: 'Vertical Page'),
                        ),
                      );
                    },
                    child: Text('Navigate Vertical'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate Vertical'));
        await tester.pumpAndSettle();

        expect(find.text('Vertical Page'), findsOneWidget);
      });

      testWidgets('horizontal route works with Navigator.push',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        SharedAxisPageRoute.horizontal(
                          child: _TestPage(text: 'Horizontal Page'),
                        ),
                      );
                    },
                    child: Text('Navigate Horizontal'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate Horizontal'));
        await tester.pumpAndSettle();

        expect(find.text('Horizontal Page'), findsOneWidget);
      });

      testWidgets('scaled route works with Navigator.push',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        SharedAxisPageRoute.scaled(
                          child: _TestPage(text: 'Scaled Page'),
                        ),
                      );
                    },
                    child: Text('Navigate Scaled'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate Scaled'));
        await tester.pumpAndSettle();

        expect(find.text('Scaled Page'), findsOneWidget);
      });

      testWidgets('supports back navigation', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        SharedAxisPageRoute.horizontal(
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

        expect(find.text('Navigate'), findsOneWidget);
      });
    });

    group('animation duration behavior', () {
      testWidgets('respects custom duration for vertical transition',
          (WidgetTester tester) async {
        final route = SharedAxisPageRoute.vertical(
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
        final route = SharedAxisPageRoute.horizontal(
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
    });

    group('transition type variations', () {
      testWidgets('all transition types work independently',
          (WidgetTester tester) async {
        final types = [
          (SharedAxisTransitionType.vertical, 'Vertical'),
          (SharedAxisTransitionType.horizontal, 'Horizontal'),
          (SharedAxisTransitionType.scaled, 'Scaled'),
        ];

        for (final (type, name) in types) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          SharedAxisPageRoute(
                            child: _TestPage(text: '$name Page'),
                            type: type,
                          ),
                        );
                      },
                      child: Text('Navigate $name'),
                    );
                  },
                ),
              ),
            ),
          );

          await tester.tap(find.text('Navigate $name'));
          await tester.pumpAndSettle();

          expect(find.text('$name Page'), findsOneWidget);

          // Navigate back for next test
          await tester.tap(find.byType(BackButton));
          await tester.pumpAndSettle();
        }
      });

      testWidgets('different constructors create equivalent routes',
          (WidgetTester tester) async {
        const testWidget = Text('Test');

        final primaryVertical = SharedAxisPageRoute(
          child: testWidget,
          type: SharedAxisTransitionType.vertical,
          duration: 400,
        );

        final namedVertical = SharedAxisPageRoute.vertical(
          child: testWidget,
          duration: 400,
        );

        expect(primaryVertical.type, equals(namedVertical.type));
        expect(primaryVertical.transitionDuration,
            equals(namedVertical.transitionDuration));

        final primaryHorizontal = SharedAxisPageRoute(
          child: testWidget,
          type: SharedAxisTransitionType.horizontal,
          duration: 500,
        );

        final namedHorizontal = SharedAxisPageRoute.horizontal(
          child: testWidget,
          duration: 500,
        );

        expect(primaryHorizontal.type, equals(namedHorizontal.type));
        expect(primaryHorizontal.transitionDuration,
            equals(namedHorizontal.transitionDuration));

        final primaryScaled = SharedAxisPageRoute(
          child: testWidget,
          type: SharedAxisTransitionType.scaled,
          duration: 600,
        );

        final namedScaled = SharedAxisPageRoute.scaled(
          child: testWidget,
          duration: 600,
        );

        expect(primaryScaled.type, equals(namedScaled.type));
        expect(primaryScaled.transitionDuration,
            equals(namedScaled.transitionDuration));
      });
    });

    group('edge cases and complex scenarios', () {
      testWidgets('works with complex widget trees',
          (WidgetTester tester) async {
        final complexChild = DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(title: Text('Complex Page')),
            body: TabBarView(
              children: [
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => ListTile(
                    title: Text('Item $index'),
                  ),
                ),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) => Card(
                    child: Center(child: Text('Card $index')),
                  ),
                ),
              ],
            ),
          ),
        );

        final route = SharedAxisPageRoute.vertical(child: complexChild);

        await tester.pumpWidget(
          MaterialApp(
            home: DefaultTabController(
              length: 2,
              child: Scaffold(
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
          ),
        );

        await tester.tap(find.text('Navigate to Complex'));
        await tester.pumpAndSettle();

        expect(find.text('Complex Page'), findsOneWidget);
        expect(find.text('Item 0'), findsOneWidget);
      });

      testWidgets('handles rapid navigation between different transition types',
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
                            SharedAxisPageRoute.vertical(
                              child: _TestPage(text: 'Vertical'),
                            ),
                          );
                        },
                        child: Text('Vertical'),
                      );
                    },
                  ),
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            SharedAxisPageRoute.horizontal(
                              child: _TestPage(text: 'Horizontal'),
                            ),
                          );
                        },
                        child: Text('Horizontal'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        // Navigate to vertical
        await tester.tap(find.text('Vertical'));
        await tester.pumpAndSettle();
        expect(find.text('Vertical'), findsOneWidget);

        // Navigate to horizontal from vertical page
        final context = tester.element(find.text('Vertical'));
        Navigator.of(context).push(
          SharedAxisPageRoute.horizontal(
            child: _TestPage(text: 'Horizontal from Vertical'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Horizontal from Vertical'), findsOneWidget);
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
                        SharedAxisPageRoute.scaled(
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
    });
  });
}

// Helper widget for nested navigation testing
class _NestedNavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nested Navigation')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              SharedAxisPageRoute.horizontal(
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
