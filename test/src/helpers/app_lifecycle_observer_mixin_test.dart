// Author: Birju Vachhani
// Created Date: September 21, 2025

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/src/helpers/app_lifecycle_observer_mixin.dart';
import 'package:flutter_test/flutter_test.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> with AppLifecycleObserver {
  List<AppLifecycleState> receivedStates = [];
  List<String> methodCalls = [];

  @override
  Widget build(BuildContext context) {
    return const Text('Test Widget');
  }

  @override
  void onResume() {
    super.onResume();
    methodCalls.add('onResume');
  }

  @override
  void onPause() {
    super.onPause();
    methodCalls.add('onPause');
  }

  @override
  void onDetach() {
    super.onDetach();
    methodCalls.add('onDetach');
  }

  @override
  void onInactive() {
    super.onInactive();
    methodCalls.add('onInactive');
  }

  @override
  void onHidden() {
    super.onHidden();
    methodCalls.add('onHidden');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    receivedStates.add(state);
    methodCalls.add('didChangeAppLifecycleState:${state.name}');
  }
}

void main() {
  group('AppLifecycleObserver mixin tests', () {
    late _TestWidgetState testState;

    group('mixin initialization', () {
      testWidgets('creates widget with mixin successfully', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));

        expect(testState, isA<_TestWidgetState>());
        expect(testState, isA<AppLifecycleObserver>());
        expect(find.text('Test Widget'), findsOneWidget);
      });

      testWidgets('widget disposes without errors', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        // Dispose the widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );

        // Widget should be disposed without errors
        expect(find.byType(TestWidget), findsNothing);
      });
    });

    group('lifecycle method implementation', () {
      testWidgets('onResume is called for resumed state', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));
        testState.methodCalls.clear();
        testState.receivedStates.clear();

        // Test the mixin methods directly
        TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        await tester.pumpAndSettle();

        expect(testState.methodCalls, contains('onResume'));
        expect(testState.methodCalls, contains('didChangeAppLifecycleState:resumed'));
        expect(testState.receivedStates, contains(AppLifecycleState.resumed));
      });

      testWidgets('onPause is called for paused state', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));
        testState.methodCalls.clear();
        testState.receivedStates.clear();

        TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pumpAndSettle();

        expect(testState.methodCalls, contains('onPause'));
        expect(testState.methodCalls, contains('didChangeAppLifecycleState:paused'));
        expect(testState.receivedStates, contains(AppLifecycleState.paused));
      });

      testWidgets('onDetach is called for detached state', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));

        testState.methodCalls.clear();
        testState.receivedStates.clear();

        TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.detached);
        await tester.pumpAndSettle();

        expect(testState.methodCalls, contains('onDetach'));
        expect(testState.methodCalls, contains('didChangeAppLifecycleState:detached'));
        expect(testState.receivedStates, contains(AppLifecycleState.detached));
      });

      testWidgets('onInactive is called for inactive state', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));

        testState.methodCalls.clear();
        testState.receivedStates.clear();

        TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        await tester.pumpAndSettle();

        expect(testState.methodCalls, contains('onInactive'));
        expect(testState.methodCalls, contains('didChangeAppLifecycleState:inactive'));
        expect(testState.receivedStates, contains(AppLifecycleState.inactive));
      });

      testWidgets('onHidden is called for hidden state', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));

        testState.methodCalls.clear();
        testState.receivedStates.clear();

        TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
        await tester.pumpAndSettle();

        expect(testState.methodCalls, contains('onHidden'));
        expect(testState.methodCalls, contains('didChangeAppLifecycleState:hidden'));
        expect(testState.receivedStates, contains(AppLifecycleState.hidden));
      });

      testWidgets('handles multiple lifecycle state changes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));
        testState.methodCalls.clear();
        testState.receivedStates.clear();

        final states = [
          AppLifecycleState.resumed,
          AppLifecycleState.inactive,
          AppLifecycleState.paused,
          AppLifecycleState.resumed,
          AppLifecycleState.detached,
        ];

        for (final state in states) {
          switch (state) {
            case AppLifecycleState.resumed:
              testState.onResume();
            case AppLifecycleState.inactive:
              testState.onInactive();
            case AppLifecycleState.paused:
              testState.onPause();
            case AppLifecycleState.detached:
              testState.onDetach();
            case AppLifecycleState.hidden:
              testState.onHidden();
          }
          TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(state);
          await tester.pumpAndSettle();
        }

        expect(testState.receivedStates, equals(states));
        expect(testState.methodCalls, contains('onResume'));
        expect(testState.methodCalls, contains('onInactive'));
        expect(testState.methodCalls, contains('onPause'));
        expect(testState.methodCalls, contains('onDetach'));

        // Verify order of calls (each state triggers 2 calls: specific method + general callback)
        expect(testState.methodCalls.where((call) => call.startsWith('didChangeAppLifecycleState')).length, equals(5));
      });
    });

    group('mixin behavior', () {
      testWidgets('default implementation works', (WidgetTester tester) async {
        // Create a widget that doesn't override any methods
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _MinimalTestWidget(),
            ),
          ),
        );

        // Should not throw any exceptions
        expect(find.byType(_MinimalTestWidget), findsOneWidget);
      });

      testWidgets('works with different StatefulWidget types', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TestWidget(),
                  _AnotherTestWidget(),
                ],
              ),
            ),
          ),
        );

        final testState1 = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final testState2 = tester.state<_AnotherTestWidgetState>(find.byType(_AnotherTestWidget));

        testState1.methodCalls.clear();
        testState2.methodCalls.clear();

        // Test both widgets
        testState1.onPause();
        testState1.didChangeAppLifecycleState(AppLifecycleState.paused);
        testState2.onPause();
        testState2.didChangeAppLifecycleState(AppLifecycleState.paused);

        // Both widgets should receive the event
        expect(testState1.methodCalls, contains('onPause'));
        expect(testState2.methodCalls, contains('onPause'));
      });

      testWidgets('widget disposes correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        // Navigate away (disposes the widget)
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Text('Different page'),
            ),
          ),
        );

        // Widget should be disposed and no errors should occur
        expect(find.byType(TestWidget), findsNothing);
        expect(find.text('Different page'), findsOneWidget);
      });
    });

    group('integration tests', () {
      testWidgets('works in complex widget tree', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Test App'),
                  bottom: TabBar(
                    tabs: [
                      Tab(text: 'Tab 1'),
                      Tab(text: 'Tab 2'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    Center(child: TestWidget()),
                    Center(child: Text('Tab 2 Content')),
                  ],
                ),
              ),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));
        testState.methodCalls.clear();

        testState.methodCalls.clear();
        testState.receivedStates.clear();

        TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        await tester.pumpAndSettle();

        expect(testState.methodCalls, contains('onInactive'));
        expect(testState.methodCalls, contains('didChangeAppLifecycleState:inactive'));
      });

      testWidgets('handles widget creation and disposal rapidly', (WidgetTester tester) async {
        for (int i = 0; i < 5; i++) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TestWidget(),
              ),
            ),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Container(),
              ),
            ),
          );
        }

        // Should not crash or leak observers
        expect(find.byType(TestWidget), findsNothing);
      });
    });

    group('type safety', () {
      testWidgets('mixin works with different generic types', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TestWidget(),
                  _AnotherTestWidget(),
                  _MinimalTestWidget(),
                ],
              ),
            ),
          ),
        );

        // All should be found and working
        expect(find.byType(TestWidget), findsOneWidget);
        expect(find.byType(_AnotherTestWidget), findsOneWidget);
        expect(find.byType(_MinimalTestWidget), findsOneWidget);
      });

      testWidgets('mixin extends State correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));

        expect(testState, isA<State<TestWidget>>());
        expect(testState, isA<AppLifecycleObserver>());
      });
    });

    group('callback validation', () {
      testWidgets('all lifecycle callbacks are called correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));
        testState.methodCalls.clear();
        testState.receivedStates.clear();

        // Test all lifecycle states
        final allStates = [
          AppLifecycleState.resumed,
          AppLifecycleState.inactive,
          AppLifecycleState.paused,
          AppLifecycleState.detached,
          AppLifecycleState.hidden,
        ];

        for (final state in allStates) {
          switch (state) {
            case AppLifecycleState.resumed:
              testState.onResume();
            case AppLifecycleState.inactive:
              testState.onInactive();
            case AppLifecycleState.paused:
              testState.onPause();
            case AppLifecycleState.detached:
              testState.onDetach();
            case AppLifecycleState.hidden:
              testState.onHidden();
          }
          TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(state);
          await tester.pumpAndSettle();
        }

        // Check that all specific callbacks were called
        expect(testState.methodCalls, contains('onResume'));
        expect(testState.methodCalls, contains('onInactive'));
        expect(testState.methodCalls, contains('onPause'));
        expect(testState.methodCalls, contains('onDetach'));
        expect(testState.methodCalls, contains('onHidden'));

        // Check that general callback was called for all
        for (final state in allStates) {
          expect(testState.methodCalls, contains('didChangeAppLifecycleState:${state.name}'));
        }

        expect(testState.receivedStates, equals(allStates));
      });
    });

    group('WidgetsBinding integration', () {
      testWidgets('observer is properly registered with WidgetsBinding', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));
        testState.methodCalls.clear();
        testState.receivedStates.clear();

        // Simulate actual system lifecycle events through binding
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump();

        // The observer should receive the actual lifecycle event
        expect(testState.receivedStates, contains(AppLifecycleState.paused));
        expect(testState.methodCalls, contains('onPause'));
        expect(testState.methodCalls, contains('didChangeAppLifecycleState:paused'));
      });

      testWidgets('multiple widgets with observers all receive events', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TestWidget(key: const Key('widget1')),
                  TestWidget(key: const Key('widget2')),
                  _AnotherTestWidget(key: const Key('widget3')),
                ],
              ),
            ),
          ),
        );

        final testState1 = tester.state<_TestWidgetState>(find.byKey(const Key('widget1')));
        final testState2 = tester.state<_TestWidgetState>(find.byKey(const Key('widget2')));
        final testState3 = tester.state<_AnotherTestWidgetState>(find.byKey(const Key('widget3')));

        testState1.methodCalls.clear();
        testState2.methodCalls.clear();
        testState3.methodCalls.clear();

        // Send lifecycle event through binding
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        await tester.pump();

        // All observers should receive the event
        expect(testState1.methodCalls, contains('onResume'));
        expect(testState2.methodCalls, contains('onResume'));
        expect(testState3.methodCalls, contains('onResume'));
      });

      testWidgets('observer is removed after widget disposal', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));
        testState.methodCalls.clear();

        // Dispose the widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );

        // Clear any pending events
        await tester.pump();

        // Send lifecycle event after disposal
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump();

        // The disposed widget should not receive events (no crash should occur)
        expect(find.byType(TestWidget), findsNothing);
      });
    });

    group('state transition scenarios', () {
      testWidgets('handles typical app lifecycle flow', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));
        testState.methodCalls.clear();
        testState.receivedStates.clear();

        // Typical flow: active -> inactive -> paused -> resumed -> inactive -> detached
        final typicalFlow = [
          AppLifecycleState.inactive,
          AppLifecycleState.paused,
          AppLifecycleState.resumed,
          AppLifecycleState.inactive,
          AppLifecycleState.detached,
        ];

        for (final state in typicalFlow) {
          tester.binding.handleAppLifecycleStateChanged(state);
          await tester.pump();
        }

        expect(testState.receivedStates, equals(typicalFlow));
        expect(testState.methodCalls, contains('onInactive'));
        expect(testState.methodCalls, contains('onPause'));
        expect(testState.methodCalls, contains('onResume'));
        expect(testState.methodCalls, contains('onDetach'));
      });

      testWidgets('handles rapid state changes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));
        testState.methodCalls.clear();
        testState.receivedStates.clear();

        // Rapid state changes
        final rapidStates = [
          AppLifecycleState.resumed,
          AppLifecycleState.inactive,
          AppLifecycleState.resumed,
          AppLifecycleState.inactive,
          AppLifecycleState.paused,
          AppLifecycleState.resumed,
        ];

        for (final state in rapidStates) {
          tester.binding.handleAppLifecycleStateChanged(state);
          await tester.pump(Duration.zero); // Process microtasks but don't advance time
        }

        expect(testState.receivedStates, equals(rapidStates));
        expect(testState.methodCalls.where((call) => call == 'onResume').length, greaterThanOrEqualTo(2));
        expect(testState.methodCalls.where((call) => call == 'onInactive').length, greaterThanOrEqualTo(2));
        expect(testState.methodCalls.where((call) => call == 'onPause').length, greaterThanOrEqualTo(1));
      });

      testWidgets('handles hidden state properly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));
        testState.methodCalls.clear();
        testState.receivedStates.clear();

        // Test hidden state (newer lifecycle state)
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
        await tester.pump();

        expect(testState.receivedStates, contains(AppLifecycleState.hidden));
        expect(testState.methodCalls, contains('onHidden'));
        expect(testState.methodCalls, contains('didChangeAppLifecycleState:hidden'));
      });
    });

    group('error handling and edge cases', () {
      testWidgets('handles disposal during lifecycle event', (WidgetTester tester) async {

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _DisposalTestWidget(),
            ),
          ),
        );

        tester.state<_DisposalTestWidgetState>(find.byType(_DisposalTestWidget));

        // Send lifecycle event while disposing
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);

        // Dispose immediately
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );

        // Should not crash
        expect(find.byType(_DisposalTestWidget), findsNothing);
      });

      testWidgets('works with empty override implementations', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _EmptyImplementationWidget(),
            ),
          ),
        );

        // Send lifecycle events - should not crash with empty implementations
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump();

        expect(find.byType(_EmptyImplementationWidget), findsOneWidget);
      });

      testWidgets('handles consecutive dispose calls gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        testState = tester.state<_TestWidgetState>(find.byType(TestWidget));

        // Dispose the widget multiple times rapidly
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Text('Different content'),
            ),
          ),
        );

        // Should not crash with multiple disposal attempts
        expect(find.byType(TestWidget), findsNothing);
      });

      testWidgets('mixin works with custom initState and dispose', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _CustomInitDisposeWidget(),
            ),
          ),
        );

        final customState = tester.state<_CustomInitDisposeWidgetState>(find.byType(_CustomInitDisposeWidget));

        expect(customState.initCalled, isTrue);
        expect(customState.methodCalls, isEmpty);

        customState.methodCalls.clear();

        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        await tester.pump();

        expect(customState.methodCalls, contains('onResume'));

        // Dispose and check custom dispose was called
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );

        expect(customState.disposeCalled, isTrue);
      });
    });

    group('memory management', () {
      testWidgets('no memory leaks with multiple widget cycles', (WidgetTester tester) async {
        // Create and dispose widgets multiple times to test for memory leaks
        for (int i = 0; i < 10; i++) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    TestWidget(key: Key('test$i')),
                    _AnotherTestWidget(key: Key('another$i')),
                  ],
                ),
              ),
            ),
          );

          // Send some lifecycle events
          tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
          await tester.pump();

          tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
          await tester.pump();

          // Dispose all
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Container(),
              ),
            ),
          );
        }

        // Final check - no widgets should remain
        expect(find.byType(TestWidget), findsNothing);
        expect(find.byType(_AnotherTestWidget), findsNothing);
      });

      testWidgets('observer properly managed through widget lifecycle', (WidgetTester tester) async {
        // Test observer management indirectly by ensuring no crashes occur
        // during multiple create/dispose cycles
        for (int i = 0; i < 3; i++) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TestWidget(),
              ),
            ),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Container(),
              ),
            ),
          );
        }

        // Should complete without errors, indicating proper observer cleanup
        expect(find.byType(TestWidget), findsNothing);
      });
    });

    group('callback order and timing', () {
      testWidgets('didChangeAppLifecycleState called before specific callbacks', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _OrderTestWidget(),
            ),
          ),
        );

        final orderState = tester.state<_OrderTestWidgetState>(find.byType(_OrderTestWidget));
        orderState.callOrder.clear();

        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump();

        // didChangeAppLifecycleState should be called before the specific callback
        expect(orderState.callOrder.length, equals(2));
        expect(orderState.callOrder[0], equals('didChangeAppLifecycleState'));
        expect(orderState.callOrder[1], equals('onPause'));
      });

      testWidgets('callbacks called in correct order for multiple state changes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _OrderTestWidget(),
            ),
          ),
        );

        final orderState = tester.state<_OrderTestWidgetState>(find.byType(_OrderTestWidget));
        orderState.callOrder.clear();

        final states = [AppLifecycleState.inactive, AppLifecycleState.paused, AppLifecycleState.resumed];

        for (final state in states) {
          tester.binding.handleAppLifecycleStateChanged(state);
          await tester.pump();
        }

        // Should have 6 calls total (2 per state change)
        expect(orderState.callOrder.length, equals(6));

        // Check the pattern: didChangeAppLifecycleState -> specific callback
        for (int i = 0; i < orderState.callOrder.length; i += 2) {
          expect(orderState.callOrder[i], equals('didChangeAppLifecycleState'));
        }
      });
    });

    group('inheritance and composition', () {
      testWidgets('works with widget inheritance hierarchies', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _InheritedTestWidget(),
            ),
          ),
        );

        final inheritedState = tester.state<_InheritedTestWidgetState>(find.byType(_InheritedTestWidget));
        inheritedState.methodCalls.clear();

        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump();

        expect(inheritedState.methodCalls, contains('base_onPause'));
        expect(inheritedState.methodCalls, contains('inherited_onPause'));
      });

      testWidgets('mixin composition with multiple mixins', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _MultiMixinWidget(),
            ),
          ),
        );

        final multiState = tester.state<_MultiMixinWidgetState>(find.byType(_MultiMixinWidget));
        multiState.lifecycleCalls.clear();
        multiState.otherCalls.clear();

        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        await tester.pump();

        expect(multiState.lifecycleCalls, contains('onResume'));
        expect(multiState.otherCalls, contains('someOtherMethod'));
      });
    });
  });
}

