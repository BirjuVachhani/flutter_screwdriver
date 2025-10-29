// Author: Birju Vachhani
// Created Date: October 29, 2025

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/src/helpers/mixins/stream_subscription_state_mixin.dart';
import 'package:flutter_test/flutter_test.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget>
    with StreamSubscriptionStateMixin {
  List<int> receivedData = [];
  List<String> receivedErrors = [];

  @override
  Widget build(BuildContext context) {
    return const Text('Test');
  }
}

void main() {
  group('StreamSubscriptionStateMixin', () {
    testWidgets('listenTo adds subscription and receives data',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      final controller = StreamController<int>.broadcast();

      state.listenTo(controller.stream, (data) {
        state.receivedData.add(data);
      });

      controller.add(1);
      controller.add(2);
      await tester.pumpAndSettle();

      expect(state.receivedData, equals([1, 2]));
      await controller.close();
    });

    testWidgets('listenTo with custom scope', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      final controller = StreamController<int>.broadcast();

      state.listenTo(
        controller.stream,
        (data) => state.receivedData.add(data),
        scope: 'custom',
      );

      controller.add(1);
      await tester.pumpAndSettle();

      expect(state.receivedData, equals([1]));
      await controller.close();
    });

    testWidgets('listenTo with multiple scopes', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      final c1 = StreamController<int>.broadcast();
      final c2 = StreamController<int>.broadcast();

      state.listenTo(
        c1.stream,
        (data) => state.receivedData.add(data),
        scope: 'scope1',
      );

      state.listenTo(
        c2.stream,
        (data) => state.receivedData.add(data * 10),
        scope: 'scope2',
      );

      c1.add(1);
      c2.add(2);
      await tester.pumpAndSettle();

      expect(state.receivedData, equals([1, 20]));
      await c1.close();
      await c2.close();
    });

    testWidgets('cancelScopedSubscriptions cancels only targeted scope',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      final c1 = StreamController<int>.broadcast();
      final c2 = StreamController<int>.broadcast();

      state.listenTo(
        c1.stream,
        (data) => state.receivedData.add(data),
        scope: 'scope1',
      );

      state.listenTo(
        c2.stream,
        (data) => state.receivedData.add(data * 10),
        scope: 'scope2',
      );

      c1.add(1);
      c2.add(2);
      await tester.pumpAndSettle();

      expect(state.receivedData, equals([1, 20]));

      state.cancelScopedSubscriptions('scope1');
      state.receivedData.clear();

      c1.add(3);
      c2.add(4);
      await tester.pumpAndSettle();

      expect(state.receivedData, equals([40]));
      await c1.close();
      await c2.close();
    });

    testWidgets('cancelScopedSubscriptions on nonexistent scope is safe',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));

      expect(
        () => state.cancelScopedSubscriptions('nonexistent'),
        returnsNormally,
      );
    });

    testWidgets('cancelSubscriptions cancels all subscriptions',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      final c1 = StreamController<int>.broadcast();
      final c2 = StreamController<int>.broadcast();

      state.listenTo(
        c1.stream,
        (data) => state.receivedData.add(data),
      );

      state.listenTo(
        c2.stream,
        (data) => state.receivedData.add(data * 10),
        scope: 'other',
      );

      c1.add(1);
      c2.add(2);
      await tester.pumpAndSettle();

      expect(state.receivedData, equals([1, 20]));

      state.cancelSubscriptions();
      state.receivedData.clear();

      c1.add(3);
      c2.add(4);
      await tester.pumpAndSettle();

      expect(state.receivedData, isEmpty);
      await c1.close();
      await c2.close();
    });

    testWidgets('dispose cancels all subscriptions', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      final controller = StreamController<int>.broadcast();

      state.listenTo(
        controller.stream,
        (data) => state.receivedData.add(data),
      );

      controller.add(1);
      await tester.pumpAndSettle();

      expect(state.receivedData, equals([1]));

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      controller.add(2);
      await tester.pumpAndSettle();

      expect(state.receivedData, equals([1]));
      await controller.close();
    });

    testWidgets('listenTo with onError', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      final controller = StreamController<int>.broadcast();

      state.listenTo(
        controller.stream,
        (data) => state.receivedData.add(data),
        onError: (e) => state.receivedErrors.add(e.toString()),
      );

      controller.add(1);
      controller.addError('error');
      controller.add(2);
      await tester.pumpAndSettle();

      expect(state.receivedData, equals([1, 2]));
      expect(state.receivedErrors, equals(['error']));
      await controller.close();
    });

    testWidgets('listenTo with onDone', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      int doneCount = 0;
      final controller = StreamController<int>.broadcast();

      state.listenTo(
        controller.stream,
        (data) => state.receivedData.add(data),
        onDone: () => doneCount++,
      );

      controller.add(1);
      await controller.close();
      await tester.pumpAndSettle();

      expect(state.receivedData, equals([1]));
      expect(doneCount, equals(1));
    });

    test('defaultScope constant is "default"', () {
      expect(StreamSubscriptionStateMixin.defaultScope, equals('default'));
    });

    testWidgets('multiple subscriptions in same scope', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      final c1 = StreamController<int>.broadcast();
      final c2 = StreamController<int>.broadcast();

      state.listenTo(
        c1.stream,
        (data) => state.receivedData.add(data),
        scope: 'same',
      );

      state.listenTo(
        c2.stream,
        (data) => state.receivedData.add(data * 10),
        scope: 'same',
      );

      c1.add(1);
      c2.add(2);
      await tester.pumpAndSettle();

      expect(state.receivedData, equals([1, 20]));

      state.cancelScopedSubscriptions('same');
      state.receivedData.clear();

      c1.add(3);
      c2.add(4);
      await tester.pumpAndSettle();

      expect(state.receivedData, isEmpty);
      await c1.close();
      await c2.close();
    });

    testWidgets('cancelSubscriptions when empty is safe', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));

      expect(() => state.cancelSubscriptions(), returnsNormally);
    });

    testWidgets('cancelSubscriptions multiple times is safe', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TestWidget()));

      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      final controller = StreamController<int>.broadcast();

      state.listenTo(controller.stream, (data) {});

      state.cancelSubscriptions();
      state.cancelSubscriptions();

      expect(() => state.cancelSubscriptions(), returnsNormally);
      await controller.close();
    });
  });
}
