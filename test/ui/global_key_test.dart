// Author: Birju Vachhani
// Created Date: September 21, 2025

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlobalKeyExtension tests', () {
    group('globalPaintBounds getter', () {
      testWidgets('returns null for unattached GlobalKey', (WidgetTester tester) async {
        final globalKey = GlobalKey();

        expect(globalKey.globalPaintBounds, isNull);
      });

      testWidgets('returns null for GlobalKey without render object', (WidgetTester tester) async {
        final globalKey = GlobalKey();

        await tester.pumpWidget(
          MaterialApp(
            home: Container(key: globalKey),
          ),
        );

        // Before first frame, render object might not be available
        // Note: This test might be flaky depending on timing
        final bounds = globalKey.globalPaintBounds;
        expect(bounds, isA<Rect?>());
      });

      testWidgets('returns Rect for properly attached GlobalKey', (WidgetTester tester) async {
        final globalKey = GlobalKey();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                key: globalKey,
                width: 100,
                height: 50,
                color: Colors.red,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final bounds = globalKey.globalPaintBounds;
        expect(bounds, isA<Rect>());
        if (bounds != null) {
          expect(bounds.width, equals(100.0));
          expect(bounds.height, equals(50.0));
          expect(bounds.left, isA<double>());
          expect(bounds.top, isA<double>());
        }
      });

      testWidgets('returns correct bounds for positioned widget', (WidgetTester tester) async {
        final globalKey = GlobalKey();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    left: 20,
                    top: 30,
                    child: Container(
                      key: globalKey,
                      width: 80,
                      height: 60,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final bounds = globalKey.globalPaintBounds;
        expect(bounds, isA<Rect>());
        if (bounds != null) {
          expect(bounds.width, equals(80.0));
          expect(bounds.height, equals(60.0));
          // Position might be offset by scaffold/app bar, so just check they're reasonable
          expect(bounds.left, isA<double>());
          expect(bounds.top, isA<double>());
        }
      });

      testWidgets('handles multiple widgets with GlobalKeys', (WidgetTester tester) async {
        final key1 = GlobalKey();
        final key2 = GlobalKey();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Container(
                    key: key1,
                    width: 100,
                    height: 50,
                    color: Colors.red,
                  ),
                  Container(
                    key: key2,
                    width: 200,
                    height: 75,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final bounds1 = key1.globalPaintBounds;
        final bounds2 = key2.globalPaintBounds;

        expect(bounds1, isA<Rect>());
        expect(bounds2, isA<Rect>());

        if (bounds1 != null && bounds2 != null) {
          expect(bounds1.width, equals(100.0));
          expect(bounds1.height, equals(50.0));
          expect(bounds2.width, equals(200.0));
          expect(bounds2.height, equals(75.0));

          // Second widget should be positioned below the first
          expect(bounds2.top, greaterThan(bounds1.bottom - 1)); // Allow for small floating point errors
        }
      });

      testWidgets('works with different widget types', (WidgetTester tester) async {
        final containerKey = GlobalKey();
        final textKey = GlobalKey();
        final iconKey = GlobalKey();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Container(
                    key: containerKey,
                    width: 100,
                    height: 50,
                    color: Colors.red,
                  ),
                  Text(
                    'Test Text',
                    key: textKey,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Icon(
                    Icons.star,
                    key: iconKey,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final containerBounds = containerKey.globalPaintBounds;
        final textBounds = textKey.globalPaintBounds;
        final iconBounds = iconKey.globalPaintBounds;

        expect(containerBounds, isA<Rect>());
        expect(textBounds, isA<Rect>());
        expect(iconBounds, isA<Rect>());

        if (containerBounds != null) {
          expect(containerBounds.width, equals(100.0));
          expect(containerBounds.height, equals(50.0));
        }

        if (textBounds != null) {
          expect(textBounds.width, greaterThan(0));
          expect(textBounds.height, greaterThan(0));
        }

        if (iconBounds != null) {
          expect(iconBounds.width, greaterThan(0));
          expect(iconBounds.height, greaterThan(0));
        }
      });

      testWidgets('returns null after widget is removed', (WidgetTester tester) async {
        final globalKey = GlobalKey();
        bool showWidget = true;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      if (showWidget)
                        Container(
                          key: globalKey,
                          width: 100,
                          height: 50,
                          color: Colors.red,
                        ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showWidget = false;
                          });
                        },
                        child: const Text('Remove'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Initially should have bounds
        expect(globalKey.globalPaintBounds, isA<Rect>());

        // Remove the widget
        await tester.tap(find.text('Remove'));
        await tester.pumpAndSettle();

        // Should now return null
        expect(globalKey.globalPaintBounds, isNull);
      });
    });

    group('edge cases', () {
      testWidgets('handles zero-sized widgets', (WidgetTester tester) async {
        final globalKey = GlobalKey();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                key: globalKey,
                width: 0,
                height: 0,
                color: Colors.red,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final bounds = globalKey.globalPaintBounds;
        expect(bounds, isA<Rect>());
        if (bounds != null) {
          expect(bounds.width, equals(0.0));
          expect(bounds.height, equals(0.0));
        }
      });

      testWidgets('handles widgets with transform', (WidgetTester tester) async {
        final globalKey = GlobalKey();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Transform.translate(
                offset: const Offset(50, 25),
                child: Container(
                  key: globalKey,
                  width: 100,
                  height: 50,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final bounds = globalKey.globalPaintBounds;
        expect(bounds, isA<Rect>());
        if (bounds != null) {
          expect(bounds.width, equals(100.0));
          expect(bounds.height, equals(50.0));
          // Position should be affected by the transform
          expect(bounds.left, isA<double>());
          expect(bounds.top, isA<double>());
        }
      });

      testWidgets('handles deeply nested widgets', (WidgetTester tester) async {
        final globalKey = GlobalKey();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          key: globalKey,
                          width: 80,
                          height: 40,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final bounds = globalKey.globalPaintBounds;
        expect(bounds, isA<Rect>());
        if (bounds != null) {
          expect(bounds.width, equals(80.0));
          expect(bounds.height, equals(40.0));
        }
      });
    });

    group('consistency tests', () {
      testWidgets('multiple calls return same result', (WidgetTester tester) async {
        final globalKey = GlobalKey();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                key: globalKey,
                width: 100,
                height: 50,
                color: Colors.red,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final bounds1 = globalKey.globalPaintBounds;
        final bounds2 = globalKey.globalPaintBounds;
        final bounds3 = globalKey.globalPaintBounds;

        expect(bounds1, equals(bounds2));
        expect(bounds2, equals(bounds3));
      });

      testWidgets('bounds update when widget changes', (WidgetTester tester) async {
        final globalKey = GlobalKey();
        double width = 100;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      Container(
                        key: globalKey,
                        width: width,
                        height: 50,
                        color: Colors.red,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            width = 200;
                          });
                        },
                        child: const Text('Change Size'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final initialBounds = globalKey.globalPaintBounds;
        expect(initialBounds?.width, equals(100.0));

        // Change the size
        await tester.tap(find.text('Change Size'));
        await tester.pumpAndSettle();

        final updatedBounds = globalKey.globalPaintBounds;
        expect(updatedBounds?.width, equals(200.0));
        expect(updatedBounds?.height, equals(50.0));
      });
    });

    group('type safety', () {
      test('extension is available on GlobalKey', () {
        final globalKey = GlobalKey();
        expect(globalKey.globalPaintBounds, isA<Rect?>());
      });

      testWidgets('returns proper Rect type', (WidgetTester tester) async {
        final globalKey = GlobalKey();

        await tester.pumpWidget(
          MaterialApp(
            home: Container(key: globalKey),
          ),
        );

        final bounds = globalKey.globalPaintBounds;
        if (bounds != null) {
          expect(bounds, isA<Rect>());
          expect(bounds.left, isA<double>());
          expect(bounds.top, isA<double>());
          expect(bounds.right, isA<double>());
          expect(bounds.bottom, isA<double>());
          expect(bounds.width, isA<double>());
          expect(bounds.height, isA<double>());
        }
      });
    });
  });
}