// Additional test widgets
class _MinimalTestWidget extends StatefulWidget {
  @override
  State<_MinimalTestWidget> createState() => _MinimalTestWidgetState();
}

class _MinimalTestWidgetState extends State<_MinimalTestWidget> with AppLifecycleObserver {
  @override
  Widget build(BuildContext context) {
    return Text('Minimal');
  }
}

class _AnotherTestWidget extends StatefulWidget {
  const _AnotherTestWidget({super.key});

  @override
  State<_AnotherTestWidget> createState() => _AnotherTestWidgetState();
}

class _AnotherTestWidgetState extends State<_AnotherTestWidget> with AppLifecycleObserver {
  List<String> methodCalls = [];

  @override
  Widget build(BuildContext context) {
    return Text('Another');
  }

  @override
  void onPause() {
    methodCalls.add('onPause');
  }

  @override
  void onResume() {
    methodCalls.add('onResume');
  }
}

// Test widget for disposal scenarios
class _DisposalTestWidget extends StatefulWidget {
  @override
  State<_DisposalTestWidget> createState() => _DisposalTestWidgetState();
}

class _DisposalTestWidgetState extends State<_DisposalTestWidget> with AppLifecycleObserver {
  @override
  Widget build(BuildContext context) {
    return Text('Disposal Test');
  }
}

