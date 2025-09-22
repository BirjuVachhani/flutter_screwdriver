// Author: Birju Vachhani
// Created Date: October 01, 2020
// Enhanced Date: September 21, 2025

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextEditingControllerFS extension tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    group('isBlank getter', () {
      test('returns true for empty text', () {
        expect(controller.isBlank, isTrue);
      });

      test('returns true for whitespace only text', () {
        controller.text = '     ';
        expect(controller.isBlank, isTrue);
      });

      test('returns true for mixed whitespace characters', () {
        controller.text = ' \t\n\r ';
        expect(controller.isBlank, isTrue);
      });

      test('returns false for non-empty text', () {
        controller.text = 'Hello';
        expect(controller.isBlank, isFalse);
      });

      test('returns false for text with leading/trailing spaces', () {
        controller.text = '  Hello  ';
        expect(controller.isBlank, isFalse);
      });
    });

    group('isNotBlank getter', () {
      test('returns false for empty text', () {
        expect(controller.isNotBlank, isFalse);
      });

      test('returns false for whitespace only text', () {
        controller.text = '     ';
        expect(controller.isNotBlank, isFalse);
      });

      test('returns true for non-empty text', () {
        controller.text = 'Hello';
        expect(controller.isNotBlank, isTrue);
      });

      test('is inverse of isBlank', () {
        const testTexts = ['', '   ', 'Hello', ' World ', '\t\n'];
        for (final text in testTexts) {
          controller.text = text;
          expect(controller.isNotBlank, equals(!controller.isBlank));
        }
      });
    });

    group('trimmed getter', () {
      test('returns empty string for empty text', () {
        expect(controller.trimmed, equals(''));
      });

      test('returns empty string for whitespace only text', () {
        controller.text = '     ';
        expect(controller.trimmed, equals(''));
      });

      test('trims leading and trailing whitespace', () {
        controller.text = '  Hello World  ';
        expect(controller.trimmed, equals('Hello World'));
      });

      test('preserves internal whitespace', () {
        controller.text = '  Hello   World  ';
        expect(controller.trimmed, equals('Hello   World'));
      });

      test('handles various whitespace characters', () {
        controller.text = '\t\n  Hello  \r\n';
        expect(controller.trimmed, equals('Hello'));
      });
    });

    group('onChanged method', () {
      test('calls callback when text changes', () {
        var callCount = 0;
        String? receivedText;

        final disposable = controller.onChanged((text) {
          callCount++;
          receivedText = text;
        });

        controller.text = 'Hello';
        expect(callCount, equals(1));
        expect(receivedText, equals('Hello'));

        disposable();
      });

      test('does not call callback when text does not change', () {
        var callCount = 0;
        controller.text = 'Initial';

        final disposable = controller.onChanged((text) {
          callCount++;
        });

        // Set same text
        controller.text = 'Initial';
        expect(callCount, equals(0));

        // Trigger other changes (like selection)
        controller.selection = const TextSelection.collapsed(offset: 2);
        expect(callCount, equals(0));

        disposable();
      });

      test('calls callback multiple times for different text changes', () {
        var callCount = 0;
        final receivedTexts = <String>[];

        final disposable = controller.onChanged((text) {
          callCount++;
          receivedTexts.add(text);
        });

        controller.text = 'Hello';
        controller.text = 'Hello World';
        controller.text = '';

        expect(callCount, equals(3));
        expect(receivedTexts, equals(['Hello', 'Hello World', '']));

        disposable();
      });

      test('disposable function removes listener', () {
        var callCount = 0;

        final disposable = controller.onChanged((text) {
          callCount++;
        });

        controller.text = 'Hello';
        expect(callCount, equals(1));

        disposable();

        controller.text = 'World';
        expect(callCount, equals(1)); // Should not increase
      });

      test('multiple listeners work independently', () {
        var callCount1 = 0;
        var callCount2 = 0;

        final disposable1 = controller.onChanged((text) => callCount1++);
        final disposable2 = controller.onChanged((text) => callCount2++);

        controller.text = 'Hello';
        expect(callCount1, equals(1));
        expect(callCount2, equals(1));

        disposable1();
        controller.text = 'World';
        expect(callCount1, equals(1));
        expect(callCount2, equals(2));

        disposable2();
      });
    });

    group('onSelectionChanged method', () {
      test('calls callback when selection changes', () {
        var callCount = 0;
        TextSelection? receivedSelection;

        final disposable = controller.onSelectionChanged((selection) {
          callCount++;
          receivedSelection = selection;
        });

        controller.text = 'Hello';
        controller.selection = const TextSelection.collapsed(offset: 2);

        expect(callCount, equals(1));
        expect(receivedSelection, equals(const TextSelection.collapsed(offset: 2)));

        disposable();
      });

      test('does not call callback when selection does not change', () {
        var callCount = 0;

        final disposable = controller.onSelectionChanged((selection) {
          callCount++;
        });

        // Set text first to establish a baseline
        controller.text = 'Hello';

        // Set selection
        controller.selection = const TextSelection.collapsed(offset: 2);
        expect(callCount, equals(1));

        // Set same selection again
        controller.selection = const TextSelection.collapsed(offset: 2);
        expect(callCount, equals(1)); // Should not increase

        disposable();
      });

      test('disposable function removes listener', () {
        var callCount = 0;

        final disposable = controller.onSelectionChanged((selection) {
          callCount++;
        });

        controller.text = 'Hello';
        controller.selection = const TextSelection.collapsed(offset: 2);
        expect(callCount, equals(1));

        disposable();

        controller.selection = const TextSelection.collapsed(offset: 3);
        expect(callCount, equals(1)); // Should not increase
      });
    });

    group('textChanges stream', () {
      test('emits text changes', () async {
        final stream = controller.textChanges();
        final events = <String>[];

        final subscription = stream.listen(events.add);

        controller.text = 'Hello';
        controller.text = 'Hello World';

        await Future.delayed(const Duration(milliseconds: 10));

        expect(events, equals(['Hello', 'Hello World']));

        await subscription.cancel();
      });

      test('does not emit when text does not change', () async {
        final stream = controller.textChanges();
        final events = <String>[];

        final subscription = stream.listen(events.add);

        controller.text = 'Hello';
        controller.text = 'Hello'; // Same text
        controller.selection = const TextSelection.collapsed(offset: 2);

        await Future.delayed(const Duration(milliseconds: 10));

        expect(events, equals(['Hello']));

        await subscription.cancel();
      });

      test('creates new stream on each call', () {
        final stream1 = controller.textChanges();
        final stream2 = controller.textChanges();

        expect(stream1, isNot(same(stream2)));
      });
    });

    group('selectionChanges stream', () {
      test('emits selection changes', () async {
        final stream = controller.selectionChanges();
        final events = <TextSelection>[];

        final subscription = stream.listen(events.add);

        controller.text = 'Hello';
        controller.selection = const TextSelection.collapsed(offset: 2);
        controller.selection = const TextSelection(baseOffset: 0, extentOffset: 5);

        await Future.delayed(const Duration(milliseconds: 10));

        expect(events.length, equals(2));
        expect(events[0], equals(const TextSelection.collapsed(offset: 2)));
        expect(events[1], equals(const TextSelection(baseOffset: 0, extentOffset: 5)));

        await subscription.cancel();
      });

      test('creates new stream on each call', () {
        final stream1 = controller.selectionChanges();
        final stream2 = controller.selectionChanges();

        expect(stream1, isNot(same(stream2)));
      });
    });

    group('whenBlank method', () {
      test('calls callback when text becomes blank', () {
        var callCount = 0;
        controller.text = 'Hello';

        controller.whenBlank(() {
          callCount++;
        });

        controller.text = '';
        expect(callCount, equals(1));

        controller.text = '   ';
        expect(callCount, equals(2));
      });

      test('does not call callback when text is not blank', () {
        var callCount = 0;

        controller.whenBlank(() {
          callCount++;
        });

        controller.text = 'Hello';
        controller.text = 'World';
        controller.text = ' Content ';

        expect(callCount, equals(0));
      });
    });

    group('integration tests', () {
      test('all extension methods work together', () {
        var changeCount = 0;
        var selectionCount = 0;
        var blankCount = 0;

        final textDisposable = controller.onChanged((text) => changeCount++);
        final selectionDisposable = controller.onSelectionChanged((selection) => selectionCount++);
        controller.whenBlank(() => blankCount++);

        // Initial state
        expect(controller.isBlank, isTrue);
        expect(controller.isNotBlank, isFalse);
        expect(controller.trimmed, equals(''));

        // Add text
        controller.text = '  Hello  ';
        expect(changeCount, equals(1));
        expect(controller.isBlank, isFalse);
        expect(controller.isNotBlank, isTrue);
        expect(controller.trimmed, equals('Hello'));

        // Change selection
        controller.selection = const TextSelection.collapsed(offset: 2);
        expect(selectionCount, equals(1));
        expect(changeCount, equals(1)); // Should not increase

        // Make blank
        controller.text = '   ';
        expect(changeCount, equals(2));
        expect(blankCount, equals(1));
        expect(controller.isBlank, isTrue);

        textDisposable();
        selectionDisposable();
      });

      test('disposables work correctly', () {
        var textCount = 0;
        var selectionCount = 0;

        final textDisposable = controller.onChanged((text) => textCount++);
        final selectionDisposable = controller.onSelectionChanged((selection) => selectionCount++);

        controller.text = 'Hello';
        controller.selection = const TextSelection.collapsed(offset: 2);

        expect(textCount, equals(1));
        expect(selectionCount, equals(1));

        // Dispose listeners
        textDisposable();
        selectionDisposable();

        controller.text = 'World';
        controller.selection = const TextSelection.collapsed(offset: 3);

        // Counts should not increase
        expect(textCount, equals(1));
        expect(selectionCount, equals(1));
      });
    });

    group('edge cases', () {
      test('handles unicode characters', () {
        controller.text = '  🚀 Hello 世界  ';
        expect(controller.trimmed, equals('🚀 Hello 世界'));
        expect(controller.isNotBlank, isTrue);
      });

      test('handles very long text', () {
        final longText = 'a' * 10000;
        controller.text = longText;
        expect(controller.trimmed, equals(longText));
        expect(controller.isNotBlank, isTrue);
      });

      test('handles rapid text changes', () {
        var count = 0;
        final disposable = controller.onChanged((text) => count++);

        for (int i = 0; i < 100; i++) {
          controller.text = 'Text $i';
        }

        expect(count, equals(100));
        disposable();
      });
    });

    group('type safety', () {
      test('returns correct types', () {
        expect(controller.isBlank, isA<bool>());
        expect(controller.isNotBlank, isA<bool>());
        expect(controller.trimmed, isA<String>());
        expect(controller.textChanges(), isA<Stream<String>>());
        expect(controller.selectionChanges(), isA<Stream<TextSelection>>());
        expect(controller.onChanged((text) {}), isA<Disposable>());
        expect(controller.onSelectionChanged((selection) {}), isA<Disposable>());
      });
    });
  });
}
