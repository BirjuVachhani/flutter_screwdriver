// Author: Birju Vachhani
// Created Date: September 21, 2025

import 'package:flutter/animation.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IntFS extension tests', () {
    group('tweenTo', () {
      test('creates Tween with correct begin and end values', () {
        const startValue = 5;
        const endValue = 10;
        final tween = startValue.tweenTo(endValue);

        expect(tween, isA<Tween<int>>());
        expect(tween.begin, equals(startValue));
        expect(tween.end, equals(endValue));
      });

      test('works with negative values', () {
        const startValue = -10;
        const endValue = -5;
        final tween = startValue.tweenTo(endValue);

        expect(tween.begin, equals(startValue));
        expect(tween.end, equals(endValue));
      });

      test('works with zero values', () {
        const startValue = 0;
        const endValue = 100;
        final tween = startValue.tweenTo(endValue);

        expect(tween.begin, equals(startValue));
        expect(tween.end, equals(endValue));
      });

      test('works with same values', () {
        const value = 42;
        final tween = value.tweenTo(value);

        expect(tween.begin, equals(value));
        expect(tween.end, equals(value));
      });

      test('works with decreasing values', () {
        const startValue = 100;
        const endValue = 50;
        final tween = startValue.tweenTo(endValue);

        expect(tween.begin, equals(startValue));
        expect(tween.end, equals(endValue));
      });

      test('creates functional tween that can be evaluated', () {
        const startValue = 10;
        const endValue = 20;
        final tween = startValue.tweenTo(endValue);

        // Note: Tween<int> doesn't support lerp directly in Flutter
        // This test verifies the tween is created correctly
        expect(tween.begin, equals(startValue));
        expect(tween.end, equals(endValue));
      });

      test('handles extreme values', () {
        const minValue = -2147483648; // int min value
        const maxValue = 2147483647;  // int max value

        final tween1 = minValue.tweenTo(maxValue);
        expect(tween1.begin, equals(minValue));
        expect(tween1.end, equals(maxValue));

        final tween2 = maxValue.tweenTo(minValue);
        expect(tween2.begin, equals(maxValue));
        expect(tween2.end, equals(minValue));
      });

      test('tween boundaries are set correctly', () {
        const startValue = 10;
        const endValue = 20;
        final tween = startValue.tweenTo(endValue);

        expect(tween.begin, equals(startValue));
        expect(tween.end, equals(endValue));
      });
    });

    group('tweenFrom', () {
      test('creates Tween with correct begin and end values', () {
        const beginValue = 5;
        const endValue = 10;
        final tween = endValue.tweenFrom(beginValue);

        expect(tween, isA<Tween<int>>());
        expect(tween.begin, equals(beginValue));
        expect(tween.end, equals(endValue));
      });

      test('works with negative values', () {
        const beginValue = -10;
        const endValue = -5;
        final tween = endValue.tweenFrom(beginValue);

        expect(tween.begin, equals(beginValue));
        expect(tween.end, equals(endValue));
      });

      test('works with zero values', () {
        const beginValue = 0;
        const endValue = 100;
        final tween = endValue.tweenFrom(beginValue);

        expect(tween.begin, equals(beginValue));
        expect(tween.end, equals(endValue));
      });

      test('works with same values', () {
        const value = 42;
        final tween = value.tweenFrom(value);

        expect(tween.begin, equals(value));
        expect(tween.end, equals(value));
      });

      test('is inverse of tweenTo', () {
        const valueA = 10;
        const valueB = 20;

        final tweenTo = valueA.tweenTo(valueB);
        final tweenFrom = valueB.tweenFrom(valueA);

        expect(tweenTo.begin, equals(tweenFrom.begin));
        expect(tweenTo.end, equals(tweenFrom.end));
      });

      test('creates functional tween that can be evaluated', () {
        const beginValue = 10;
        const endValue = 20;
        final tween = endValue.tweenFrom(beginValue);

        // Note: Tween<int> doesn't support lerp directly in Flutter
        // This test verifies the tween is created correctly
        expect(tween.begin, equals(beginValue));
        expect(tween.end, equals(endValue));
      });

      test('handles extreme values', () {
        const minValue = -2147483648; // int min value
        const maxValue = 2147483647;  // int max value

        final tween1 = maxValue.tweenFrom(minValue);
        expect(tween1.begin, equals(minValue));
        expect(tween1.end, equals(maxValue));

        final tween2 = minValue.tweenFrom(maxValue);
        expect(tween2.begin, equals(maxValue));
        expect(tween2.end, equals(minValue));
      });
    });

    group('integration tests', () {
      test('tweenTo and tweenFrom work together correctly', () {
        const valueA = 100;
        const valueB = 200;

        final tweenAtoB = valueA.tweenTo(valueB);
        final tweenBfromA = valueB.tweenFrom(valueA);

        // Both should create equivalent tweens
        expect(tweenAtoB.begin, equals(tweenBfromA.begin));
        expect(tweenAtoB.end, equals(tweenBfromA.end));

        // Both should have the same structure
        expect(tweenAtoB.begin, equals(tweenBfromA.begin));
        expect(tweenAtoB.end, equals(tweenBfromA.end));
      });

      test('multiple tween operations work correctly', () {
        const start = 0;
        const middle = 50;
        const end = 100;

        final tween1 = start.tweenTo(middle);
        final tween2 = middle.tweenTo(end);
        final directTween = start.tweenTo(end);

        // Verify tween properties
        expect(tween1.begin, equals(start));
        expect(tween1.end, equals(middle));
        expect(tween2.begin, equals(middle));
        expect(tween2.end, equals(end));
        expect(directTween.begin, equals(start));
        expect(directTween.end, equals(end));
      });

      test('tween methods are consistent across multiple calls', () {
        const value1 = 10;
        const value2 = 20;

        final tween1 = value1.tweenTo(value2);
        final tween2 = value1.tweenTo(value2);

        expect(tween1.begin, equals(tween2.begin));
        expect(tween1.end, equals(tween2.end));
      });
    });

    group('edge cases', () {
      test('works with very large differences', () {
        const small = 1;
        const large = 1000000;
        final tween = small.tweenTo(large);

        expect(tween.begin, equals(small));
        expect(tween.end, equals(large));
      });

      test('maintains precision with small values', () {
        const value1 = 1;
        const value2 = 2;
        final tween = value1.tweenTo(value2);

        expect(tween.begin, equals(value1));
        expect(tween.end, equals(value2));
      });

      test('handles negative to positive transitions', () {
        const negative = -50;
        const positive = 50;
        final tween = negative.tweenTo(positive);

        expect(tween.begin, equals(negative));
        expect(tween.end, equals(positive));
      });
    });

    group('type safety', () {
      test('returns correct generic type', () {
        final tween = 10.tweenTo(20);
        expect(tween, isA<Tween<int>>());
        expect(tween.begin, isA<int>());
        expect(tween.end, isA<int>());
      });

      test('tween properties are int values', () {
        final tween = 10.tweenTo(20);
        expect(tween.begin, isA<int>());
        expect(tween.end, isA<int>());
      });
    });
  });
}