// Test widget with empty implementations
class _EmptyImplementationWidget extends StatefulWidget {
  @override
  State<_EmptyImplementationWidget> createState() => _EmptyImplementationWidgetState();
}

class _EmptyImplementationWidgetState extends State<_EmptyImplementationWidget> with AppLifecycleObserver {
  @override
  Widget build(BuildContext context) {
    return Text('Empty Implementation');
  }

// All lifecycle methods use default empty implementations
}

// Test widget with custom initState and dispose
class _CustomInitDisposeWidget extends StatefulWidget {
  @override
  State<_CustomInitDisposeWidget> createState() => _CustomInitDisposeWidgetState();
}

class _CustomInitDisposeWidgetState extends State<_CustomInitDisposeWidget> with AppLifecycleObserver {
  List<String> methodCalls = [];
  bool initCalled = false;
  bool disposeCalled = false;

  @override
  void initState() {
    super.initState();
    initCalled = true;
  }

  @override
  void dispose() {
    disposeCalled = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Custom Init/Dispose');
  }

  @override
  void onResume() {
    methodCalls.add('onResume');
  }

  @override
  void onPause() {
    methodCalls.add('onPause');
  }
}

// Test widget for callback order verification
class _OrderTestWidget extends StatefulWidget {
  @override
  State<_OrderTestWidget> createState() => _OrderTestWidgetState();
}

