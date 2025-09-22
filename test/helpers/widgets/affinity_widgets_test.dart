// Author: Claude Code
// Created Date: September 18, 2025

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Affinity enum tests', () {
    test('Affinity enum has correct values', () {
      expect(Affinity.values, hasLength(2));
      expect(Affinity.values, contains(Affinity.start));
      expect(Affinity.values, contains(Affinity.end));
    });

    test('Affinity.start has correct index', () {
      expect(Affinity.start.index, equals(0));
    });

    test('Affinity.end has correct index', () {
      expect(Affinity.end.index, equals(1));
    });

    test('Affinity enum can be compared', () {
      expect(Affinity.start, equals(Affinity.start));
      expect(Affinity.end, equals(Affinity.end));
      expect(Affinity.start, isNot(equals(Affinity.end)));
    });
  });

  group('DirectionalAffinity widget tests', () {
    testWidgets(
        'DirectionalAffinity creates basic horizontal widget with leading',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.horizontal,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
      expect(find.byType(DirectionalAffinity), findsOneWidget);

      final widget =
          tester.widget<DirectionalAffinity>(find.byType(DirectionalAffinity));
      expect(widget.direction, equals(Axis.horizontal));
      expect(widget.affinity, equals(Affinity.start));
    });

    testWidgets(
        'DirectionalAffinity creates basic horizontal widget with trailing',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.horizontal,
              trailing: const Icon(Icons.arrow_forward),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
      expect(find.byType(DirectionalAffinity), findsOneWidget);
    });

    testWidgets('DirectionalAffinity creates vertical widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.vertical,
              leading: const Icon(Icons.keyboard_arrow_up),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);

      final widget =
          tester.widget<DirectionalAffinity>(find.byType(DirectionalAffinity));
      expect(widget.direction, equals(Axis.vertical));
    });

    testWidgets('DirectionalAffinity with both leading and trailing',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.horizontal,
              leading: const Icon(Icons.arrow_back),
              trailing: const Icon(Icons.arrow_forward),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets(
        'DirectionalAffinity with Affinity.end places widgets correctly',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.horizontal,
              affinity: Affinity.end,
              leading: const Icon(Icons.star),
              trailing: const Icon(Icons.arrow_forward),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);

      final widget =
          tester.widget<DirectionalAffinity>(find.byType(DirectionalAffinity));
      expect(widget.affinity, equals(Affinity.end));
    });

    testWidgets('DirectionalAffinity respects mainAxisAlignment',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<DirectionalAffinity>(find.byType(DirectionalAffinity));
      expect(widget.mainAxisAlignment, equals(MainAxisAlignment.center));
    });

    testWidgets('DirectionalAffinity respects crossAxisAlignment',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.end,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<DirectionalAffinity>(find.byType(DirectionalAffinity));
      expect(widget.crossAxisAlignment, equals(CrossAxisAlignment.end));
    });

    testWidgets('DirectionalAffinity respects mainAxisSize', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.max,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<DirectionalAffinity>(find.byType(DirectionalAffinity));
      expect(widget.mainAxisSize, equals(MainAxisSize.max));
    });

    testWidgets('DirectionalAffinity respects spacing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.horizontal,
              spacing: 16,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<DirectionalAffinity>(find.byType(DirectionalAffinity));
      expect(widget.spacing, equals(16));
    });

    testWidgets('DirectionalAffinity default values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.horizontal,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<DirectionalAffinity>(find.byType(DirectionalAffinity));
      expect(widget.affinity, equals(Affinity.start));
      expect(widget.mainAxisSize, equals(MainAxisSize.min));
      expect(widget.mainAxisAlignment, equals(MainAxisAlignment.start));
      expect(widget.crossAxisAlignment, equals(CrossAxisAlignment.center));
      expect(widget.spacing, equals(8));
    });

    testWidgets('DirectionalAffinity has correct key', (tester) async {
      const key = Key('test-key');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              key: key,
              direction: Axis.horizontal,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });
  });

  group('HorizontalAffinity widget tests', () {
    testWidgets('HorizontalAffinity creates horizontal layout with leading',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalAffinity(
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
      expect(find.byType(HorizontalAffinity), findsOneWidget);

      final widget =
          tester.widget<HorizontalAffinity>(find.byType(HorizontalAffinity));
      expect(widget.direction, equals(Axis.horizontal));
    });

    testWidgets('HorizontalAffinity creates horizontal layout with trailing',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalAffinity(
              trailing: const Icon(Icons.arrow_forward),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('HorizontalAffinity with both leading and trailing',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalAffinity(
              leading: const Icon(Icons.arrow_back),
              trailing: const Icon(Icons.arrow_forward),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('HorizontalAffinity with Affinity.end', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalAffinity(
              affinity: Affinity.end,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<HorizontalAffinity>(find.byType(HorizontalAffinity));
      expect(widget.affinity, equals(Affinity.end));
    });

    testWidgets('HorizontalAffinity respects custom spacing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalAffinity(
              spacing: 16,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<HorizontalAffinity>(find.byType(HorizontalAffinity));
      expect(widget.spacing, equals(16));
    });

    testWidgets('HorizontalAffinity respects mainAxisAlignment',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalAffinity(
              mainAxisAlignment: MainAxisAlignment.center,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<HorizontalAffinity>(find.byType(HorizontalAffinity));
      expect(widget.mainAxisAlignment, equals(MainAxisAlignment.center));
    });

    testWidgets('HorizontalAffinity respects crossAxisAlignment',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalAffinity(
              crossAxisAlignment: CrossAxisAlignment.end,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<HorizontalAffinity>(find.byType(HorizontalAffinity));
      expect(widget.crossAxisAlignment, equals(CrossAxisAlignment.end));
    });

    testWidgets('HorizontalAffinity respects mainAxisSize', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalAffinity(
              mainAxisSize: MainAxisSize.max,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<HorizontalAffinity>(find.byType(HorizontalAffinity));
      expect(widget.mainAxisSize, equals(MainAxisSize.max));
    });

    testWidgets('HorizontalAffinity default values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalAffinity(
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<HorizontalAffinity>(find.byType(HorizontalAffinity));
      expect(widget.affinity, equals(Affinity.start));
      expect(widget.mainAxisSize, equals(MainAxisSize.min));
      expect(widget.mainAxisAlignment, equals(MainAxisAlignment.start));
      expect(widget.crossAxisAlignment, equals(CrossAxisAlignment.center));
      expect(widget.spacing, equals(8));
    });

    testWidgets('HorizontalAffinity has correct key', (tester) async {
      const key = Key('horizontal-key');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalAffinity(
              key: key,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });
  });

  group('VerticalAffinity widget tests', () {
    testWidgets('VerticalAffinity creates vertical layout with leading',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalAffinity(
              leading: const Icon(Icons.keyboard_arrow_up),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
      expect(find.byType(VerticalAffinity), findsOneWidget);

      final widget =
          tester.widget<VerticalAffinity>(find.byType(VerticalAffinity));
      expect(widget.direction, equals(Axis.vertical));
    });

    testWidgets('VerticalAffinity creates vertical layout with trailing',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalAffinity(
              trailing: const Icon(Icons.keyboard_arrow_down),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('VerticalAffinity with both leading and trailing',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalAffinity(
              leading: const Icon(Icons.keyboard_arrow_up),
              trailing: const Icon(Icons.keyboard_arrow_down),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('VerticalAffinity with Affinity.end', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalAffinity(
              affinity: Affinity.end,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<VerticalAffinity>(find.byType(VerticalAffinity));
      expect(widget.affinity, equals(Affinity.end));
    });

    testWidgets('VerticalAffinity respects custom spacing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalAffinity(
              spacing: 12,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<VerticalAffinity>(find.byType(VerticalAffinity));
      expect(widget.spacing, equals(12));
    });

    testWidgets('VerticalAffinity default values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalAffinity(
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<VerticalAffinity>(find.byType(VerticalAffinity));
      expect(widget.affinity, equals(Affinity.start));
      expect(widget.mainAxisSize, equals(MainAxisSize.min));
      expect(widget.mainAxisAlignment, equals(MainAxisAlignment.start));
      expect(widget.crossAxisAlignment, equals(CrossAxisAlignment.center));
      expect(widget.spacing, equals(8));
    });
  });

  group('Assertion tests', () {
    testWidgets(
        'DirectionalAffinity throws assertion when both leading and trailing are null',
        (tester) async {
      expect(
        () => DirectionalAffinity(
          direction: Axis.horizontal,
          child: const Text('Content'),
        ),
        throwsAssertionError,
      );
    });

    testWidgets(
        'HorizontalAffinity throws assertion when both leading and trailing are null',
        (tester) async {
      expect(
        () => HorizontalAffinity(
          child: const Text('Content'),
        ),
        throwsAssertionError,
      );
    });

    testWidgets(
        'VerticalAffinity throws assertion when both leading and trailing are null',
        (tester) async {
      expect(
        () => VerticalAffinity(
          child: const Text('Content'),
        ),
        throwsAssertionError,
      );
    });
  });

  group('Edge cases', () {
    testWidgets('DirectionalAffinity with only leading and Affinity.start',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.horizontal,
              affinity: Affinity.start,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('DirectionalAffinity with only trailing and Affinity.end',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.horizontal,
              affinity: Affinity.end,
              trailing: const Icon(Icons.arrow_forward),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('HorizontalAffinity with zero spacing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalAffinity(
              spacing: 0,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<HorizontalAffinity>(find.byType(HorizontalAffinity));
      expect(widget.spacing, equals(0));
    });

    testWidgets('VerticalAffinity with large spacing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalAffinity(
              spacing: 24,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<VerticalAffinity>(find.byType(VerticalAffinity));
      expect(widget.spacing, equals(24));
    });

    testWidgets('DirectionalAffinity with complex child widget',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.vertical,
              leading: const Icon(Icons.star),
              child: const Column(
                children: [
                  Text('Line 1'),
                  Text('Line 2'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Line 1'), findsOneWidget);
      expect(find.text('Line 2'), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });
  });

  group('Inheritance tests', () {
    testWidgets('HorizontalAffinity is a DirectionalAffinity', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalAffinity(
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<HorizontalAffinity>(find.byType(HorizontalAffinity));
      expect(widget, isA<DirectionalAffinity>());
      expect(find.byType(HorizontalAffinity), findsOneWidget);
    });

    testWidgets('VerticalAffinity is a DirectionalAffinity', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalAffinity(
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<VerticalAffinity>(find.byType(VerticalAffinity));
      expect(widget, isA<DirectionalAffinity>());
      expect(find.byType(VerticalAffinity), findsOneWidget);
    });

    testWidgets('DirectionalAffinity is a Flex', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.horizontal,
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<DirectionalAffinity>(find.byType(DirectionalAffinity));
      expect(widget, isA<Flex>());
      expect(find.byType(DirectionalAffinity), findsOneWidget);
    });
  });

  group('Property access tests', () {
    testWidgets('DirectionalAffinity exposes all properties correctly',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DirectionalAffinity(
              direction: Axis.horizontal,
              affinity: Affinity.end,
              leading: const Icon(Icons.star),
              trailing: const Icon(Icons.arrow_forward),
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 16,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<DirectionalAffinity>(find.byType(DirectionalAffinity));
      expect(widget.affinity, equals(Affinity.end));
      expect(widget.leading, isA<Icon>());
      expect(widget.trailing, isA<Icon>());
      expect(widget.child, isA<Text>());
      expect(widget.direction, equals(Axis.horizontal));
      expect(widget.mainAxisSize, equals(MainAxisSize.max));
      expect(widget.mainAxisAlignment, equals(MainAxisAlignment.center));
      expect(widget.crossAxisAlignment, equals(CrossAxisAlignment.end));
      expect(widget.spacing, equals(16));
    });

    testWidgets('HorizontalAffinity exposes inherited properties',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalAffinity(
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<HorizontalAffinity>(find.byType(HorizontalAffinity));
      expect(widget.direction, equals(Axis.horizontal));
      expect(widget.affinity, equals(Affinity.start));
      expect(widget.leading, isA<Icon>());
      expect(widget.child, isA<Text>());
    });

    testWidgets('VerticalAffinity exposes inherited properties',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalAffinity(
              leading: const Icon(Icons.star),
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final widget =
          tester.widget<VerticalAffinity>(find.byType(VerticalAffinity));
      expect(widget.direction, equals(Axis.vertical));
      expect(widget.affinity, equals(Affinity.start));
      expect(widget.leading, isA<Icon>());
      expect(widget.child, isA<Text>());
    });
  });

  group('Real-world usage tests', () {
    testWidgets('HorizontalAffinity in button with icon and text',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: HorizontalAffinity(
                leading: const Icon(Icons.download),
                child: const Text('Download'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byIcon(Icons.download), findsOneWidget);
      expect(find.text('Download'), findsOneWidget);
    });

    testWidgets('VerticalAffinity in voting widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalAffinity(
              leading: const Icon(Icons.keyboard_arrow_up),
              trailing: const Icon(Icons.keyboard_arrow_down),
              child: const Text('42'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('HorizontalAffinity in card with status indicator',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: HorizontalAffinity(
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                  child: const Text('Task completed'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('Task completed'), findsOneWidget);
    });
  });
}
