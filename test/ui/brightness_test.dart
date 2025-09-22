// Author: Birju Vachhani
// Created Date: September 21, 2025

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BrightnessFS extension tests', () {
    group('isDark getter', () {
      test('returns true for Brightness.dark', () {
        expect(Brightness.dark.isDark, isTrue);
      });

      test('returns false for Brightness.light', () {
        expect(Brightness.light.isDark, isFalse);
      });

      test('is consistent with direct comparison', () {
        expect(Brightness.dark.isDark, equals(Brightness.dark == Brightness.dark));
        expect(Brightness.light.isDark, equals(Brightness.light == Brightness.dark));
      });
    });

    group('isLight getter', () {
      test('returns true for Brightness.light', () {
        expect(Brightness.light.isLight, isTrue);
      });

      test('returns false for Brightness.dark', () {
        expect(Brightness.dark.isLight, isFalse);
      });

      test('is consistent with direct comparison', () {
        expect(Brightness.light.isLight, equals(Brightness.light == Brightness.light));
        expect(Brightness.dark.isLight, equals(Brightness.dark == Brightness.light));
      });
    });

    group('toggled getter', () {
      test('returns Brightness.light when current is dark', () {
        expect(Brightness.dark.toggled, equals(Brightness.light));
      });

      test('returns Brightness.dark when current is light', () {
        expect(Brightness.light.toggled, equals(Brightness.dark));
      });

      test('double toggle returns original value', () {
        expect(Brightness.dark.toggled.toggled, equals(Brightness.dark));
        expect(Brightness.light.toggled.toggled, equals(Brightness.light));
      });

      test('toggled value has opposite properties', () {
        final darkToggled = Brightness.dark.toggled;
        expect(darkToggled.isLight, isTrue);
        expect(darkToggled.isDark, isFalse);

        final lightToggled = Brightness.light.toggled;
        expect(lightToggled.isDark, isTrue);
        expect(lightToggled.isLight, isFalse);
      });
    });

    group('name getter', () {
      test('returns "dark" for Brightness.dark', () {
        expect(Brightness.dark.name, equals('dark'));
      });

      test('returns "light" for Brightness.light', () {
        expect(Brightness.light.name, equals('light'));
      });

      test('returns string without enum prefix', () {
        expect(Brightness.dark.name, isNot(contains('Brightness.')));
        expect(Brightness.light.name, isNot(contains('Brightness.')));
      });

      test('name is lowercase', () {
        expect(Brightness.dark.name, equals(Brightness.dark.name.toLowerCase()));
        expect(Brightness.light.name, equals(Brightness.light.name.toLowerCase()));
      });

      test('name matches expected string values', () {
        expect(Brightness.dark.name, isA<String>());
        expect(Brightness.light.name, isA<String>());
        expect(Brightness.dark.name.length, greaterThan(0));
        expect(Brightness.light.name.length, greaterThan(0));
      });
    });

    group('mutual exclusivity tests', () {
      test('isDark and isLight are mutually exclusive', () {
        expect(Brightness.dark.isDark, isNot(equals(Brightness.dark.isLight)));
        expect(Brightness.light.isDark, isNot(equals(Brightness.light.isLight)));
      });

      test('exactly one of isDark or isLight is true', () {
        // For dark brightness
        expect(Brightness.dark.isDark || Brightness.dark.isLight, isTrue);
        expect(Brightness.dark.isDark && Brightness.dark.isLight, isFalse);

        // For light brightness
        expect(Brightness.light.isDark || Brightness.light.isLight, isTrue);
        expect(Brightness.light.isDark && Brightness.light.isLight, isFalse);
      });
    });

    group('integration tests', () {
      test('all extension methods work together correctly', () {
        const brightnesses = [Brightness.dark, Brightness.light];

        for (final brightness in brightnesses) {
          // Test that all getters return expected types
          expect(brightness.isDark, isA<bool>());
          expect(brightness.isLight, isA<bool>());
          expect(brightness.toggled, isA<Brightness>());
          expect(brightness.name, isA<String>());

          // Test consistency
          expect(brightness.isDark, isNot(equals(brightness.isLight)));
          expect(brightness.toggled.toggled, equals(brightness));
        }
      });

      test('methods are consistent across different instances', () {
        const dark1 = Brightness.dark;
        const dark2 = Brightness.dark;
        const light1 = Brightness.light;
        const light2 = Brightness.light;

        expect(dark1.isDark, equals(dark2.isDark));
        expect(dark1.isLight, equals(dark2.isLight));
        expect(dark1.toggled, equals(dark2.toggled));
        expect(dark1.name, equals(dark2.name));

        expect(light1.isDark, equals(light2.isDark));
        expect(light1.isLight, equals(light2.isLight));
        expect(light1.toggled, equals(light2.toggled));
        expect(light1.name, equals(light2.name));
      });

      test('extension works with brightness from different sources', () {
        // Test with brightness from theme
        final themeData = ThemeData();
        final themeBrightness = themeData.brightness;

        expect(themeBrightness.isDark, isA<bool>());
        expect(themeBrightness.isLight, isA<bool>());
        expect(themeBrightness.toggled, isA<Brightness>());
        expect(themeBrightness.name, isA<String>());

        // Test with manually created brightness values
        final brightnesses = [Brightness.dark, Brightness.light];
        for (final brightness in brightnesses) {
          expect(brightness.toggled, isIn(brightnesses));
          expect(brightness.name, isIn(['dark', 'light']));
        }
      });
    });

    group('property relationships', () {
      test('toggled creates correct inverse relationships', () {
        expect(Brightness.dark.toggled.isDark, isFalse);
        expect(Brightness.dark.toggled.isLight, isTrue);
        expect(Brightness.light.toggled.isDark, isTrue);
        expect(Brightness.light.toggled.isLight, isFalse);
      });

      test('name corresponds to boolean properties', () {
        expect(Brightness.dark.name, equals('dark'));
        expect(Brightness.dark.isDark, isTrue);

        expect(Brightness.light.name, equals('light'));
        expect(Brightness.light.isLight, isTrue);
      });

      test('toggled name matches expected inverse', () {
        expect(Brightness.dark.toggled.name, equals('light'));
        expect(Brightness.light.toggled.name, equals('dark'));
      });
    });

    group('edge cases and invariants', () {
      test('extension methods do not modify original brightness', () {
        const original = Brightness.dark;

        // Call extension methods
        final _ = original.isDark;
        final __ = original.isLight;
        final toggled = original.toggled;
        final ___ = original.name;

        // Original should remain unchanged
        expect(original, equals(Brightness.dark));
        expect(toggled, isNot(equals(original)));
      });

      test('name getter is deterministic', () {
        final name1 = Brightness.dark.name;
        final name2 = Brightness.dark.name;
        final name3 = Brightness.light.name;
        final name4 = Brightness.light.name;

        expect(name1, equals(name2));
        expect(name3, equals(name4));
        expect(name1, isNot(equals(name3)));
      });

      test('boolean getters are deterministic', () {
        final isDark1 = Brightness.dark.isDark;
        final isDark2 = Brightness.dark.isDark;
        final isLight1 = Brightness.light.isLight;
        final isLight2 = Brightness.light.isLight;

        expect(isDark1, equals(isDark2));
        expect(isLight1, equals(isLight2));
      });

      test('toggled getter is deterministic', () {
        final toggled1 = Brightness.dark.toggled;
        final toggled2 = Brightness.dark.toggled;
        final toggled3 = Brightness.light.toggled;
        final toggled4 = Brightness.light.toggled;

        expect(toggled1, equals(toggled2));
        expect(toggled3, equals(toggled4));
      });
    });

    group('type safety', () {
      test('all getters return expected types', () {
        expect(Brightness.dark.isDark, isA<bool>());
        expect(Brightness.dark.isLight, isA<bool>());
        expect(Brightness.dark.toggled, isA<Brightness>());
        expect(Brightness.dark.name, isA<String>());

        expect(Brightness.light.isDark, isA<bool>());
        expect(Brightness.light.isLight, isA<bool>());
        expect(Brightness.light.toggled, isA<Brightness>());
        expect(Brightness.light.name, isA<String>());
      });

      test('toggled returns valid Brightness enum value', () {
        final darkToggled = Brightness.dark.toggled;
        final lightToggled = Brightness.light.toggled;

        expect(darkToggled, isIn(Brightness.values));
        expect(lightToggled, isIn(Brightness.values));
      });
    });
  });
}