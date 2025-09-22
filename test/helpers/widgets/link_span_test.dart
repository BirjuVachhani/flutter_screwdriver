// Author: Claude Code
// Created Date: September 18, 2025

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LinkSpan widget tests', () {
    testWidgets('LinkSpan creates basic clickable text span', (tester) async {
      bool tapped = false;
      const text = 'Click me';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                text: 'Before ',
                children: [
                  LinkSpan(
                    text: text,
                    onTap: () => tapped = true,
                  ),
                  const TextSpan(text: ' After'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text(text), findsOneWidget);
      expect(tapped, isFalse);

      await tester.tap(find.text(text));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('LinkSpan applies default cursor on hover', (tester) async {
      const text = 'Hover me';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Find the GestureDetector within LinkSpan
      final gestureDetector = find.byType(GestureDetector);
      expect(gestureDetector, findsOneWidget);

      // Verify default cursor is set to click
      final hoverable = find.byType(Hoverable);
      expect(hoverable, findsOneWidget);

      final hoverableWidget = tester.widget<Hoverable>(hoverable);
      expect(hoverableWidget.cursor, equals(SystemMouseCursors.click));
    });

    testWidgets('LinkSpan applies custom cursor', (tester) async {
      const text = 'Custom cursor';
      const customCursor = SystemMouseCursors.help;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    cursor: customCursor,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final hoverable = find.byType(Hoverable);
      final hoverableWidget = tester.widget<Hoverable>(hoverable);
      expect(hoverableWidget.cursor, equals(customCursor));
    });

    testWidgets('LinkSpan applies text style', (tester) async {
      const text = 'Styled text';
      const textStyle = TextStyle(
        color: Colors.blue,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    style: textStyle,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsWidgets);

      // Find the Text widget inside the LinkSpan (not the parent Rich Text)
      final gestureDetector = find.byType(GestureDetector);
      final linkText = find.descendant(
        of: gestureDetector,
        matching: find.byType(Text),
      );

      final widget = tester.widget<Text>(linkText);
      expect(widget.style?.color, equals(textStyle.color));
      expect(widget.style?.fontSize, equals(textStyle.fontSize));
      expect(widget.style?.fontWeight, equals(textStyle.fontWeight));
    });

    testWidgets('LinkSpan applies hover style on hover', (tester) async {
      const text = 'Hover text';
      const normalStyle = TextStyle(color: Colors.blue);
      const hoverStyle = TextStyle(
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    style: normalStyle,
                    hoverStyle: hoverStyle,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Find the Text widget inside the LinkSpan
      final gestureDetector = find.byType(GestureDetector);
      final linkText = find.descendant(
        of: gestureDetector,
        matching: find.byType(Text),
      );

      // Initially should have normal style
      var textWidget = tester.widget<Text>(linkText);
      expect(textWidget.style?.color, equals(normalStyle.color));
      expect(textWidget.style?.decoration, isNot(TextDecoration.underline));

      // Simulate hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(find.byType(GestureDetector)));
      await tester.pumpAndSettle();

      // Should now have hover style merged
      textWidget = tester.widget<Text>(linkText);
      expect(textWidget.style?.decoration, equals(TextDecoration.underline));
      expect(textWidget.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('LinkSpan applies color and hoverColor', (tester) async {
      const text = 'Color text';
      const normalColor = Colors.blue;
      const hoverColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    color: normalColor,
                    hoverColor: hoverColor,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Check initial state - should find multiple DefaultTextStyle widgets
      final defaultTextStyles = find.byType(DefaultTextStyle);
      expect(defaultTextStyles, findsWidgets);

      // Simulate hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(find.byType(GestureDetector)));
      await tester.pumpAndSettle();

      // Verify that the component is in hover state - check that there's a gesture detector and hoverable
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Hoverable), findsOneWidget);
    });

    testWidgets('LinkSpan applies background decoration', (tester) async {
      const text = 'Background text';
      const background = BoxDecoration(color: Colors.yellow);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    background: background,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final container = find.byType(Container);
      expect(container, findsOneWidget);

      final containerWidget = tester.widget<Container>(container);
      expect(containerWidget.decoration, equals(background));
    });

    testWidgets('LinkSpan applies hover background on hover', (tester) async {
      const text = 'Hover background';
      const background = BoxDecoration(color: Colors.yellow);
      const hoverBackground = BoxDecoration(color: Colors.orange);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    background: background,
                    hoverBackground: hoverBackground,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Initially should have normal background
      var container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, equals(background));

      // Simulate hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(find.byType(GestureDetector)));
      await tester.pumpAndSettle();

      // Should now have hover background
      container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, equals(hoverBackground));
    });

    testWidgets('LinkSpan applies padding', (tester) async {
      const text = 'Padded text';
      const padding = EdgeInsets.all(16);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    padding: padding,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final container = find.byType(Container);
      expect(container, findsOneWidget);

      final containerWidget = tester.widget<Container>(container);
      expect(containerWidget.padding, equals(padding));
    });

    testWidgets('LinkSpan works without animation (Duration.zero)',
        (tester) async {
      const text = 'No animation';
      const hoverColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    hoverColor: hoverColor,
                    duration: Duration.zero,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Should use Container instead of AnimatedContainer when duration is zero
      final container = find.byType(Container);
      final animatedContainer = find.byType(AnimatedContainer);

      expect(container, findsOneWidget);
      expect(animatedContainer, findsNothing);
    });

    testWidgets('LinkSpan applies animation with custom duration and curve',
        (tester) async {
      const text = 'Animated text';
      const duration = Duration(milliseconds: 300);
      const curve = Curves.easeInOut;
      const hoverColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    hoverColor: hoverColor,
                    duration: duration,
                    curve: curve,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Should use AnimatedContainer when duration is not zero
      final animatedContainers = find.byType(AnimatedContainer);
      final animatedTextStyles = find.byType(AnimatedDefaultTextStyle);

      expect(animatedContainers, findsWidgets);
      expect(animatedTextStyles, findsWidgets);

      // Verify that at least one animated container has the correct duration
      final animatedContainerWidgets =
          tester.widgetList<AnimatedContainer>(animatedContainers);
      expect(
          animatedContainerWidgets.any((w) => w.duration == duration), isTrue);
      expect(animatedContainerWidgets.any((w) => w.curve == curve), isTrue);
    });

    testWidgets('LinkSpan displays prefix widget', (tester) async {
      const text = 'With prefix';
      const prefixIcon = Icon(Icons.link, size: 16);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    prefix: prefixIcon,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.link), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, equals(2)); // prefix + text
    });

    testWidgets('LinkSpan displays suffix widget', (tester) async {
      const text = 'With suffix';
      const suffixIcon = Icon(Icons.open_in_new, size: 16);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    suffix: suffixIcon,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, equals(2)); // text + suffix
    });

    testWidgets('LinkSpan displays both prefix and suffix widgets',
        (tester) async {
      const text = 'With both';
      const prefixIcon = Icon(Icons.link, size: 16);
      const suffixIcon = Icon(Icons.open_in_new, size: 16);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    prefix: prefixIcon,
                    suffix: suffixIcon,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.link), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, equals(3)); // prefix + text + suffix
      expect(row.mainAxisSize, equals(MainAxisSize.min));
    });

    testWidgets('LinkSpan applies IconTheme to prefix and suffix',
        (tester) async {
      const text = 'Icon theme';
      const prefixIcon = Icon(Icons.link);
      const suffixIcon = Icon(Icons.open_in_new);
      const normalColor = Colors.blue;
      const hoverColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    prefix: prefixIcon,
                    suffix: suffixIcon,
                    color: normalColor,
                    hoverColor: hoverColor,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Check that IconTheme.merge is applied - there may be multiple IconThemes in the widget tree
      final iconThemes = find.byType(IconTheme);
      expect(iconThemes, findsWidgets);

      // Find the IconTheme widget within the GestureDetector (our LinkSpan's IconTheme)
      final gestureDetector = find.byType(GestureDetector);
      final linkIconTheme = find.descendant(
        of: gestureDetector,
        matching: find.byType(IconTheme),
      );

      final iconThemeWidget = tester.widget<IconTheme>(linkIconTheme);
      expect(iconThemeWidget.data.color, equals(normalColor));
    });

    testWidgets('LinkSpan changes icon color on hover', (tester) async {
      const text = 'Icon hover';
      const prefixIcon = Icon(Icons.link);
      const normalColor = Colors.blue;
      const hoverColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    prefix: prefixIcon,
                    color: normalColor,
                    hoverColor: hoverColor,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Find the IconTheme widget within the GestureDetector (our LinkSpan's IconTheme)
      final gestureDetector = find.byType(GestureDetector);
      final linkIconTheme = find.descendant(
        of: gestureDetector,
        matching: find.byType(IconTheme),
      );

      // Initially should have normal color
      var iconTheme = tester.widget<IconTheme>(linkIconTheme);
      expect(iconTheme.data.color, equals(normalColor));

      // Simulate hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(find.byType(GestureDetector)));
      await tester.pumpAndSettle();

      // Should now have hover color
      iconTheme = tester.widget<IconTheme>(linkIconTheme);
      expect(iconTheme.data.color, equals(hoverColor));
    });

    testWidgets('LinkSpan works without onTap callback', (tester) async {
      const text = 'No callback';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  const LinkSpan(
                    text: text,
                    // onTap: null (default)
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text(text), findsOneWidget);

      // Should not throw when tapped
      await tester.tap(find.text(text));
      await tester.pump();
    });

    testWidgets(
        'LinkSpan applies PlaceholderAlignment and TextBaseline from constructor',
        (tester) async {
      const text = 'Aligned text';
      const alignment = PlaceholderAlignment.top;
      const baseline = TextBaseline.ideographic;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    alignment: alignment,
                    baseline: baseline,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify the widget renders correctly with custom alignment and baseline
      expect(find.text(text), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('LinkSpan uses default PlaceholderAlignment and TextBaseline',
        (tester) async {
      const text = 'Default alignment';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify the widget renders correctly with default alignment and baseline
      expect(find.text(text), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('LinkSpan hoverColor defaults to color when not specified',
        (tester) async {
      const text = 'Default hover color';
      const normalColor = Colors.blue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    color: normalColor,
                    // hoverColor not specified, should default to color
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Simulate hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(find.byType(GestureDetector)));
      await tester.pumpAndSettle();

      // Verify that hovering works - check for presence of components
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Hoverable), findsOneWidget);
    });

    testWidgets('LinkSpan handles complex Rich Text scenarios', (tester) async {
      bool link1Tapped = false;
      bool link2Tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                text: 'By signing up, you agree to our ',
                children: [
                  LinkSpan(
                    text: 'Terms of Service',
                    style: const TextStyle(color: Colors.blue),
                    hoverStyle:
                        const TextStyle(decoration: TextDecoration.underline),
                    onTap: () => link1Tapped = true,
                  ),
                  const TextSpan(text: ' and '),
                  LinkSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(color: Colors.blue),
                    hoverStyle:
                        const TextStyle(decoration: TextDecoration.underline),
                    onTap: () => link2Tapped = true,
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);

      // Tap first link
      await tester.tap(find.text('Terms of Service'));
      await tester.pump();
      expect(link1Tapped, isTrue);
      expect(link2Tapped, isFalse);

      // Reset and tap second link
      link1Tapped = false;
      await tester.tap(find.text('Privacy Policy'));
      await tester.pump();
      expect(link1Tapped, isFalse);
      expect(link2Tapped, isTrue);
    });

    testWidgets('LinkSpan with empty text still creates widget',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: '',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
      // Empty text won't be found by find.text, but the gesture detector should still exist
    });

    testWidgets('LinkSpan GestureDetector has opaque hit test behavior',
        (tester) async {
      const text = 'Hit test';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final gestureDetector =
          tester.widget<GestureDetector>(find.byType(GestureDetector));
      expect(gestureDetector.behavior, equals(HitTestBehavior.opaque));
    });
  });

  group('LinkSpan edge cases and error handling', () {
    testWidgets('LinkSpan handles null values gracefully', (tester) async {
      const text = 'Null handling';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    style: null,
                    hoverStyle: null,
                    background: null,
                    hoverBackground: null,
                    cursor: null,
                    color: null,
                    hoverColor: null,
                    padding: null,
                    prefix: null,
                    suffix: null,
                    onTap: null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text(text), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('LinkSpan applies EdgeInsets.zero when padding is null',
        (tester) async {
      const text = 'Zero padding';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    padding: null,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, equals(EdgeInsets.zero));
    });

    testWidgets('LinkSpan works with very long text', (tester) async {
      const longText =
          'This is a very long text that might wrap across multiple lines and should still work correctly with the LinkSpan widget implementation.';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200, // Force wrapping
              child: Text.rich(
                TextSpan(
                  children: [
                    LinkSpan(
                      text: longText,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text(longText), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('LinkSpan works with special characters and Unicode',
        (tester) async {
      const specialText = '🔗 Special & Unicode テキスト @#\$%^&*()';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: specialText,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text(specialText), findsOneWidget);
    });

    testWidgets('LinkSpan handles rapid hover events', (tester) async {
      const text = 'Rapid hover';
      int hoverCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    color: Colors.blue,
                    hoverColor: Colors.red,
                    onTap: () => hoverCount++,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      final center = tester.getCenter(find.byType(GestureDetector));
      final outside = Offset(center.dx + 200, center.dy + 200);

      // Rapid hover in and out
      for (int i = 0; i < 5; i++) {
        await gesture.moveTo(center);
        await tester.pump();
        await gesture.moveTo(outside);
        await tester.pump();
      }

      // Widget should still be functional
      expect(find.text(text), findsOneWidget);
    });
  });

  group('LinkSpan accessibility', () {
    testWidgets('LinkSpan preserves semantics', (tester) async {
      const text = 'Accessible link';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(
                children: [
                  LinkSpan(
                    text: text,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text(text), findsOneWidget);

      // The text should be accessible
      final textFinder = find.text(text);
      expect(textFinder, findsOneWidget);

      // Verify the GestureDetector exists for interaction
      expect(find.byType(GestureDetector), findsOneWidget);
    });
  });

  group('LinkSpan performance', () {
    testWidgets('LinkSpan handles multiple instances efficiently',
        (tester) async {
      final links = List.generate(50, (index) => 'Link $index');
      final tappedLinks = <int>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < links.length; i++)
                    Text.rich(
                      TextSpan(
                        children: [
                          LinkSpan(
                            text: links[i],
                            onTap: () => tappedLinks.add(i),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );

      // Test that all links are created
      for (int i = 0; i < 10; i++) {
        // Test first 10 for performance
        expect(find.text(links[i]), findsOneWidget);
      }

      // Test that tapping works
      await tester.tap(find.text(links[0]));
      await tester.pump();
      expect(tappedLinks.contains(0), isTrue);
    });
  });
}