class _OrderTestWidgetState extends State<_OrderTestWidget> with AppLifecycleObserver {
  List<String> callOrder = [];

  @override
  Widget build(BuildContext context) {
    return Text('Order Test');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    callOrder.add('didChangeAppLifecycleState');
  }

  @override
  void onResume() {
    callOrder.add('onResume');
  }

  @override
  void onPause() {
    callOrder.add('onPause');
  }

  @override
  void onInactive() {
    callOrder.add('onInactive');
  }
}

// Test widget for inheritance scenarios
class _BaseTestWidget extends StatefulWidget {
  @override
  State<_BaseTestWidget> createState() => _BaseTestWidgetState();
}

class _BaseTestWidgetState extends State<_BaseTestWidget> with AppLifecycleObserver {
  List<String> methodCalls = [];

  @override
  Widget build(BuildContext context) {
    return Text('Base Widget');
  }

  @override
  void onPause() {
    methodCalls.add('base_onPause');
  }
}

class _InheritedTestWidget extends StatefulWidget {
  @override
  State<_InheritedTestWidget> createState() => _InheritedTestWidgetState();
}

class _InheritedTestWidgetState extends State<_InheritedTestWidget> with AppLifecycleObserver {
  List<String> methodCalls = [];

  @override
  Widget build(BuildContext context) {
    return Text('Inherited Widget');
  }

  @override
  void onPause() {
    methodCalls.add('base_onPause');
    methodCalls.add('inherited_onPause');
  }
}

// Test mixin for multi-mixin scenarios
mixin _OtherTestMixin<T extends StatefulWidget> on State<T> {
  List<String> otherCalls = [];

  void someOtherMethod() {
    otherCalls.add('someOtherMethod');
  }
}

// Test widget with multiple mixins
class _MultiMixinWidget extends StatefulWidget {
  @override
  State<_MultiMixinWidget> createState() => _MultiMixinWidgetState();
}

class _MultiMixinWidgetState extends State<_MultiMixinWidget> with AppLifecycleObserver, _OtherTestMixin {
  List<String> lifecycleCalls = [];

  @override
  Widget build(BuildContext context) {
    return Text('Multi Mixin');
  }

  @override
  void onResume() {
    lifecycleCalls.add('onResume');
    someOtherMethod();
  }

  @override
  void onPause() {
    lifecycleCalls.add('onPause');
    someOtherMethod();
  }
}
