// Author: Birju Vachhani
// Created Date: September 21, 2025

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

class TestPage extends StatelessWidget {
  final String title;
  const TestPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title Content'),
      ),
    );
  }
}

void main() {
  group('RouteFS extension tests', () {
    late Widget testApp;
    late BuildContext capturedContext;

    setUp(() {
      testApp = MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              capturedContext = context;
              return const Center(
                child: Text('Home Page'),
              );
            },
          ),
        ),
      );
    });

    group('push method', () {
      testWidgets('pushes route successfully', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final route = MaterialPageRoute(builder: (context) => const TestPage(title: 'Test'));
        final future = route.push(capturedContext);

        await tester.pumpAndSettle();

        expect(find.text('Test'), findsOneWidget);
        expect(find.text('Home Page'), findsNothing);
        expect(future, isA<Future>());
      });

      testWidgets('returns correct Future type', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final route = MaterialPageRoute<String>(builder: (context) => const TestPage(title: 'Test'));
        final future = route.push(capturedContext);

        expect(future, isA<Future<String?>>());
      });
    });

    group('pushReplacement method', () {
      testWidgets('replaces current route successfully', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final route = MaterialPageRoute(builder: (context) => const TestPage(title: 'Replacement'));
        final future = route.pushReplacement(capturedContext);

        await tester.pumpAndSettle();

        expect(find.text('Replacement'), findsOneWidget);
        expect(find.text('Home Page'), findsNothing);
        expect(find.byType(BackButton), findsNothing);
        expect(future, isA<Future>());
      });

      testWidgets('returns correct Future type', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final route = MaterialPageRoute<int>(builder: (context) => const TestPage(title: 'Test'));
        final future = route.pushReplacement(capturedContext);

        expect(future, isA<Future<int?>>());
      });
    });

    group('pushAndRemoveUntil method', () {
      testWidgets('pushes route and removes until predicate', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final route = MaterialPageRoute(builder: (context) => const TestPage(title: 'Final'));
        final future = route.pushAndRemoveUntil(
          capturedContext,
          (route) => route.isFirst,
        );

        await tester.pumpAndSettle();

        expect(find.text('Final'), findsOneWidget);
        expect(find.text('Home Page'), findsNothing);
        expect(future, isA<Future>());
      });

      testWidgets('returns correct Future type', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final route = MaterialPageRoute<bool>(builder: (context) => const TestPage(title: 'Test'));
        final future = route.pushAndRemoveUntil(capturedContext, (route) => route.isFirst);

        expect(future, isA<Future<bool?>>());
      });
    });

    group('integration tests', () {
      testWidgets('all methods return Future types', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final route1 = MaterialPageRoute(builder: (context) => const TestPage(title: 'Test1'));
        final route2 = MaterialPageRoute(builder: (context) => const TestPage(title: 'Test2'));
        final route3 = MaterialPageRoute(builder: (context) => const TestPage(title: 'Test3'));

        expect(route1.push(capturedContext), isA<Future>());
        expect(route2.pushReplacement(capturedContext), isA<Future>());
        expect(route3.pushAndRemoveUntil(capturedContext, (route) => route.isFirst), isA<Future>());
      });

      testWidgets('extension methods work with different route types', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final materialRoute = MaterialPageRoute(builder: (context) => const TestPage(title: 'Material'));
        final pageRoute = PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const TestPage(title: 'Custom'),
        );

        expect(materialRoute.push(capturedContext), isA<Future>());
        expect(pageRoute.push(capturedContext), isA<Future>());
      });
    });

    group('type safety', () {
      testWidgets('preserves generic types correctly', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        // Test String type
        final stringRoute = MaterialPageRoute<String>(builder: (context) => const TestPage(title: 'String'));
        expect(stringRoute.push(capturedContext), isA<Future<String?>>());

        // Create fresh routes for each test to avoid reuse issues
        final stringRoute2 = MaterialPageRoute<String>(builder: (context) => const TestPage(title: 'String2'));
        expect(stringRoute2.pushReplacement(capturedContext), isA<Future<String?>>());

        final stringRoute3 = MaterialPageRoute<String>(builder: (context) => const TestPage(title: 'String3'));
        expect(stringRoute3.pushAndRemoveUntil(capturedContext, (route) => route.isFirst), isA<Future<String?>>());

        // Test other types with fresh routes
        final intRoute = MaterialPageRoute<int>(builder: (context) => const TestPage(title: 'Int'));
        expect(intRoute.push(capturedContext), isA<Future<int?>>());

        final boolRoute = MaterialPageRoute<bool>(builder: (context) => const TestPage(title: 'Bool'));
        expect(boolRoute.pushReplacement(capturedContext), isA<Future<bool?>>());
      });
    });
  });
}