// Author: Birju Vachhani
// Created Date: September 21, 2025

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screwdriver/src/helpers/widgets/post_frame.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostFrame widget tests', () {
    group('constructor and properties', () {
      testWidgets('creates with required parameters', (WidgetTester tester) async {
        const child = Text('Test Child');
        bool callbackExecuted = false;

        final postFrame = PostFrame(
          child: child,
          onPostFrame: (duration) {
            callbackExecuted = true;
          },
        );

        expect(postFrame.child, equals(child));
        expect(postFrame.onPostFrame, isA<FrameCallback>());
      });

      testWidgets('has correct widget type', (WidgetTester tester) async {
        final postFrame = PostFrame(
          child: const Text('Test'),
          onPostFrame: (duration) {},
        );

        expect(postFrame, isA<StatefulWidget>());
      });
    });

    group('callback execution', () {
      testWidgets('executes callback after first frame', (WidgetTester tester) async {
        bool callbackExecuted = false;
        Duration? receivedDuration;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostFrame(
                child: const Text('Test Child'),
                onPostFrame: (duration) {
                  callbackExecuted = true;
                  receivedDuration = duration;
                },
              ),
            ),
          ),
        );

        // After pumpWidget, frame should be complete and callback executed
        await tester.pumpAndSettle();

        // Callback should be executed after frame completion
        expect(callbackExecuted, isTrue);
        expect(receivedDuration, isA<Duration>());
      });

      testWidgets('callback executes only once', (WidgetTester tester) async {
        int callbackCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostFrame(
                child: const Text('Test Child'),
                onPostFrame: (duration) {
                  callbackCount++;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(callbackCount, equals(1));

        // Pump additional frames
        await tester.pump();
        await tester.pump();
        await tester.pump();

        // Callback should still have been called only once
        expect(callbackCount, equals(1));
      });

      testWidgets('callback receives valid duration', (WidgetTester tester) async {
        Duration? receivedDuration;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostFrame(
                child: const Text('Test Child'),
                onPostFrame: (duration) {
                  receivedDuration = duration;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(receivedDuration, isNotNull);
        expect(receivedDuration, isA<Duration>());
        expect(receivedDuration!.inMicroseconds, greaterThanOrEqualTo(0));
      });

      testWidgets('multiple PostFrame widgets execute independently', (WidgetTester tester) async {
        bool callback1Executed = false;
        bool callback2Executed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  PostFrame(
                    child: const Text('Child 1'),
                    onPostFrame: (duration) {
                      callback1Executed = true;
                    },
                  ),
                  PostFrame(
                    child: const Text('Child 2'),
                    onPostFrame: (duration) {
                      callback2Executed = true;
                    },
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(callback1Executed, isTrue);
        expect(callback2Executed, isTrue);
      });
    });

    group('child widget rendering', () {
      testWidgets('renders child widget correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostFrame(
                child: const Text('Test Child'),
                onPostFrame: (duration) {},
              ),
            ),
          ),
        );

        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('preserves child widget properties', (WidgetTester tester) async {
        const key = Key('test-key');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostFrame(
                child: Container(
                  key: key,
                  width: 100,
                  height: 100,
                  color: Colors.red,
                  child: const Text('Test'),
                ),
                onPostFrame: (duration) {},
              ),
            ),
          ),
        );

        expect(find.byKey(key), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);

        final container = tester.widget<Container>(find.byKey(key));
        expect(container.constraints?.tighten(width: 100, height: 100), isNotNull);
      });

      testWidgets('works with complex child widgets', (WidgetTester tester) async {
        bool callbackExecuted = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostFrame(
                child: Column(
                  children: [
                    const Text('Header'),
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue,
                      child: Row(
                        children: [
                          const Icon(Icons.star),
                          const SizedBox(width: 8),
                          const Text('Complex Child'),
                        ],
                      ),
                    ),
                    const TextField(decoration: InputDecoration(hintText: 'Enter text')),
                  ],
                ),
                onPostFrame: (duration) {
                  callbackExecuted = true;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Header'), findsOneWidget);
        expect(find.text('Complex Child'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        expect(callbackExecuted, isTrue);
      });
    });

    group('widget lifecycle', () {
      testWidgets('callback executes during initState', (WidgetTester tester) async {
        bool callbackExecuted = false;
        bool initStateCompleted = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostFrame(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    if (!initStateCompleted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        initStateCompleted = true;
                      });
                    }
                    return const Text('Test');
                  },
                ),
                onPostFrame: (duration) {
                  callbackExecuted = true;
                },
              ),
            ),
          ),
        );

        // After initial pump, callback should be executed
        await tester.pumpAndSettle();

        expect(callbackExecuted, isTrue);
        expect(initStateCompleted, isTrue);
      });

      testWidgets('works when widget is rebuilt', (WidgetTester tester) async {
        int callbackCount = 0;
        int rebuildCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      PostFrame(
                        child: Text('Rebuild count: $rebuildCount'),
                        onPostFrame: (duration) {
                          callbackCount++;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            rebuildCount++;
                          });
                        },
                        child: const Text('Rebuild'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(callbackCount, equals(1));
        expect(find.text('Rebuild count: 0'), findsOneWidget);

        // Trigger rebuild
        await tester.tap(find.text('Rebuild'));
        await tester.pumpAndSettle();

        expect(callbackCount, equals(1)); // Should still be 1 as initState is not called again
        expect(find.text('Rebuild count: 1'), findsOneWidget);
      });

      testWidgets('handles widget disposal correctly', (WidgetTester tester) async {
        bool callbackExecuted = false;
        bool showPostFrame = true;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      if (showPostFrame)
                        PostFrame(
                          child: const Text('PostFrame Widget'),
                          onPostFrame: (duration) {
                            callbackExecuted = true;
                          },
                        ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showPostFrame = false;
                          });
                        },
                        child: const Text('Remove PostFrame'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(callbackExecuted, isTrue);
        expect(find.text('PostFrame Widget'), findsOneWidget);

        // Remove the PostFrame widget
        await tester.tap(find.text('Remove PostFrame'));
        await tester.pumpAndSettle();

        expect(find.text('PostFrame Widget'), findsNothing);
        // Should not crash or cause issues
      });
    });

    group('timing and frame callback', () {
      testWidgets('callback executes after build but before next frame', (WidgetTester tester) async {
        final callbackTimes = <DateTime>[];
        final buildTimes = <DateTime>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostFrame(
                child: Builder(
                  builder: (context) {
                    buildTimes.add(DateTime.now());
                    return const Text('Test');
                  },
                ),
                onPostFrame: (duration) {
                  callbackTimes.add(DateTime.now());
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(buildTimes.length, equals(1));
        expect(callbackTimes.length, equals(1));

        // Callback should execute after build
        expect(callbackTimes.first.isAfter(buildTimes.first) ||
               callbackTimes.first.isAtSameMomentAs(buildTimes.first), isTrue);
      });
    });

    group('error handling', () {
      testWidgets('callback can access duration parameter', (WidgetTester tester) async {
        Duration? receivedDuration;
        bool callbackExecuted = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostFrame(
                child: const Text('Test'),
                onPostFrame: (duration) {
                  receivedDuration = duration;
                  callbackExecuted = true;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(callbackExecuted, isTrue);
        expect(receivedDuration, isA<Duration>());
        expect(receivedDuration!.inMicroseconds, greaterThanOrEqualTo(0));
      });

      testWidgets('works with null-safe operations', (WidgetTester tester) async {
        Duration? receivedDuration;
        bool callbackExecuted = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PostFrame(
                child: const Text('Test'),
                onPostFrame: (duration) {
                  receivedDuration = duration;
                  callbackExecuted = true;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(callbackExecuted, isTrue);
        expect(receivedDuration, isNotNull);
        expect(receivedDuration!.inMicroseconds, isA<int>());
      });
    });
  });

  group('PostFrameCallbackMixin tests', () {
    late _TestWidget testWidget;
    late _TestWidgetState testState;

    setUp(() {
      testWidget = _TestWidget();
    });

    group('mixin functionality', () {
      testWidgets('mixin calls onPostFrame after initState', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: testWidget,
            ),
          ),
        );

        await tester.pumpAndSettle();

        testState = tester.state<_TestWidgetState>(find.byType(_TestWidget));

        expect(testState.callbackExecuted, isTrue);
        expect(testState.receivedDuration, isA<Duration>());
      });

      testWidgets('mixin works with custom StatefulWidget', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: testWidget,
            ),
          ),
        );

        await tester.pumpAndSettle();

        testState = tester.state<_TestWidgetState>(find.byType(_TestWidget));

        expect(testState.callbackExecuted, isTrue);
        expect(testState.initStateCompleted, isTrue);
        expect(find.text('Mixin Test Widget'), findsOneWidget);
      });

      testWidgets('mixin callback executes only once per widget lifecycle', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: testWidget,
            ),
          ),
        );

        await tester.pumpAndSettle();

        testState = tester.state<_TestWidgetState>(find.byType(_TestWidget));
        final initialCount = testState.callbackCount;

        expect(initialCount, equals(1));

        // Pump additional frames
        await tester.pump();
        await tester.pump();

        expect(testState.callbackCount, equals(initialCount));
      });

      testWidgets('mixin works with widget rebuild', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: testWidget,
            ),
          ),
        );

        await tester.pumpAndSettle();

        testState = tester.state<_TestWidgetState>(find.byType(_TestWidget));
        expect(testState.callbackCount, equals(1));

        // Trigger rebuild by changing widget key
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _TestWidget(key: const Key('new-key')),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final newState = tester.state<_TestWidgetState>(find.byType(_TestWidget));
        expect(newState.callbackCount, equals(1)); // New instance should have callback executed once
      });
    });

    group('mixin lifecycle', () {
      testWidgets('mixin integrates properly with State lifecycle', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: testWidget,
            ),
          ),
        );

        await tester.pumpAndSettle();

        testState = tester.state<_TestWidgetState>(find.byType(_TestWidget));

        expect(testState.initStateCompleted, isTrue);
        expect(testState.buildCompleted, isTrue);
        expect(testState.callbackExecuted, isTrue);
      });
    });
  });
}

// Test widget that uses PostFrameCallbackMixin
class _TestWidget extends StatefulWidget {
  const _TestWidget({super.key});

  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<_TestWidget> with PostFrameCallbackMixin {
  bool callbackExecuted = false;
  bool initStateCompleted = false;
  bool buildCompleted = false;
  Duration? receivedDuration;
  int callbackCount = 0;

  @override
  void initState() {
    super.initState();
    initStateCompleted = true;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      buildCompleted = true;
    });
    return const Text('Mixin Test Widget');
  }

  @override
  void onPostFrame(Duration duration) {
    callbackExecuted = true;
    receivedDuration = duration;
    callbackCount++;
  }
}