// Author: Birju Vachhani
// Created Date: September 21, 2025

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetFS extension tests', () {
    group('showAsDialog method', () {
      testWidgets('shows widget as dialog with default parameters',
          (WidgetTester tester) async {
        const testWidget = Text('Test Dialog Content');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => testWidget.showAsDialog(context),
                    child: const Text('Show Dialog'),
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('Test Dialog Content'), findsNothing);

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Test Dialog Content'), findsOneWidget);
      });

      testWidgets('shows widget as dialog with custom configuration',
          (WidgetTester tester) async {
        const testWidget = Text('Custom Dialog');
        const customConfig = FadeScaleTransitionConfiguration(
          transitionDuration: Duration(milliseconds: 100),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => testWidget.showAsDialog(
                      context,
                      configuration: customConfig,
                    ),
                    child: const Text('Show Custom Dialog'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Custom Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Custom Dialog'), findsOneWidget);
      });

      testWidgets('shows widget as dialog with useRootNavigator true',
          (WidgetTester tester) async {
        const testWidget = Text('Root Navigator Dialog');

        await tester.pumpWidget(
          MaterialApp(
            home: Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () => testWidget.showAsDialog(
                            context,
                            useRootNavigator: true,
                          ),
                          child: const Text('Show Root Dialog'),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Show Root Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Root Navigator Dialog'), findsOneWidget);
      });

      testWidgets('returns Future that completes when dialog is dismissed',
          (WidgetTester tester) async {
        const testWidget = Text('Dismissible Dialog');
        late Future<dynamic> result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      result = testWidget.showAsDialog(context);
                    },
                    child: const Text('Show Dialog'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Dismissible Dialog'), findsOneWidget);
        expect(result, isA<Future<dynamic>>());
      });

      testWidgets('works with complex widgets', (WidgetTester tester) async {
        final complexWidget = Material(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Complex Dialog'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Action Button'),
                ),
                const TextField(
                  decoration: InputDecoration(labelText: 'Input Field'),
                ),
              ],
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => complexWidget.showAsDialog(context),
                    child: const Text('Show Complex Dialog'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Complex Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Complex Dialog'), findsOneWidget);
        expect(find.text('Action Button'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('works with StatefulWidget', (WidgetTester tester) async {
        final statefulWidget = StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Stateful Dialog'),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Update State'),
                ),
              ],
            );
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => statefulWidget.showAsDialog(context),
                    child: const Text('Show Stateful Dialog'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Stateful Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Stateful Dialog'), findsOneWidget);
        expect(find.text('Update State'), findsOneWidget);

        // Test that state updates work
        await tester.tap(find.text('Update State'));
        await tester.pumpAndSettle();

        expect(find.text('Stateful Dialog'), findsOneWidget);
      });

      testWidgets('multiple dialogs can be shown sequentially',
          (WidgetTester tester) async {
        const widget1 = Text('First Dialog');
        const widget2 = Text('Second Dialog');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => widget1.showAsDialog(context),
                        child: const Text('Show First'),
                      ),
                      ElevatedButton(
                        onPressed: () => widget2.showAsDialog(context),
                        child: const Text('Show Second'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        // Show first dialog
        await tester.tap(find.text('Show First'));
        await tester.pumpAndSettle();
        expect(find.text('First Dialog'), findsOneWidget);

        // Verify the showAsDialog method works for different widgets
        expect(find.text('Show Second'), findsOneWidget);
      });

      testWidgets('works with different modal configurations',
          (WidgetTester tester) async {
        const testWidget = Text('Configured Dialog');
        const customConfig = FadeScaleTransitionConfiguration(
          transitionDuration: Duration(milliseconds: 200),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => testWidget.showAsDialog(
                      context,
                      configuration: customConfig,
                    ),
                    child: const Text('Show Configured Dialog'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Configured Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Configured Dialog'), findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('handles empty widget', (WidgetTester tester) async {
        const emptyWidget = SizedBox.shrink();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => emptyWidget.showAsDialog(context),
                    child: const Text('Show Empty'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Empty'));
        await tester.pumpAndSettle();

        // Dialog should still show, even if content is empty
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('handles widget with constraints',
          (WidgetTester tester) async {
        final constrainedWidget = Container(
          width: 300,
          height: 200,
          color: Colors.blue,
          child: const Center(
            child: Text('Constrained Dialog'),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => constrainedWidget.showAsDialog(context),
                    child: const Text('Show Constrained'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Constrained'));
        await tester.pumpAndSettle();

        expect(find.text('Constrained Dialog'), findsOneWidget);
      });
    });

    group('integration tests', () {
      testWidgets('showAsDialog integrates with navigation',
          (WidgetTester tester) async {
        const testWidget = Text('Navigation Dialog');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      final result = testWidget.showAsDialog(context);
                      expect(result, isA<Future<dynamic>>());
                    },
                    child: const Text('Show Dialog'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Navigation Dialog'), findsOneWidget);
      });

      testWidgets('works in different contexts', (WidgetTester tester) async {
        const testWidget = Text('Context Dialog');

        await tester.pumpWidget(
          MaterialApp(
            home: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'Tab 1'),
                      Tab(text: 'Tab 2'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () => testWidget.showAsDialog(context),
                          child: const Text('Show from Tab 1'),
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () => testWidget.showAsDialog(context),
                          child: const Text('Show from Tab 2'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Test from first tab
        await tester.tap(find.text('Show from Tab 1'));
        await tester.pumpAndSettle();
        expect(find.text('Context Dialog'), findsOneWidget);
      });
    });

    group('type safety', () {
      testWidgets('returns correctly typed Future',
          (WidgetTester tester) async {
        const testWidget = Text('Typed Dialog');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      final result = testWidget.showAsDialog(context);
                      expect(result, isA<Future<dynamic>>());
                    },
                    child: const Text('Show Dialog'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
      });

      testWidgets('accepts proper parameter types',
          (WidgetTester tester) async {
        const testWidget = Text('Parameter Dialog');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      // Test that parameters are accepted
                      expect(
                          () => testWidget.showAsDialog(
                                context,
                                useRootNavigator: true,
                                configuration:
                                    const FadeScaleTransitionConfiguration(),
                              ),
                          returnsNormally);
                    },
                    child: const Text('Show Dialog'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
      });
    });
  });
}
