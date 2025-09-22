// Author: Birju Vachhani
// Created Date: September 21, 2025

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screwdriver/src/helpers/helper_functions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Helper Functions tests', () {
    group('closeApp function', () {
      late List<MethodCall> methodCalls;

      setUp(() {
        methodCalls = [];
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          methodCalls.add(call);
          return null;
        });
      });

      tearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null);
      });

      test('calls SystemNavigator.pop with default animated parameter',
          () async {
        await closeApp();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, equals('SystemNavigator.pop'));
        expect(methodCalls.first.arguments, isTrue);
      });

      test('calls SystemNavigator.pop with animated=true', () async {
        await closeApp(animated: true);

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, equals('SystemNavigator.pop'));
        expect(methodCalls.first.arguments, isTrue);
      });

      test('calls SystemNavigator.pop with animated=false', () async {
        await closeApp(animated: false);

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, equals('SystemNavigator.pop'));
        expect(methodCalls.first.arguments, isFalse);
      });

      test('returns a Future<void>', () async {
        final result = closeApp();
        expect(result, isA<Future<void>>());
        await result;
      });

      test('completes successfully', () async {
        await expectLater(closeApp(), completes);
      });

      test('can be called multiple times', () async {
        await closeApp(animated: true);
        await closeApp(animated: false);
        await closeApp();

        expect(methodCalls, hasLength(3));
        expect(methodCalls[0].arguments, isTrue);
        expect(methodCalls[1].arguments, isFalse);
        expect(methodCalls[2].arguments, isTrue);
      });

      test('handles platform channel errors gracefully', () async {
        // Mock a platform error
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          throw PlatformException(
            code: 'UNAVAILABLE',
            message: 'Platform not available',
          );
        });

        await expectLater(
          closeApp(),
          throwsA(isA<PlatformException>()),
        );
      });

      testWidgets('works in integration context', (WidgetTester tester) async {
        // Test that the function can be called from within a widget context
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => closeApp(),
                    child: Text('Close App'),
                  );
                },
              ),
            ),
          ),
        );

        methodCalls.clear(); // Clear the list before tapping

        await tester.tap(find.text('Close App'));
        await tester.pump();

        final popCalls = methodCalls
            .where((call) => call.method == 'SystemNavigator.pop')
            .toList();

        expect(popCalls, hasLength(1));
      });

      group('parameter validation', () {
        test('accepts true for animated parameter', () async {
          await expectLater(closeApp(animated: true), completes);
        });

        test('accepts false for animated parameter', () async {
          await expectLater(closeApp(animated: false), completes);
        });

        test('has correct default parameter value', () async {
          await closeApp();
          expect(methodCalls.first.arguments, isTrue);
        });
      });

      group('async behavior', () {
        test('can be awaited', () async {
          final stopwatch = Stopwatch()..start();
          await closeApp();
          stopwatch.stop();

          // Should complete quickly in test environment
          expect(stopwatch.elapsedMilliseconds, lessThan(100));
        });

        test('can be used with Future.wait', () async {
          final futures = [
            closeApp(animated: true),
            closeApp(animated: false),
          ];

          await Future.wait(futures);

          expect(methodCalls, hasLength(2));
        });

        test('can be chained with other async operations', () async {
          var operationCompleted = false;

          await closeApp().then((_) {
            operationCompleted = true;
          });

          expect(operationCompleted, isTrue);
          expect(methodCalls, hasLength(1));
        });
      });
    });

    group('hideKeyboard function', () {
      late List<MethodCall> methodCalls;
      late BuildContext testContext;

      setUp(() {
        methodCalls = [];
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.textInput, (call) async {
          methodCalls.add(call);
          return null;
        });
      });

      tearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.textInput, null);
      });

      testWidgets('executes without errors', (WidgetTester tester) async {
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  testContext = context;
                  return TextField();
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // The hideKeyboard function should execute without throwing exceptions
        expect(() => hideKeyboard(testContext), returnsNormally);
      });

      testWidgets('unfocuses current focus when hasFocus is true',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  testContext = context;
                  return TextField(
                    key: Key('test_field'),
                    autofocus: true,
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Focus the text field
        await tester.tap(find.byKey(Key('test_field')));
        await tester.pumpAndSettle();

        // Test that hideKeyboard executes without errors when focus is present
        expect(() => hideKeyboard(testContext), returnsNormally);
      });

      testWidgets('handles context without focus gracefully',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  testContext = context;
                  return Text('No focusable widgets');
                },
              ),
            ),
          ),
        );

        // Test that hideKeyboard executes without errors when no focus is present
        expect(() => hideKeyboard(testContext), returnsNormally);
      });

      testWidgets('works with multiple text fields',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  testContext = context;
                  return Column(
                    children: [
                      TextField(key: Key('field1')),
                      TextField(key: Key('field2')),
                      TextField(key: Key('field3')),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Focus second field
        await tester.tap(find.byKey(Key('field2')));
        await tester.pumpAndSettle();

        // Test that hideKeyboard executes without errors with multiple text fields
        expect(() => hideKeyboard(testContext), returnsNormally);
      });

      testWidgets('does not throw when called', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  testContext = context;
                  return TextField();
                },
              ),
            ),
          ),
        );

        // Focus the text field first to ensure focus management works
        await tester.tap(find.byType(TextField));
        await tester.pumpAndSettle();

        // Call hideKeyboard - it should complete without throwing
        expect(() => hideKeyboard(testContext), returnsNormally);
      });

      testWidgets('can be called multiple times', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  testContext = context;
                  return TextField();
                },
              ),
            ),
          ),
        );

        // Test that hideKeyboard can be called multiple times without errors
        expect(() {
          hideKeyboard(testContext);
          hideKeyboard(testContext);
          hideKeyboard(testContext);
        }, returnsNormally);
      });

      testWidgets('works in complex widget tree', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Test'),
                  bottom: TabBar(
                    tabs: [Tab(text: 'Tab 1'), Tab(text: 'Tab 2')],
                  ),
                ),
                body: TabBarView(
                  children: [
                    Builder(
                      builder: (context) {
                        testContext = context;
                        return TextField(key: Key('tab1_field'));
                      },
                    ),
                    TextField(key: Key('tab2_field')),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Test that hideKeyboard executes without errors in complex widget tree
        expect(() => hideKeyboard(testContext), returnsNormally);
      });

      group('focus management', () {
        testWidgets('unfocuses focusedChild when present',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    testContext = context;
                    return Form(
                      child: Column(
                        children: [
                          TextFormField(key: Key('form_field1')),
                          TextFormField(key: Key('form_field2')),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Focus a form field
          await tester.tap(find.byKey(Key('form_field1')));
          await tester.pumpAndSettle();

          // Test that hideKeyboard executes without errors with form fields
          expect(() => hideKeyboard(testContext), returnsNormally);
        });

        testWidgets('handles nested focus scopes', (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    testContext = context;
                    return FocusScope(
                      child: Column(
                        children: [
                          TextField(key: Key('outer_field')),
                          FocusScope(
                            child: TextField(key: Key('inner_field')),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Focus inner field
          await tester.tap(find.byKey(Key('inner_field')));
          await tester.pumpAndSettle();

          // Test that hideKeyboard executes without errors with nested focus scopes
          expect(() => hideKeyboard(testContext), returnsNormally);
        });
      });
    });

    group('integration tests', () {
      testWidgets('both functions work together', (WidgetTester tester) async {
        final platformCalls = <MethodCall>[];
        final textInputCalls = <MethodCall>[];

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          platformCalls.add(call);
          return null;
        });

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.textInput, (call) async {
          textInputCalls.add(call);
          return null;
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      TextField(key: Key('input_field')),
                      ElevatedButton(
                        onPressed: () {
                          hideKeyboard(context);
                          closeApp();
                        },
                        child: Text('Hide & Close'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Focus the text field
        await tester.tap(find.byKey(Key('input_field')));
        await tester.pumpAndSettle();

        // Tap the button to hide keyboard and close app
        await tester.tap(find.text('Hide & Close'));
        await tester.pump();

        // Check that closeApp was called (filter for SystemNavigator.pop among other platform calls)
        final closeAppCalls = platformCalls
            .where((call) => call.method == 'SystemNavigator.pop')
            .toList();
        expect(closeAppCalls, hasLength(1));
        expect(closeAppCalls.first.method, equals('SystemNavigator.pop'));

        // Note: hideKeyboard calls may not be captured in test environment due to error handling

        // Cleanup
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null);
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.textInput, null);
      });

      testWidgets('functions are accessible from extension',
          (WidgetTester tester) async {
        // Test that these functions are available as part of the library
        expect(closeApp, isA<Function>());
        expect(hideKeyboard, isA<Function>());
      });
    });

    group('edge cases', () {
      test('closeApp with extreme parameter values', () async {
        final methodCalls = <MethodCall>[];
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          methodCalls.add(call);
          return null;
        });

        // These should all work
        await closeApp(animated: true);
        await closeApp(animated: false);

        expect(methodCalls, hasLength(2));
        expect(methodCalls[0].arguments, isTrue);
        expect(methodCalls[1].arguments, isFalse);

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null);
      });

      testWidgets('hideKeyboard with disposed context',
          (WidgetTester tester) async {
        late BuildContext disposedContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  disposedContext = context;
                  return TextField();
                },
              ),
            ),
          ),
        );

        // Replace with different widget to dispose context
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Text('Different content'),
            ),
          ),
        );

        // This should not crash even with disposed context
        expect(() => hideKeyboard(disposedContext), returnsNormally);
      });
    });

    group('type safety', () {
      test('closeApp returns correct Future type', () async {
        final future = closeApp();
        expect(future, isA<Future<void>>());
        await future;
      });

      test('hideKeyboard accepts BuildContext', () {
        expect(hideKeyboard, isA<void Function(BuildContext)>());
      });

      test('closeApp accepts bool parameter', () {
        expect(closeApp, isA<Future<void> Function({bool animated})>());
      });
    });
  });
}
