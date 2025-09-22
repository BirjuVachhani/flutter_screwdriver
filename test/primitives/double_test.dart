// Author: Birju Vachhani
// Created Date: September 21, 2025

import 'package:flutter/animation.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoubleFS extension tests', () {
    group('tweenTo', () {
      test('creates Tween with correct begin and end values', () {
        const startValue = 5.0;
        const endValue = 10.0;
        final tween = startValue.tweenTo(endValue);

        expect(tween, isA<Tween<double>>());
        expect(tween.begin, equals(startValue));
        expect(tween.end, equals(endValue));
      });

      test('works with negative values', () {
        const startValue = -10.5;
        const endValue = -5.2;
        final tween = startValue.tweenTo(endValue);

        expect(tween.begin, equals(startValue));
        expect(tween.end, equals(endValue));
      });

      test('works with zero values', () {
        const startValue = 0.0;
        const endValue = 100.5;
        final tween = startValue.tweenTo(endValue);

        expect(tween.begin, equals(startValue));
        expect(tween.end, equals(endValue));
      });

      test('works with same values', () {
        const value = 42.7;
        final tween = value.tweenTo(value);

        expect(tween.begin, equals(value));
        expect(tween.end, equals(value));
      });

      test('works with decreasing values', () {
        const startValue = 100.8;
        const endValue = 50.3;
        final tween = startValue.tweenTo(endValue);

        expect(tween.begin, equals(startValue));
        expect(tween.end, equals(endValue));
      });

      test('creates functional tween that can be evaluated', () {
        const startValue = 10.0;
        const endValue = 20.0;
        final tween = startValue.tweenTo(endValue);

        final midValue = tween.lerp(0.5);
        expect(midValue, equals(15.0));

        final quarterValue = tween.lerp(0.25);
        expect(quarterValue, equals(12.5));

        final threeQuarterValue = tween.lerp(0.75);
        expect(threeQuarterValue, equals(17.5));
      });

      test('handles fractional values precisely', () {
        const startValue = 1.25;
        const endValue = 3.75;
        final tween = startValue.tweenTo(endValue);

        final midValue = tween.lerp(0.5);
        expect(midValue, equals(2.5));

        final quarterValue = tween.lerp(0.25);
        expect(quarterValue, closeTo(1.875, 0.001));
      });

      test('handles very small values', () {
        const startValue = 0.001;
        const endValue = 0.002;
        final tween = startValue.tweenTo(endValue);

        expect(tween.begin, equals(startValue));
        expect(tween.end, equals(endValue));
        expect(tween.lerp(0.5), closeTo(0.0015, 0.0001));
      });

      test('handles very large values', () {
        const startValue = 1e6;
        const endValue = 2e6;
        final tween = startValue.tweenTo(endValue);

        expect(tween.begin, equals(startValue));
        expect(tween.end, equals(endValue));
        expect(tween.lerp(0.5), equals(1.5e6));
      });

      test('lerp works correctly at boundaries', () {
        const startValue = 10.5;
        const endValue = 20.7;
        final tween = startValue.tweenTo(endValue);

        expect(tween.lerp(0.0), equals(startValue));
        expect(tween.lerp(1.0), equals(endValue));
      });

      test('lerp works with values outside 0-1 range', () {
        const startValue = 10.0;
        const endValue = 20.0;
        final tween = startValue.tweenTo(endValue);

        expect(tween.lerp(-0.5), equals(5.0));
        expect(tween.lerp(1.5), equals(25.0));
      });

      test('handles infinite values', () {
        const startValue = 0.0;
        const endValue = double.infinity;
        final tween = startValue.tweenTo(endValue);

        expect(tween.begin, equals(startValue));
        expect(tween.end, equals(endValue));
      });

      test('handles NaN values', () {
        const startValue = 0.0;
        const endValue = double.nan;
        final tween = startValue.tweenTo(endValue);

        expect(tween.begin, equals(startValue));
        expect(tween.end, isNaN);
      });
    });

    group('tweenFrom', () {
      test('creates Tween with correct begin and end values', () {
        const beginValue = 5.5;
        const endValue = 10.3;
        final tween = endValue.tweenFrom(beginValue);

        expect(tween, isA<Tween<double>>());
        expect(tween.begin, equals(beginValue));
        expect(tween.end, equals(endValue));
      });

      test('works with negative values', () {
        const beginValue = -10.7;
        const endValue = -5.2;
        final tween = endValue.tweenFrom(beginValue);

        expect(tween.begin, equals(beginValue));
        expect(tween.end, equals(endValue));
      });

      test('works with zero values', () {
        const beginValue = 0.0;
        const endValue = 100.25;
        final tween = endValue.tweenFrom(beginValue);

        expect(tween.begin, equals(beginValue));
        expect(tween.end, equals(endValue));
      });

      test('works with same values', () {
        const value = 42.42;
        final tween = value.tweenFrom(value);

        expect(tween.begin, equals(value));
        expect(tween.end, equals(value));
      });

      test('is inverse of tweenTo', () {
        const valueA = 10.5;
        const valueB = 20.7;

        final tweenTo = valueA.tweenTo(valueB);
        final tweenFrom = valueB.tweenFrom(valueA);

        expect(tweenTo.begin, equals(tweenFrom.begin));
        expect(tweenTo.end, equals(tweenFrom.end));
      });

      test('creates functional tween that can be evaluated', () {
        const beginValue = 10.0;
        const endValue = 20.0;
        final tween = endValue.tweenFrom(beginValue);

        final midValue = tween.lerp(0.5);
        expect(midValue, equals(15.0));

        final quarterValue = tween.lerp(0.25);
        expect(quarterValue, equals(12.5));

        final threeQuarterValue = tween.lerp(0.75);
        expect(threeQuarterValue, equals(17.5));
      });

      test('handles fractional values precisely', () {
        const beginValue = 1.125;
        const endValue = 3.875;
        final tween = endValue.tweenFrom(beginValue);

        final midValue = tween.lerp(0.5);
        expect(midValue, equals(2.5));

        final tenthValue = tween.lerp(0.1);
        expect(tenthValue, closeTo(1.4, 0.001));
      });
    });

    group('integration tests', () {
      test('tweenTo and tweenFrom work together correctly', () {
        const valueA = 100.25;
        const valueB = 200.75;

        final tweenAtoB = valueA.tweenTo(valueB);
        final tweenBfromA = valueB.tweenFrom(valueA);

        // Both should create equivalent tweens
        expect(tweenAtoB.begin, equals(tweenBfromA.begin));
        expect(tweenAtoB.end, equals(tweenBfromA.end));

        // Both should interpolate the same way
        expect(tweenAtoB.lerp(0.3), equals(tweenBfromA.lerp(0.3)));
        expect(tweenAtoB.lerp(0.7), equals(tweenBfromA.lerp(0.7)));
      });

      test('multiple tween operations work correctly', () {
        const start = 0.0;
        const middle = 50.5;
        const end = 100.0;

        final tween1 = start.tweenTo(middle);
        final tween2 = middle.tweenTo(end);
        final directTween = start.tweenTo(end);

        // Chaining should work
        expect(tween1.lerp(1.0), equals(middle));
        expect(tween2.lerp(0.0), equals(middle));

        // Direct tween should interpolate correctly
        expect(directTween.lerp(0.505), closeTo(50.5, 0.001));
      });

      test('tween methods are consistent across multiple calls', () {
        const value1 = 10.25;
        const value2 = 20.75;

        final tween1 = value1.tweenTo(value2);
        final tween2 = value1.tweenTo(value2);

        expect(tween1.begin, equals(tween2.begin));
        expect(tween1.end, equals(tween2.end));
        expect(tween1.lerp(0.5), equals(tween2.lerp(0.5)));
      });
    });

    group('edge cases', () {
      test('works with very large differences', () {
        const small = 0.001;
        const large = 1000000.999;
        final tween = small.tweenTo(large);

        expect(tween.begin, equals(small));
        expect(tween.end, equals(large));
        expect(tween.lerp(0.5), closeTo(500000.5, 0.001));
      });

      test('maintains precision with fractional values', () {
        const value1 = 1.1;
        const value2 = 2.9;
        final tween = value1.tweenTo(value2);

        expect(tween.lerp(0.0), equals(1.1));
        expect(tween.lerp(0.5), equals(2.0));
        expect(tween.lerp(1.0), equals(2.9));
      });

      test('handles negative to positive transitions', () {
        const negative = -50.75;
        const positive = 50.25;
        final tween = negative.tweenTo(positive);

        expect(tween.begin, equals(negative));
        expect(tween.end, equals(positive));
        expect(tween.lerp(0.5), closeTo(-0.25, 0.001));
      });

      test('handles scientific notation', () {
        const small = 1e-10;
        const large = 1e10;
        final tween = small.tweenTo(large);

        expect(tween.begin, equals(small));
        expect(tween.end, equals(large));
      });

      test('works with minimum and maximum finite values', () {
        const minValue = -double.maxFinite;
        const maxValue = double.maxFinite;

        final tween = minValue.tweenTo(maxValue);
        expect(tween.begin, equals(minValue));
        expect(tween.end, equals(maxValue));
      });
    });

    group('precision tests', () {
      test('maintains high precision with small increments', () {
        const start = 0.1;
        const end = 0.2;
        final tween = start.tweenTo(end);

        final steps = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];
        for (final step in steps) {
          final result = tween.lerp(step);
          expect(result, greaterThanOrEqualTo(start));
          expect(result, lessThanOrEqualTo(end));
        }
      });

      test('works correctly with repeated decimal values', () {
        const start = 1.0 / 3.0; // 0.333...
        const end = 2.0 / 3.0;   // 0.666...
        final tween = start.tweenTo(end);

        expect(tween.begin, equals(start));
        expect(tween.end, equals(end));
        expect(tween.lerp(0.5), closeTo(0.5, 0.001));
      });
    });

    group('type safety', () {
      test('returns correct generic type', () {
        final tween = 10.5.tweenTo(20.7);
        expect(tween, isA<Tween<double>>());
        expect(tween.begin, isA<double>());
        expect(tween.end, isA<double>());
      });

      test('lerp returns double values', () {
        final tween = 10.5.tweenTo(20.7);
        final lerpResult = tween.lerp(0.5);
        expect(lerpResult, isA<double>());
      });

      test('handles integer-like doubles correctly', () {
        final tween = 10.0.tweenTo(20.0);
        expect(tween.begin, isA<double>());
        expect(tween.end, isA<double>());
        expect(tween.lerp(0.5), equals(15.0));
      });
    });
  });
}