// Author: Claude Code
// Created Date: September 17, 2025

import 'package:flutter/material.dart';
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
      expect(gapRenderBox.size.height, greaterThan(0)); // Takes available height
    });

    testWidgets('Gap throws error when not in Flex or scrollable', (tester) async {
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
    testWidgets('Gap works in SingleChildScrollView with Column', (tester) async {
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

    testWidgets('Gap works in SingleChildScrollView with Row (horizontal)', (tester) async {
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

    testWidgets('Gap works in CustomScrollView with SliverList', (tester) async {
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

    testWidgets('Gap works in CustomScrollView with horizontal SliverList', (tester) async {
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
      expect(gapRenderBox.size.height, greaterThan(0)); // Takes available height
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
                if (index == 1) return const Gap(gapSize, key: Key('builder-gap'));
                return const SizedBox(height: 50);
              },
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byKey(const Key('builder-gap')));
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
              itemBuilder: (context, index) => SizedBox(height: 50, child: Text('Item $index')),
              separatorBuilder: (context, index) => const Gap(gapSize, key: Key('separator-gap')),
            ),
          ),
        ),
      );

      final gapRenderBox = tester.renderObject<RenderBox>(find.byKey(const Key('separator-gap')));
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

      final gapRenderBox = tester.renderObject<RenderBox>(find.byKey(const Key('gap')));
      expect(gapRenderBox.size.height, equals(gapSize));
      expect(gapRenderBox.size.width, greaterThan(0)); // Takes available width
    });

    testWidgets('Gap works in complex nested scrollable structure', (tester) async {
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

      final outerGapRenderBox = tester.renderObject<RenderBox>(find.byKey(const Key('outer-gap')));
      final innerGapRenderBox = tester.renderObject<RenderBox>(find.byKey(const Key('inner-gap')));

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
}