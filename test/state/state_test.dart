// Author: Birju Vachhani
// Created Date: September 21, 2025

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return const Text('Test Widget');
  }
}

void main() {
  group('StateFS extension tests', () {
    late Widget testApp;
    late _TestWidgetState capturedState;

    setUp(() {
      testApp = MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
            secondary: Colors.green,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return TestWidget();
            },
          ),
        ),
      );
    });

    group('theme getter', () {
      testWidgets('returns correct ThemeData', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: Colors.blue,
                secondary: Colors.green,
              ),
            ),
            home: StatefulBuilder(
              builder: (context, setState) {
                return TestWidget();
              },
            ),
          ),
        );

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final theme = state.theme;
        final expectedTheme = Theme.of(state.context);

        expect(theme, equals(expectedTheme));
        expect(theme, isA<ThemeData>());
        expect(theme.colorScheme.primary, equals(Colors.blue));
      });

      testWidgets('returns same theme as Theme.of(context)', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final extensionTheme = state.theme;
        final directTheme = Theme.of(state.context);

        expect(extensionTheme, equals(directTheme));
      });
    });

    group('colorScheme getter', () {
      testWidgets('returns correct ColorScheme', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final colorScheme = state.colorScheme;
        final expectedColorScheme = Theme.of(state.context).colorScheme;

        expect(colorScheme, equals(expectedColorScheme));
        expect(colorScheme, isA<ColorScheme>());
        expect(colorScheme.primary, equals(Colors.blue));
        expect(colorScheme.secondary, equals(Colors.green));
      });

      testWidgets('returns same colorScheme as Theme.of(context).colorScheme', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final extensionColorScheme = state.colorScheme;
        final directColorScheme = Theme.of(state.context).colorScheme;

        expect(extensionColorScheme, equals(directColorScheme));
      });
    });

    group('textTheme getter', () {
      testWidgets('returns correct TextTheme', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final textTheme = state.textTheme;
        final expectedTextTheme = Theme.of(state.context).textTheme;

        expect(textTheme, equals(expectedTextTheme));
        expect(textTheme, isA<TextTheme>());
        expect(textTheme.bodyLarge?.fontSize, equals(16));
        expect(textTheme.bodyLarge?.color, equals(Colors.black));
      });

      testWidgets('returns same textTheme as Theme.of(context).textTheme', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final extensionTextTheme = state.textTheme;
        final directTextTheme = Theme.of(state.context).textTheme;

        expect(extensionTextTheme, equals(directTextTheme));
      });
    });

    group('mediaQuery getter', () {
      testWidgets('returns correct MediaQueryData', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final mediaQuery = state.mediaQuery;
        final expectedMediaQuery = MediaQuery.of(state.context);

        expect(mediaQuery, equals(expectedMediaQuery));
        expect(mediaQuery, isA<MediaQueryData>());
        expect(mediaQuery.size, isA<Size>());
        expect(mediaQuery.devicePixelRatio, isA<double>());
      });

      testWidgets('returns same mediaQuery as MediaQuery.of(context)', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final extensionMediaQuery = state.mediaQuery;
        final directMediaQuery = MediaQuery.of(state.context);

        expect(extensionMediaQuery, equals(directMediaQuery));
      });
    });

    group('focusScope getter', () {
      testWidgets('returns correct FocusScopeNode', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final focusScope = state.focusScope;
        final expectedFocusScope = FocusScope.of(state.context);

        expect(focusScope, equals(expectedFocusScope));
        expect(focusScope, isA<FocusScopeNode>());
      });

      testWidgets('returns same focusScope as FocusScope.of(context)', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final extensionFocusScope = state.focusScope;
        final directFocusScope = FocusScope.of(state.context);

        expect(extensionFocusScope, equals(directFocusScope));
      });
    });

    group('navigator getter', () {
      testWidgets('returns correct NavigatorState', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final navigator = state.navigator;
        final expectedNavigator = Navigator.of(state.context);

        expect(navigator, equals(expectedNavigator));
        expect(navigator, isA<NavigatorState>());
      });

      testWidgets('returns same navigator as Navigator.of(context)', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final extensionNavigator = state.navigator;
        final directNavigator = Navigator.of(state.context);

        expect(extensionNavigator, equals(directNavigator));
      });
    });

    group('hideKeyboard method', () {
      testWidgets('calls hideKeyboard without throwing', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));

        expect(() => state.hideKeyboard(), returnsNormally);
      });

      testWidgets('hideKeyboard method exists and is callable', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));

        expect(state.hideKeyboard, isA<Function>());
        state.hideKeyboard();
      });
    });

    group('integration tests', () {
      testWidgets('all extension methods work together', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));

        // Test that all methods return expected types
        expect(state.theme, isA<ThemeData>());
        expect(state.colorScheme, isA<ColorScheme>());
        expect(state.textTheme, isA<TextTheme>());
        expect(state.mediaQuery, isA<MediaQueryData>());
        expect(state.focusScope, isA<FocusScopeNode>());
        expect(state.navigator, isA<NavigatorState>());

        // Test that hideKeyboard doesn't throw
        expect(() => state.hideKeyboard(), returnsNormally);
      });

      testWidgets('extension methods return consistent values', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));

        // Call methods multiple times to ensure consistency
        final theme1 = state.theme;
        final theme2 = state.theme;
        expect(theme1, equals(theme2));

        final colorScheme1 = state.colorScheme;
        final colorScheme2 = state.colorScheme;
        expect(colorScheme1, equals(colorScheme2));

        final textTheme1 = state.textTheme;
        final textTheme2 = state.textTheme;
        expect(textTheme1, equals(textTheme2));

        final mediaQuery1 = state.mediaQuery;
        final mediaQuery2 = state.mediaQuery;
        expect(mediaQuery1, equals(mediaQuery2));

        final focusScope1 = state.focusScope;
        final focusScope2 = state.focusScope;
        expect(focusScope1, equals(focusScope2));

        final navigator1 = state.navigator;
        final navigator2 = state.navigator;
        expect(navigator1, equals(navigator2));
      });

      testWidgets('works with different widget hierarchies', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.dark(
                primary: Colors.red,
                secondary: Colors.orange,
              ),
            ),
            home: Scaffold(
              appBar: AppBar(title: const Text('Test')),
              body: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: TestWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));

        expect(state.theme.colorScheme.primary, equals(Colors.red));
        expect(state.colorScheme.secondary, equals(Colors.orange));
        expect(state.mediaQuery.size, isA<Size>());
        expect(state.focusScope, isA<FocusScopeNode>());
        expect(state.navigator, isA<NavigatorState>());
      });
    });

    group('edge cases and invariants', () {
      testWidgets('extension methods work with custom themes', (WidgetTester tester) async {
        final customTheme = ThemeData(
          colorScheme: const ColorScheme.dark(
            primary: Colors.purple,
            secondary: Colors.pink,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: customTheme,
            home: Scaffold(
              body: TestWidget(),
            ),
          ),
        );

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));

        expect(state.theme.colorScheme.primary, equals(Colors.purple));
        expect(state.colorScheme.secondary, equals(Colors.pink));
        expect(state.textTheme.bodyLarge?.fontSize, equals(18));
        expect(state.textTheme.bodyLarge?.color, equals(Colors.white));
      });

      testWidgets('methods are deterministic across multiple calls', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));

        // Multiple calls should return same instances
        expect(state.theme, same(state.theme));
        expect(state.colorScheme, same(state.colorScheme));
        expect(state.textTheme, same(state.textTheme));
        expect(state.mediaQuery, same(state.mediaQuery));
        expect(state.focusScope, same(state.focusScope));
        expect(state.navigator, same(state.navigator));
      });

      testWidgets('works with nested widgets', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: Colors.blue,
              ),
            ),
            home: Scaffold(
              body: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('Header'),
                      Expanded(
                        child: ListView(
                          children: [
                            TestWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));

        expect(state.theme.colorScheme.primary, equals(Colors.blue));
        expect(state.colorScheme, isA<ColorScheme>());
        expect(state.textTheme, isA<TextTheme>());
        expect(state.mediaQuery, isA<MediaQueryData>());
        expect(state.focusScope, isA<FocusScopeNode>());
        expect(state.navigator, isA<NavigatorState>());
      });
    });

    group('comparison with BuildContext extension', () {
      testWidgets('State extension returns same values as BuildContext extension', (WidgetTester tester) async {
        late BuildContext capturedContext;
        late _TestWidgetState capturedState;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: Colors.blue,
                secondary: Colors.green,
              ),
            ),
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  capturedContext = context;
                  return TestWidget();
                },
              ),
            ),
          ),
        );

        capturedState = tester.state<_TestWidgetState>(find.byType(TestWidget));

        // Compare extension results
        expect(capturedState.theme, equals(capturedContext.theme));
        expect(capturedState.colorScheme, equals(capturedContext.colorScheme));
        expect(capturedState.textTheme, equals(capturedContext.textTheme));
        expect(capturedState.mediaQuery, equals(capturedContext.mediaQuery));
        expect(capturedState.focusScope, equals(capturedContext.focusScope));
        expect(capturedState.navigator, equals(capturedContext.navigator));
      });
    });

    group('type safety', () {
      testWidgets('all getters return expected types', (WidgetTester tester) async {
        await tester.pumpWidget(testApp);

        final state = tester.state<_TestWidgetState>(find.byType(TestWidget));

        expect(state.theme, isA<ThemeData>());
        expect(state.colorScheme, isA<ColorScheme>());
        expect(state.textTheme, isA<TextTheme>());
        expect(state.mediaQuery, isA<MediaQueryData>());
        expect(state.focusScope, isA<FocusScopeNode>());
        expect(state.navigator, isA<NavigatorState>());
      });

      testWidgets('extension works with different StatefulWidget types', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TestWidget(),
                  const TextField(), // StatefulWidget
                  ElevatedButton(onPressed: () {}, child: const Text('Button')),
                ],
              ),
            ),
          ),
        );

        final testState = tester.state<_TestWidgetState>(find.byType(TestWidget));
        final textFieldState = tester.state(find.byType(TextField));

        // Both should have access to extension methods
        expect(testState.theme, isA<ThemeData>());
        expect(textFieldState.theme, isA<ThemeData>());
        expect(testState.theme, equals(textFieldState.theme));
      });
    });
  });
}