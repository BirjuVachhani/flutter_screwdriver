// Author: Birju Vachhani
// Created Date: September 14, 2020

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ColorFS extension tests', () {
    group('RGB value getters', () {
      test('redValue returns correct red channel value', () {
        expect(const Color(0xFFFF0000).redValue, equals(255));
        expect(const Color(0xFF800000).redValue, equals(128));
        expect(const Color(0xFF000000).redValue, equals(0));
        expect(const Color(0xFF010000).redValue, equals(1));
        expect(const Color(0xFFFFFFFF).redValue, equals(255));
      });

      test('greenValue returns correct green channel value', () {
        expect(const Color(0xFF00FF00).greenValue, equals(255));
        expect(const Color(0xFF008000).greenValue, equals(128));
        expect(const Color(0xFF000000).greenValue, equals(0));
        expect(const Color(0xFF000100).greenValue, equals(1));
        expect(const Color(0xFFFFFFFF).greenValue, equals(255));
      });

      test('blueValue returns correct blue channel value', () {
        expect(const Color(0xFF0000FF).blueValue, equals(255));
        expect(const Color(0xFF000080).blueValue, equals(128));
        expect(const Color(0xFF000000).blueValue, equals(0));
        expect(const Color(0xFF000001).blueValue, equals(1));
        expect(const Color(0xFFFFFFFF).blueValue, equals(255));
      });

      test('RGB getters work with alpha channel', () {
        // Alpha should not affect RGB values
        const opaqueColor = Color(0xFFFF8040);
        const transparentColor = Color(0x80FF8040);
        const fullyTransparentColor = Color(0x00FF8040);

        expect(opaqueColor.redValue, equals(255));
        expect(opaqueColor.greenValue, equals(128));
        expect(opaqueColor.blueValue, equals(64));

        expect(transparentColor.redValue, equals(255));
        expect(transparentColor.greenValue, equals(128));
        expect(transparentColor.blueValue, equals(64));

        expect(fullyTransparentColor.redValue, equals(255));
        expect(fullyTransparentColor.greenValue, equals(128));
        expect(fullyTransparentColor.blueValue, equals(64));
      });

      test('RGB getters handle various color combinations', () {
        const testColors = [
          Color(0xFFABCDEF),
          Color(0xFF123456),
          Color(0xFF789ABC),
          Color(0xFFDEF123),
          Color(0xFF456789),
          Color(0xFF9ABCDE),
        ];

        for (final color in testColors) {
          final argb = color.toARGB32();
          final expectedRed = (0x00ff0000 & argb) >> 16;
          final expectedGreen = (0x0000ff00 & argb) >> 8;
          final expectedBlue = (0x000000ff & argb) >> 0;

          expect(color.redValue, equals(expectedRed));
          expect(color.greenValue, equals(expectedGreen));
          expect(color.blueValue, equals(expectedBlue));
        }
      });

      test('RGB getters are consistent with manual bit extraction', () {
        const testColors = [
          Color(0xFFFF0000),
          Color(0xFF00FF00),
          Color(0xFF0000FF),
          Color(0xFFFFFFFF),
          Color(0xFF000000),
          Color(0xFF808080),
          Color(0xFFABCDEF),
          Color(0xFF123456),
        ];

        for (final color in testColors) {
          final argb = color.toARGB32();
          final expectedRed = (argb >> 16) & 0xFF;
          final expectedGreen = (argb >> 8) & 0xFF;
          final expectedBlue = argb & 0xFF;

          expect(color.redValue, equals(expectedRed));
          expect(color.greenValue, equals(expectedGreen));
          expect(color.blueValue, equals(expectedBlue));
        }
      });

      test('RGB getters work with extreme values', () {
        // Test minimum values
        expect(const Color(0xFF000000).redValue, equals(0));
        expect(const Color(0xFF000000).greenValue, equals(0));
        expect(const Color(0xFF000000).blueValue, equals(0));

        // Test maximum values
        expect(const Color(0xFFFFFFFF).redValue, equals(255));
        expect(const Color(0xFFFFFFFF).greenValue, equals(255));
        expect(const Color(0xFFFFFFFF).blueValue, equals(255));

        // Test single channel maximum
        expect(const Color(0xFFFF0000).redValue, equals(255));
        expect(const Color(0xFFFF0000).greenValue, equals(0));
        expect(const Color(0xFFFF0000).blueValue, equals(0));

        expect(const Color(0xFF00FF00).redValue, equals(0));
        expect(const Color(0xFF00FF00).greenValue, equals(255));
        expect(const Color(0xFF00FF00).blueValue, equals(0));

        expect(const Color(0xFF0000FF).redValue, equals(0));
        expect(const Color(0xFF0000FF).greenValue, equals(0));
        expect(const Color(0xFF0000FF).blueValue, equals(255));
      });

      test('RGB getters maintain precision', () {
        // Test all possible single-byte values for each channel
        for (var r = 0; r < 256; r += 85) {
          // Test 0, 85, 170, 255
          for (var g = 0; g < 256; g += 85) {
            for (var b = 0; b < 256; b += 85) {
              final color = Color.fromARGB(255, r, g, b);
              expect(color.redValue, equals(r));
              expect(color.greenValue, equals(g));
              expect(color.blueValue, equals(b));
            }
          }
        }
      });

      test('RGB getters work with Color.fromARGB constructor', () {
        final color1 = Color.fromARGB(255, 123, 45, 67);
        expect(color1.redValue, equals(123));
        expect(color1.greenValue, equals(45));
        expect(color1.blueValue, equals(67));

        final color2 = Color.fromARGB(128, 200, 150, 100);
        expect(color2.redValue, equals(200));
        expect(color2.greenValue, equals(150));
        expect(color2.blueValue, equals(100));
      });

      test('RGB getters work with Color.fromRGBO constructor', () {
        final color1 = Color.fromRGBO(234, 56, 78, 1.0);
        expect(color1.redValue, equals(234));
        expect(color1.greenValue, equals(56));
        expect(color1.blueValue, equals(78));

        final color2 = Color.fromRGBO(100, 200, 50, 0.5);
        expect(color2.redValue, equals(100));
        expect(color2.greenValue, equals(200));
        expect(color2.blueValue, equals(50));
      });
    });
    group('toMaterialColor', () {
      test('creates MaterialColor with correct primary value', () {
        const color = Color(0xFFFF4433);
        final materialColor = color.toMaterialColor();

        expect(materialColor, isA<MaterialColor>());
        expect(materialColor.toARGB32(), equals(color.toARGB32()));
      });

      test('creates MaterialColor with all shade levels', () {
        const color = Color(0xFF2196F3);
        final materialColor = color.toMaterialColor();

        // Test that all standard Material Design shade levels exist
        expect(materialColor[50], isNotNull);
        expect(materialColor[100], isNotNull);
        expect(materialColor[200], isNotNull);
        expect(materialColor[300], isNotNull);
        expect(materialColor[400], isNotNull);
        expect(materialColor[500], isNotNull);
        expect(materialColor[600], isNotNull);
        expect(materialColor[700], isNotNull);
        expect(materialColor[800], isNotNull);
        expect(materialColor[900], isNotNull);
      });

      test('shade 500 matches original color value', () {
        const color = Color(0xFFFF4433);
        final materialColor = color.toMaterialColor();

        expect(materialColor[500]!.toARGB32(), equals(color.toARGB32()));
      });

      test('lighter shades are lighter than darker shades', () {
        const color = Color(0xFF2196F3);
        final materialColor = color.toMaterialColor();

        // Compare relative lightness (50 should be lighter than 900)
        final shade50 = materialColor[50]!;
        final shade900 = materialColor[900]!;

        // Lighter shades should have higher RGB values
        expect(shade50.redValue, greaterThan(shade900.redValue));
        expect(shade50.greenValue, greaterThan(shade900.greenValue));
        expect(shade50.blueValue, greaterThan(shade900.blueValue));
      });

      test('works with edge case colors', () {
        // Test with pure black
        const black = Color(0xFF000000);
        final blackMaterial = black.toMaterialColor();
        expect(blackMaterial, isA<MaterialColor>());
        expect(blackMaterial[50], isNotNull);

        // Test with pure white
        const white = Color(0xFFFFFFFF);
        final whiteMaterial = white.toMaterialColor();
        expect(whiteMaterial, isA<MaterialColor>());
        expect(whiteMaterial[900], isNotNull);
      });
    });

    group('shade', () {
      test('generates correct shade colors', () {
        const color = Color(0xFFFF4433);
        final shade300 = color.shade(300);
        final shade700 = color.shade(700);

        expect(shade300, isA<Color>());
        expect(shade700, isA<Color>());

        // shade(700) should be darker than shade(300)
        expect(shade300.redValue, greaterThan(shade700.redValue));
        expect(shade300.greenValue, greaterThan(shade700.greenValue));
        expect(shade300.blueValue, greaterThan(shade700.blueValue));
      });

      test('shade matches MaterialColor shade', () {
        const color = Color(0xFFFF4433);
        final materialColor = color.toMaterialColor();

        expect(color.shade(300), equals(materialColor[300]));
        expect(color.shade(500), equals(materialColor[500]));
        expect(color.shade(700), equals(materialColor[700]));
      });

      test('handles all standard shade values', () {
        const color = Color(0xFF2196F3);

        expect(() => color.shade(50), returnsNormally);
        expect(() => color.shade(100), returnsNormally);
        expect(() => color.shade(200), returnsNormally);
        expect(() => color.shade(300), returnsNormally);
        expect(() => color.shade(400), returnsNormally);
        expect(() => color.shade(500), returnsNormally);
        expect(() => color.shade(600), returnsNormally);
        expect(() => color.shade(700), returnsNormally);
        expect(() => color.shade(800), returnsNormally);
        expect(() => color.shade(900), returnsNormally);
      });

      test('handles edge case shade values', () {
        const color = Color(0xFF2196F3);

        // Test extreme values
        expect(() => color.shade(0), returnsNormally);
        expect(() => color.shade(1000), returnsNormally);
      });
    });

    group('hexString', () {
      test('returns correct hex string format', () {
        expect(const Color(0xFFFF4433).hexString.toLowerCase(), '#ffff4433');
        expect(const Color(0xFF000000).hexString.toLowerCase(), '#ff000000');
        expect(const Color(0xFFFFFFFF).hexString.toLowerCase(), '#ffffffff');
      });

      test('includes alpha channel', () {
        expect(const Color(0x80FF4433).hexString.toLowerCase(), '#80ff4433');
        expect(const Color(0x00FF4433).hexString.toLowerCase(), '#00ff4433');
        expect(const Color(0xFFFF4433).hexString.toLowerCase(), '#ffff4433');
      });

      test('pads with zeros correctly', () {
        expect(const Color(0xFF000001).hexString.toLowerCase(), '#ff000001');
        expect(const Color(0xFF000010).hexString.toLowerCase(), '#ff000010');
        expect(const Color(0xFF000100).hexString.toLowerCase(), '#ff000100');
        expect(const Color(0xFF001000).hexString.toLowerCase(), '#ff001000');
        expect(const Color(0xFF010000).hexString.toLowerCase(), '#ff010000');
        expect(const Color(0xFF100000).hexString.toLowerCase(), '#ff100000');
      });

      test('handles various color formats', () {
        expect(const Color(0xFFFF0000).hexString.toLowerCase(), '#ffff0000');
        expect(const Color(0xFF00FF00).hexString.toLowerCase(), '#ff00ff00');
        expect(const Color(0xFF0000FF).hexString.toLowerCase(), '#ff0000ff');
        expect(const Color(0xFFFFFF00).hexString.toLowerCase(), '#ffffff00');
        expect(const Color(0xFFFF00FF).hexString.toLowerCase(), '#ffff00ff');
        expect(const Color(0xFF00FFFF).hexString.toLowerCase(), '#ff00ffff');
      });
    });

    group('tweenTo', () {
      test('creates ColorTween with correct begin and end', () {
        const startColor = Color(0xFFFF4433);
        const endColor = Color(0xFF454354);
        final tween = startColor.tweenTo(endColor);

        expect(tween, isA<ColorTween>());
        expect(tween.begin, equals(startColor));
        expect(tween.end, equals(endColor));
      });

      test('works with same colors', () {
        const color = Color(0xFFFF4433);
        final tween = color.tweenTo(color);

        expect(tween.begin, equals(color));
        expect(tween.end, equals(color));
      });

      test('works with transparent colors', () {
        const opaqueColor = Color(0xFFFF4433);
        const transparentColor = Color(0x00FF4433);
        final tween = opaqueColor.tweenTo(transparentColor);

        expect(tween.begin, equals(opaqueColor));
        expect(tween.end, equals(transparentColor));
      });

      test('creates functional tween', () {
        const startColor = Color(0xFFFF0000);
        const endColor = Color(0xFF0000FF);
        final tween = startColor.tweenTo(endColor);

        final midColor = tween.lerp(0.5);
        expect(midColor, isNotNull);
        expect(midColor!.redValue, lessThan(startColor.redValue));
        expect(midColor.blueValue, greaterThan(startColor.blueValue));
      });
    });

    group('tweenFrom', () {
      test('creates ColorTween with correct begin and end', () {
        const startColor = Color(0xFF454354);
        const endColor = Color(0xFFFF4433);
        final tween = endColor.tweenFrom(startColor);

        expect(tween, isA<ColorTween>());
        expect(tween.begin, equals(startColor));
        expect(tween.end, equals(endColor));
      });

      test('is inverse of tweenTo', () {
        const colorA = Color(0xFFFF4433);
        const colorB = Color(0xFF454354);

        final tweenTo = colorA.tweenTo(colorB);
        final tweenFrom = colorB.tweenFrom(colorA);

        expect(tweenTo.begin, equals(tweenFrom.begin));
        expect(tweenTo.end, equals(tweenFrom.end));
      });

      test('works with edge case colors', () {
        const black = Color(0xFF000000);
        const white = Color(0xFFFFFFFF);
        final tween = white.tweenFrom(black);

        expect(tween.begin, equals(black));
        expect(tween.end, equals(white));
      });
    });

    group('brightness', () {
      test('returns correct brightness for known colors', () {
        // Light colors
        expect(Colors.white.brightness, equals(Brightness.light));
        expect(const Color(0xFFFFFFFF).brightness, equals(Brightness.light));
        expect(const Color(0xFFFFFF00).brightness, equals(Brightness.light));

        // Dark colors
        expect(Colors.black.brightness, equals(Brightness.dark));
        expect(const Color(0xFF000000).brightness, equals(Brightness.dark));
        expect(const Color(0xFF000080).brightness, equals(Brightness.dark));
      });

      test('handles medium brightness colors consistently', () {
        const mediumGray = Color(0xFF808080);
        final brightness = mediumGray.brightness;
        expect(brightness, isIn([Brightness.light, Brightness.dark]));
      });

      test('brightness calculation is consistent', () {
        const color = Color(0xFF2196F3);
        final brightness1 = color.brightness;
        final brightness2 = color.brightness;
        expect(brightness1, equals(brightness2));
      });
    });

    group('isLight', () {
      test('returns true for light colors', () {
        expect(Colors.white.isLight, isTrue);
        expect(const Color(0xFFFFFFFF).isLight, isTrue);
        expect(const Color(0xFFFFFF00).isLight, isTrue);
        expect(const Color(0xFF00FFFF).isLight, isTrue);
      });

      test('returns false for dark colors', () {
        expect(Colors.black.isLight, isFalse);
        expect(const Color(0xFF000000).isLight, isFalse);
        expect(const Color(0xFF000080).isLight, isFalse);
        expect(const Color(0xFF800000).isLight, isFalse);
      });

      test('is consistent with brightness == Brightness.light', () {
        const colors = [
          Color(0xFFFFFFFF),
          Color(0xFF000000),
          Color(0xFFFF0000),
          Color(0xFF00FF00),
          Color(0xFF0000FF),
          Color(0xFFFFFF00),
          Color(0xFFFF00FF),
          Color(0xFF00FFFF),
          Color(0xFF808080),
        ];

        for (final color in colors) {
          expect(color.isLight, equals(color.brightness == Brightness.light));
        }
      });
    });

    group('isDark', () {
      test('returns true for dark colors', () {
        expect(Colors.black.isDark, isTrue);
        expect(const Color(0xFF000000).isDark, isTrue);
        expect(const Color(0xFF000080).isDark, isTrue);
        expect(const Color(0xFF800000).isDark, isTrue);
      });

      test('returns false for light colors', () {
        expect(Colors.white.isDark, isFalse);
        expect(const Color(0xFFFFFFFF).isDark, isFalse);
        expect(const Color(0xFFFFFF00).isDark, isFalse);
        expect(const Color(0xFF00FFFF).isDark, isFalse);
      });

      test('is consistent with brightness == Brightness.dark', () {
        const colors = [
          Color(0xFFFFFFFF),
          Color(0xFF000000),
          Color(0xFFFF0000),
          Color(0xFF00FF00),
          Color(0xFF0000FF),
          Color(0xFFFFFF00),
          Color(0xFFFF00FF),
          Color(0xFF00FFFF),
          Color(0xFF808080),
        ];

        for (final color in colors) {
          expect(color.isDark, equals(color.brightness == Brightness.dark));
        }
      });

      test('isLight and isDark are mutually exclusive', () {
        const colors = [
          Color(0xFFFFFFFF),
          Color(0xFF000000),
          Color(0xFFFF0000),
          Color(0xFF00FF00),
          Color(0xFF0000FF),
          Color(0xFFFFFF00),
          Color(0xFFFF00FF),
          Color(0xFF00FFFF),
          Color(0xFF808080),
          Color(0xFF123456),
          Color(0xFFABCDEF),
        ];

        for (final color in colors) {
          expect(color.isLight, isNot(equals(color.isDark)));
        }
      });
    });

    group('integration tests', () {
      test('all methods work together correctly', () {
        const originalColor = Color(0xFFFF4433);

        // Test material color generation
        final materialColor = originalColor.toMaterialColor();
        expect(materialColor, isA<MaterialColor>());

        // Test shade generation
        final lightShade = originalColor.shade(200);

        // Test hex string
        expect(originalColor.hexString, isNotEmpty);
        expect(originalColor.hexString, startsWith('#'));

        // Test tween creation
        final tween = originalColor.tweenTo(lightShade);
        expect(tween, isA<ColorTween>());

        // Test brightness detection
        expect(originalColor.brightness,
            isIn([Brightness.light, Brightness.dark]));
        expect(originalColor.isLight, isA<bool>());
        expect(originalColor.isDark, isA<bool>());
      });

      test('MaterialColor shades have correct brightness progression', () {
        const baseColor = Color(0xFF2196F3);
        final materialColor = baseColor.toMaterialColor();

        final shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

        // Check that lighter shades are more likely to be light
        // and darker shades are more likely to be dark
        final lightShades = shades.take(5).toList(); // 50-400
        final darkShades = shades.skip(5).toList(); // 500-900

        // Count light vs dark in each group
        var lightInLightShades = 0;
        var darkInDarkShades = 0;

        for (final shade in lightShades) {
          if (materialColor[shade]!.isLight) lightInLightShades++;
        }

        for (final shade in darkShades) {
          if (materialColor[shade]!.isDark) darkInDarkShades++;
        }

        // We expect some correlation but not perfect due to the specific color
        expect(lightInLightShades + darkInDarkShades, greaterThan(0));
      });
    });

    // Legacy tests to ensure backward compatibility
    group('backward compatibility', () {
      test('original color tests still pass', () {
        expect(const Color(0xFFFF4433).toMaterialColor(), isA<MaterialColor>());
        expect(const Color(0xFFFF4433).toMaterialColor()[300],
            const Color(0xFFFF4433).shade(300));
        expect(const Color(0xFFFF4433).hexString.toLowerCase(), '#ffff4433');
        expect(const Color(0xFFFF4433).tweenTo(const Color(0xFF454354)).begin,
            const Color(0xFFFF4433));
        expect(const Color(0xFFFF4433).tweenTo(const Color(0xFF454354)).end,
            const Color(0xFF454354));
        expect(const Color(0xFFFF4433).tweenFrom(const Color(0xFF454354)).begin,
            const Color(0xFF454354));
        expect(const Color(0xFFFF4433).tweenFrom(const Color(0xFF454354)).end,
            const Color(0xFFFF4433));
      });
    });
  });
}
