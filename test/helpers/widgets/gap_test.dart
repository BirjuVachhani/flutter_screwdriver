// Author: Claude Code
// Created Date: September 17, 2025

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Gap widget tests', () {
    testWidgets('Gap creates correct horizontal space in Row', (tester) async {
      const gapSize = 20.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                SizedBox(width: 10, height: 10),
                Gap(gapSize),
                SizedBox(width: 10, height: 10),
              ],
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));
      expect(gapRenderBox.size.height, equals(0));
    });

    testWidgets('Gap creates correct vertical space in Column', (tester) async {
      const gapSize = 30.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                SizedBox(width: 10, height: 10),
                Gap(gapSize),
                SizedBox(width: 10, height: 10),
              ],
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(0));
      expect(gapRenderBox.size.height, equals(gapSize));
    });

    testWidgets('Gap works in vertical ListView', (tester) async {
      const gapSize = 15.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                SizedBox(height: 50),
                Gap(gapSize),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      // In a ListView, Gap takes the full width but only the specified height
      expect(gapRenderBox.size.height, equals(gapSize));
      expect(gapRenderBox.size.width, greaterThan(0)); // Takes available width
    });

    testWidgets('Gap works in horizontal ListView', (tester) async {
      const gapSize = 25.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                SizedBox(width: 50, height: 50),
                Gap(gapSize),
                SizedBox(width: 50, height: 50),
              ],
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));
      // In horizontal ListView, Gap takes the full height but only the specified width
      expect(
          gapRenderBox.size.height, greaterThan(0)); // Takes available height
    });

    testWidgets('Gap throws error when not in Flex or scrollable',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Gap(10),
            ),
          ),
        ),
      );

      // Gap should throw an error when not in a Flex widget
      expect(tester.takeException(), isNotNull);
    });

    testWidgets('Gap handles zero size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                SizedBox(width: 10, height: 10),
                Gap(0),
                SizedBox(width: 10, height: 10),
              ],
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(0));
      expect(gapRenderBox.size.height, equals(0));
    });

    testWidgets('Gap works in nested Flex widgets', (tester) async {
      const gapSize = 20.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Row(
                  children: const [
                    SizedBox(width: 10, height: 10),
                    Gap(gapSize),
                    SizedBox(width: 10, height: 10),
                  ],
                ),
                const Gap(gapSize),
                Row(
                  children: const [
                    SizedBox(width: 10, height: 10),
                    Gap(gapSize),
                    SizedBox(width: 10, height: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final gaps = tester.renderObjectList<RenderBox>(find.byType(Gap));
      expect(gaps.length, equals(3));

      // First gap (in Row)
      expect(gaps.elementAt(0).size.width, equals(gapSize));
      expect(gaps.elementAt(0).size.height, equals(0));

      // Second gap (in Column)
      expect(gaps.elementAt(1).size.width, equals(0));
      expect(gaps.elementAt(1).size.height, equals(gapSize));

      // Third gap (in Row)
      expect(gaps.elementAt(2).size.width, equals(gapSize));
      expect(gaps.elementAt(2).size.height, equals(0));
    });

    testWidgets('Gap can be found by key', (tester) async {
      const testKey = Key('test-gap');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                SizedBox(width: 10, height: 10),
                Gap(20, key: testKey),
                SizedBox(width: 10, height: 10),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('Gap works with Flex properties', (tester) async {
      const gapSize = 50.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                SizedBox(width: 10, height: 10),
                Gap(gapSize),
                SizedBox(width: 10, height: 10),
              ],
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));
      expect(gapRenderBox.size.height, equals(0));
    });
  });

  group('Space alias tests', () {
    testWidgets('Space alias works the same as Gap', (tester) async {
      const gapSize = 40.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                SizedBox(width: 10, height: 10),
                Space(gapSize),
                SizedBox(width: 10, height: 10),
              ],
            ),
          ),
        ),
      );

      final spaceRenderBox = tester.renderObject<RenderBox>(find.byType(Space));
      expect(spaceRenderBox.size.width, equals(gapSize));
      expect(spaceRenderBox.size.height, equals(0));
    });
  });

  group('Gap in scrollable widgets', () {
    testWidgets('Gap works in SingleChildScrollView with Column',
        (tester) async {
      const gapSize = 20.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: const [
                  SizedBox(height: 100),
                  Gap(gapSize),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(0));
      expect(gapRenderBox.size.height, equals(gapSize));
    });

    testWidgets('Gap works in SingleChildScrollView with Row (horizontal)',
        (tester) async {
      const gapSize = 30.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  SizedBox(width: 100, height: 50),
                  Gap(gapSize),
                  SizedBox(width: 100, height: 50),
                ],
              ),
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));
      expect(gapRenderBox.size.height, equals(0));
    });

    testWidgets('Gap works in CustomScrollView with SliverList',
        (tester) async {
      const gapSize = 25.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 50),
                    const Gap(gapSize),
                    const SizedBox(height: 50),
                  ]),
                ),
              ],
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.height, equals(gapSize));
      expect(gapRenderBox.size.width, greaterThan(0)); // Takes available width
    });

    testWidgets('Gap works in CustomScrollView with horizontal SliverList',
        (tester) async {
      const gapSize = 35.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(width: 50, height: 100),
                    const Gap(gapSize),
                    const SizedBox(width: 50, height: 100),
                  ]),
                ),
              ],
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));
      expect(
          gapRenderBox.size.height, greaterThan(0)); // Takes available height
    });

    testWidgets('Gap works in NestedScrollView', (tester) async {
      const gapSize = 15.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                const SliverAppBar(title: Text('Test')),
              ],
              body: ListView(
                children: const [
                  SizedBox(height: 50),
                  Gap(gapSize),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.height, equals(gapSize));
      expect(gapRenderBox.size.width, greaterThan(0)); // Takes available width
    });

    testWidgets('Gap works in PageView with Column', (tester) async {
      const gapSize = 40.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageView(
              children: [
                Column(
                  children: const [
                    SizedBox(height: 100),
                    Gap(gapSize),
                    SizedBox(height: 100),
                  ],
                ),
                const Text('Page 2'),
              ],
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(0));
      expect(gapRenderBox.size.height, equals(gapSize));
    });

    testWidgets('Gap works in horizontal PageView with Row', (tester) async {
      const gapSize = 45.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: const [
                    SizedBox(width: 100, height: 50),
                    Gap(gapSize),
                    SizedBox(width: 100, height: 50),
                  ],
                ),
                const Text('Page 2'),
              ],
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));
      expect(gapRenderBox.size.height, equals(0));
    });

    testWidgets('Gap works in ListView.builder', (tester) async {
      const gapSize = 12.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                if (index == 0) return const SizedBox(height: 50);
                if (index == 1) {
                  return const Gap(gapSize, key: Key('builder-gap'));
                }
                return const SizedBox(height: 50);
              },
            ),
          ),
        ),
      );

      final gapRenderBox =
          tester.renderObject<RenderBox>(find.byKey(const Key('builder-gap')));
      expect(gapRenderBox.size.height, equals(gapSize));
      expect(gapRenderBox.size.width, greaterThan(0)); // Takes available width
    });

    testWidgets('Gap works in ListView.separated', (tester) async {
      const gapSize = 18.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.separated(
              itemCount: 2,
              itemBuilder: (context, index) =>
                  SizedBox(height: 50, child: Text('Item $index')),
              separatorBuilder: (context, index) =>
                  const Gap(gapSize, key: Key('separator-gap')),
            ),
          ),
        ),
      );

      final gapRenderBox = tester
          .renderObject<RenderBox>(find.byKey(const Key('separator-gap')));
      expect(gapRenderBox.size.height, equals(gapSize));
      expect(gapRenderBox.size.width, greaterThan(0)); // Takes available width
    });

    testWidgets('Gap works in ReorderableListView', (tester) async {
      const gapSize = 22.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReorderableListView(
              onReorder: (oldIndex, newIndex) {},
              children: const [
                SizedBox(key: Key('1'), height: 50),
                Gap(gapSize, key: Key('gap')),
                SizedBox(key: Key('2'), height: 50),
              ],
            ),
          ),
        ),
      );

      final gapRenderBox =
          tester.renderObject<RenderBox>(find.byKey(const Key('gap')));
      expect(gapRenderBox.size.height, equals(gapSize));
      expect(gapRenderBox.size.width, greaterThan(0)); // Takes available width
    });

    testWidgets('Gap works in complex nested scrollable structure',
        (tester) async {
      const outerGapSize = 30.0;
      const innerGapSize = 15.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 50),
                    const Gap(outerGapSize, key: Key('outer-gap')),
                    SizedBox(
                      height: 200,
                      child: ListView(
                        children: const [
                          SizedBox(height: 30),
                          Gap(innerGapSize, key: Key('inner-gap')),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      );

      final outerGapRenderBox =
          tester.renderObject<RenderBox>(find.byKey(const Key('outer-gap')));
      final innerGapRenderBox =
          tester.renderObject<RenderBox>(find.byKey(const Key('inner-gap')));

      // Outer gap in CustomScrollView
      expect(outerGapRenderBox.size.height, equals(outerGapSize));
      expect(outerGapRenderBox.size.width, greaterThan(0));

      // Inner gap in ListView
      expect(innerGapRenderBox.size.height, equals(innerGapSize));
      expect(innerGapRenderBox.size.width, greaterThan(0));
    });
  });

  group('Gap debug properties', () {
    testWidgets('Gap debug properties include size', (tester) async {
      const gapSize = 35.0;
      const testKey = Key('debug-gap');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                Gap(gapSize, key: testKey),
              ],
            ),
          ),
        ),
      );

      final gap = tester.widget<Gap>(find.byKey(testKey));
      expect(gap.size, equals(gapSize));
    });
  });

  group('Gap constructor and validation tests', () {
    test('Gap constructor accepts valid sizes', () {
      expect(() => Gap(0), returnsNormally);
      expect(() => Gap(10.5), returnsNormally);
      expect(() => Gap(100), returnsNormally);
    });

    test('Gap constructor rejects invalid sizes', () {
      expect(() => Gap(-1), throwsA(isA<AssertionError>()));
      expect(() => Gap(double.infinity), throwsA(isA<AssertionError>()));
      expect(() => Gap(-0.1), throwsA(isA<AssertionError>()));
    });

    test('Gap accepts edge case valid sizes', () {
      expect(() => Gap(0.0), returnsNormally);
      expect(() => Gap(double.maxFinite), returnsNormally);
    });
  });

  group('Gap updateRenderObject tests', () {
    testWidgets('Gap updates render object when scrollable context changes', (tester) async {
      const initialSize = 10.0;
      const updatedSize = 20.0;

      // Create a stateful widget to trigger updateRenderObject
      late StateSetter setStateCallback;
      double currentSize = initialSize;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                setStateCallback = setState;
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Gap(currentSize),
                    const SizedBox(height: 100),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Verify initial size
      var gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.height, equals(initialSize));

      // Update the size to trigger updateRenderObject
      setStateCallback(() {
        currentSize = updatedSize;
      });
      await tester.pump();

      // Verify updated size
      gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.height, equals(updatedSize));
    });

    testWidgets('Gap updateRenderObject handles context changes', (tester) async {
      const gapSize = 15.0;

      // Test that updateRenderObject is called when the widget rebuilds
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                Gap(gapSize),
                SizedBox(width: 100, height: 100),
              ],
            ),
          ),
        ),
      );

      // Verify initial state
      var gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));
      expect(gapRenderBox.size.height, equals(0));

      // Rebuild with the same widget (triggers updateRenderObject)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                Gap(gapSize),
                SizedBox(width: 100, height: 100),
              ],
            ),
          ),
        ),
      );

      // Verify the widget still works correctly after updateRenderObject
      gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));
      expect(gapRenderBox.size.height, equals(0));
    });
  });

  group('Gap debugFillProperties tests', () {
    testWidgets('Gap debugFillProperties includes size property', (tester) async {
      const gapSize = 25.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                Gap(gapSize),
              ],
            ),
          ),
        ),
      );

      final gap = tester.widget<Gap>(find.byType(Gap));
      final properties = DiagnosticPropertiesBuilder();
      gap.debugFillProperties(properties);

      final sizeProperty = properties.properties
          .whereType<DiagnosticsProperty<double>>()
          .firstWhere((prop) => prop.name == 'size');

      expect(sizeProperty.value, equals(gapSize));
    });
  });

  group('RenderGap setter tests', () {
    testWidgets('RenderGap gap setter triggers layout when value changes', (tester) async {
      const initialSize = 10.0;
      const newSize = 20.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                Gap(initialSize),
              ],
            ),
          ),
        ),
      );

      final renderGap = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(renderGap.size.width, equals(initialSize));

      // Access the render object through a custom render widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                Gap(newSize),
              ],
            ),
          ),
        ),
      );

      final updatedRenderGap = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(updatedRenderGap.size.width, equals(newSize));
    });

    testWidgets('RenderGap direction setter triggers layout when value changes', (tester) async {
      const gapSize = 15.0;

      // Test in a context where direction can be explicitly set through scrollable changes
      late StateSetter setStateCallback;
      Axis scrollDirection = Axis.vertical;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                setStateCallback = setState;
                return ListView(
                  scrollDirection: scrollDirection,
                  children: const [
                    Gap(gapSize),
                  ],
                );
              },
            ),
          ),
        ),
      );

      var gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.height, equals(gapSize));

      // Change direction through scrollable context
      setStateCallback(() {
        scrollDirection = Axis.horizontal;
      });
      await tester.pump();

      gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));
    });
  });

  group('RenderGap intrinsic dimension tests', () {
    testWidgets('RenderGap intrinsic dimensions work correctly in Row', (tester) async {
      const gapSize = 30.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IntrinsicHeight(
              child: Row(
                children: const [
                  SizedBox(width: 50, height: 100),
                  Gap(gapSize),
                  SizedBox(width: 50, height: 50),
                ],
              ),
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));

      // Test intrinsic dimensions
      expect(gapRenderBox.getMinIntrinsicWidth(100), equals(gapSize));
      expect(gapRenderBox.getMaxIntrinsicWidth(100), equals(gapSize));
      expect(gapRenderBox.getMinIntrinsicHeight(gapSize), equals(0));
      expect(gapRenderBox.getMaxIntrinsicHeight(gapSize), equals(0));
    });

    testWidgets('RenderGap intrinsic dimensions work correctly in Column', (tester) async {
      const gapSize = 40.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IntrinsicWidth(
              child: Column(
                children: const [
                  SizedBox(width: 100, height: 50),
                  Gap(gapSize),
                  SizedBox(width: 50, height: 50),
                ],
              ),
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));

      // Test intrinsic dimensions
      expect(gapRenderBox.getMinIntrinsicHeight(100), equals(gapSize));
      expect(gapRenderBox.getMaxIntrinsicHeight(100), equals(gapSize));
      expect(gapRenderBox.getMinIntrinsicWidth(gapSize), equals(0));
      expect(gapRenderBox.getMaxIntrinsicWidth(gapSize), equals(0));
    });

    testWidgets('RenderGap intrinsic dimensions work correctly in ListView', (tester) async {
      const gapSize = 25.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                SizedBox(height: 50),
                Gap(gapSize),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));

      // In ListView (vertical scrollable), Gap should have vertical size
      expect(gapRenderBox.getMinIntrinsicHeight(0), equals(gapSize));
      expect(gapRenderBox.getMaxIntrinsicHeight(0), equals(gapSize));
    });

    testWidgets('RenderGap intrinsic dimensions work correctly in horizontal ListView', (tester) async {
      const gapSize = 35.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                SizedBox(width: 50, height: 100),
                Gap(gapSize),
                SizedBox(width: 50, height: 100),
              ],
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));

      // In horizontal ListView, Gap should have horizontal size
      expect(gapRenderBox.getMinIntrinsicWidth(0), equals(gapSize));
      expect(gapRenderBox.getMaxIntrinsicWidth(0), equals(gapSize));
    });
  });

  group('RenderGap debugFillProperties tests', () {
    testWidgets('RenderGap debugFillProperties includes gap property', (tester) async {
      const gapSize = 20.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                Gap(gapSize),
              ],
            ),
          ),
        ),
      );

      final renderGap = tester.renderObject<RenderBox>(find.byType(Gap));
      final properties = DiagnosticPropertiesBuilder();
      renderGap.debugFillProperties(properties);

      final gapProperty = properties.properties
          .whereType<DiagnosticsProperty<double>>()
          .firstWhere((prop) => prop.name == 'gap');

      expect(gapProperty.value, equals(gapSize));
    });
  });

  group('RenderGap direction getter tests', () {
    testWidgets('RenderGap direction getter returns correct value', (tester) async {
      const gapSize = 10.0;

      // Test direction getter in vertical scrollable
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              scrollDirection: Axis.vertical,
              children: const [
                Gap(gapSize),
              ],
            ),
          ),
        ),
      );

      final renderGap = tester.renderObject(find.byType(Gap));
      expect((renderGap as dynamic).direction, equals(Axis.vertical));

      // Test direction getter in horizontal scrollable
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                Gap(gapSize),
              ],
            ),
          ),
        ),
      );

      final renderGapHorizontal = tester.renderObject(find.byType(Gap));
      expect((renderGapHorizontal as dynamic).direction, equals(Axis.horizontal));

      // Test direction getter in Flex widget (should be null)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                Gap(gapSize),
              ],
            ),
          ),
        ),
      );

      final renderGapFlex = tester.renderObject(find.byType(Gap));
      expect((renderGapFlex as dynamic).direction, isNull);
    });
  });

  group('Gap setter edge cases', () {
    testWidgets('RenderGap setter handles same value assignment correctly', (tester) async {
      const gapSize = 15.0;

      // Create a custom render widget to test setter behavior
      final testWidget = MaterialApp(
        home: Scaffold(
          body: Row(
            children: const [
              Gap(gapSize),
            ],
          ),
        ),
      );

      await tester.pumpWidget(testWidget);

      // Pump the same widget again - this should trigger updateRenderObject
      // which calls the setters with the same values
      await tester.pumpWidget(testWidget);

      final gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));
    });

    testWidgets('RenderGap direction setter executes assignment when direction actually changes', (tester) async {
      const gapSize = 20.0;

      // Start with a Row (horizontal direction)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                Gap(gapSize),
                SizedBox(width: 50, height: 50),
              ],
            ),
          ),
        ),
      );

      var gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));
      expect(gapRenderBox.size.height, equals(0));

      // Change to Column (vertical direction) - this should trigger the direction setter
      // with a different value, executing lines 85-86
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                Gap(gapSize),
                SizedBox(width: 50, height: 50),
              ],
            ),
          ),
        ),
      );

      gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(0));
      expect(gapRenderBox.size.height, equals(gapSize));
    });

    testWidgets('RenderGap direction setter executes assignment lines when direction value changes', (tester) async {
      const gapSize = 25.0;

      // Start with a specific scrollable direction (vertical ListView)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              scrollDirection: Axis.vertical,
              children: const [
                Gap(gapSize),
                SizedBox(width: 50, height: 50),
              ],
            ),
          ),
        ),
      );

      // Verify initial state - direction should be Axis.vertical from scrollable context
      var gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.height, equals(gapSize));

      // Now change to horizontal scrollable - this should trigger the direction setter
      // with a DIFFERENT value (Axis.horizontal vs Axis.vertical), executing lines 85-86
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                Gap(gapSize),
                SizedBox(width: 50, height: 50),
              ],
            ),
          ),
        ),
      );

      // The direction change should trigger _direction = value and markNeedsLayout()
      gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));
    });

    testWidgets('RenderGap direction setter from null to non-null value', (tester) async {
      const gapSize = 30.0;

      // Start with a Flex widget (no scrollable context - direction will be null)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                Gap(gapSize),
                SizedBox(width: 50, height: 50),
              ],
            ),
          ),
        ),
      );

      // Verify initial state in Row
      var gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));

      // Now change to a scrollable context - this should change direction from null to Axis.vertical
      // This should execute the assignment lines since null != Axis.vertical
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              scrollDirection: Axis.vertical,
              children: const [
                Gap(gapSize),
                SizedBox(width: 50, height: 50),
              ],
            ),
          ),
        ),
      );

      // Direction changed from null to Axis.vertical - should execute lines 85-86
      gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.height, equals(gapSize));
    });

    testWidgets('RenderGap direction setter non-null to different non-null value', (tester) async {
      const gapSize = 35.0;

      // This is the key test - start with a vertical PageView (scrollable context)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageView(
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  children: const [
                    Gap(gapSize),
                    SizedBox(width: 50, height: 50),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // Gap should be vertical due to PageView's scrollDirection
      var gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.height, equals(gapSize));

      // Now change to horizontal PageView - this should change direction from Axis.vertical to Axis.horizontal
      // This is crucial: updateRenderObject will be called with a DIFFERENT direction value
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: const [
                    Gap(gapSize),
                    SizedBox(width: 50, height: 50),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // Direction changed from Axis.vertical to Axis.horizontal
      // This should execute _direction = value; and markNeedsLayout(); (lines 85-86)
      gapRenderBox = tester.renderObject<RenderBox>(find.byType(Gap));
      expect(gapRenderBox.size.width, equals(gapSize));
    });
  });
}
