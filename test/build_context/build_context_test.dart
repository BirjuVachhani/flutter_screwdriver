// Author: Birju Vachhani
// Created Date: September 21, 2025

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContextExtension tests', () {
    late Widget testWidget;
    late BuildContext capturedContext;

    setUp(() {
      testWidget = MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
            secondary: Colors.green,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        home: Builder(
          builder: (context) {
            capturedContext = context;
            return const Scaffold(
              body: Text('Test'),
            );
          },
        ),
      );
    });

    group('theme getter', () {
      testWidgets('returns correct ThemeData', (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        final theme = capturedContext.theme;
        final expectedTheme = Theme.of(capturedContext);

        expect(theme, equals(expectedTheme));
        expect(theme, isA<ThemeData>());
        expect(theme.colorScheme.primary, equals(Colors.blue));
      });

      testWidgets('returns same theme as Theme.of(context)',
          (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        final extensionTheme = capturedContext.theme;
        final directTheme = Theme.of(capturedContext);

        expect(extensionTheme, equals(directTheme));
      });
    });

    group('textTheme getter', () {
      testWidgets('returns correct TextTheme', (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        final textTheme = capturedContext.textTheme;
        final expectedTextTheme = Theme.of(capturedContext).textTheme;

        expect(textTheme, equals(expectedTextTheme));
        expect(textTheme, isA<TextTheme>());
        expect(textTheme.bodyLarge?.fontSize, equals(16));
        expect(textTheme.bodyLarge?.color, equals(Colors.black));
      });

      testWidgets('returns same textTheme as Theme.of(context).textTheme',
          (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        final extensionTextTheme = capturedContext.textTheme;
        final directTextTheme = Theme.of(capturedContext).textTheme;

        expect(extensionTextTheme, equals(directTextTheme));
      });
    });

    group('colorScheme getter', () {
      testWidgets('returns correct ColorScheme', (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        final colorScheme = capturedContext.colorScheme;
        final expectedColorScheme = Theme.of(capturedContext).colorScheme;

        expect(colorScheme, equals(expectedColorScheme));
        expect(colorScheme, isA<ColorScheme>());
        expect(colorScheme.primary, equals(Colors.blue));
        expect(colorScheme.secondary, equals(Colors.green));
      });

      testWidgets('returns same colorScheme as Theme.of(context).colorScheme',
          (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        final extensionColorScheme = capturedContext.colorScheme;
        final directColorScheme = Theme.of(capturedContext).colorScheme;

        expect(extensionColorScheme, equals(directColorScheme));
      });
    });

    group('mediaQuery getter', () {
      testWidgets('returns correct MediaQueryData',
          (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        final mediaQuery = capturedContext.mediaQuery;
        final expectedMediaQuery = MediaQuery.of(capturedContext);

        expect(mediaQuery, equals(expectedMediaQuery));
        expect(mediaQuery, isA<MediaQueryData>());
        expect(mediaQuery.size, isA<Size>());
        expect(mediaQuery.devicePixelRatio, isA<double>());
      });

      testWidgets('returns same mediaQuery as MediaQuery.of(context)',
          (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        final extensionMediaQuery = capturedContext.mediaQuery;
        final directMediaQuery = MediaQuery.of(capturedContext);

        expect(extensionMediaQuery, equals(directMediaQuery));
      });
    });

    group('focusScope getter', () {
      testWidgets('returns correct FocusScopeNode',
          (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        final focusScope = capturedContext.focusScope;
        final expectedFocusScope = FocusScope.of(capturedContext);

        expect(focusScope, equals(expectedFocusScope));
        expect(focusScope, isA<FocusScopeNode>());
      });

      testWidgets('returns same focusScope as FocusScope.of(context)',
          (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        final extensionFocusScope = capturedContext.focusScope;
        final directFocusScope = FocusScope.of(capturedContext);

        expect(extensionFocusScope, equals(directFocusScope));
      });
    });

    group('navigator getter', () {
      testWidgets('returns correct NavigatorState',
          (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        final navigator = capturedContext.navigator;
        final expectedNavigator = Navigator.of(capturedContext);

        expect(navigator, equals(expectedNavigator));
        expect(navigator, isA<NavigatorState>());
      });

      testWidgets('returns same navigator as Navigator.of(context)',
          (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        final extensionNavigator = capturedContext.navigator;
        final directNavigator = Navigator.of(capturedContext);

        expect(extensionNavigator, equals(directNavigator));
      });
    });

    group('hideKeyboard method', () {
      testWidgets('calls hideKeyboard without throwing',
          (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        expect(() => capturedContext.hideKeyboard(), returnsNormally);
      });

      testWidgets('hideKeyboard method exists and is callable',
          (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        // Test that the method exists and can be called
        expect(capturedContext.hideKeyboard, isA<Function>());
        capturedContext.hideKeyboard();
      });
    });

    group('integration tests', () {
      testWidgets('all extension methods work together',
          (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        // Test that all methods return expected types
        expect(capturedContext.theme, isA<ThemeData>());
        expect(capturedContext.textTheme, isA<TextTheme>());
        expect(capturedContext.colorScheme, isA<ColorScheme>());
        expect(capturedContext.mediaQuery, isA<MediaQueryData>());
        expect(capturedContext.focusScope, isA<FocusScopeNode>());
        expect(capturedContext.navigator, isA<NavigatorState>());

        // Test that hideKeyboard doesn't throw
        expect(() => capturedContext.hideKeyboard(), returnsNormally);
      });

      testWidgets('extension methods return consistent values',
          (WidgetTester tester) async {
        await tester.pumpWidget(testWidget);

        // Call methods multiple times to ensure consistency
        final theme1 = capturedContext.theme;
        final theme2 = capturedContext.theme;
        expect(theme1, equals(theme2));

        final textTheme1 = capturedContext.textTheme;
        final textTheme2 = capturedContext.textTheme;
        expect(textTheme1, equals(textTheme2));

        final colorScheme1 = capturedContext.colorScheme;
        final colorScheme2 = capturedContext.colorScheme;
        expect(colorScheme1, equals(colorScheme2));

        final mediaQuery1 = capturedContext.mediaQuery;
        final mediaQuery2 = capturedContext.mediaQuery;
        expect(mediaQuery1, equals(mediaQuery2));

        final focusScope1 = capturedContext.focusScope;
        final focusScope2 = capturedContext.focusScope;
        expect(focusScope1, equals(focusScope2));

        final navigator1 = capturedContext.navigator;
        final navigator2 = capturedContext.navigator;
        expect(navigator1, equals(navigator2));
      });
    });

    group('edge cases', () {
      testWidgets('works with custom themes', (WidgetTester tester) async {
        final customTheme = ThemeData(
          colorScheme: const ColorScheme.dark(
            primary: Colors.red,
            secondary: Colors.orange,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
          ),
        );

        final customWidget = MaterialApp(
          theme: customTheme,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        );

        await tester.pumpWidget(customWidget);

        expect(capturedContext.theme.colorScheme.primary, equals(Colors.red));
        expect(capturedContext.textTheme.bodyLarge?.fontSize, equals(18));
        expect(
            capturedContext.textTheme.bodyLarge?.color, equals(Colors.white));
        expect(capturedContext.colorScheme.primary, equals(Colors.red));
        expect(capturedContext.colorScheme.secondary, equals(Colors.orange));
      });

      testWidgets('works with different media query settings',
          (WidgetTester tester) async {
        const testSize = Size(300, 600);

        await tester.binding.setSurfaceSize(testSize);
        await tester.pumpWidget(testWidget);

        final mediaQuery = capturedContext.mediaQuery;
        expect(mediaQuery.size, isA<Size>());
        expect(mediaQuery.devicePixelRatio, isA<double>());

        addTearDown(() => tester.binding.setSurfaceSize(null));
      });
    });
  });
}
