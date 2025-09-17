// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: September 01, 2020

part of '../flutter_screwdriver.dart';

/// Provides extensions for [Color]
extension ColorFS on Color {
  /// The red channel of this color in an 8 bit value.
  int get redValue => (0x00ff0000 & toARGB32()) >> 16;

  /// The green channel of this color in an 8 bit value.
  int get greenValue => (0x0000ff00 & toARGB32()) >> 8;

  /// The blue channel of this color in an 8 bit value.
  int get blueValue => (0x000000ff & toARGB32()) >> 0;

  /// converts a normal [Color] to material color with proper shades mixed
  /// with base color (white).
  MaterialColor toMaterialColor() {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};

    for (var i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (final strength in strengths) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        redValue + ((ds < 0 ? redValue : (255 - redValue)) * ds).round(),
        greenValue + ((ds < 0 ? greenValue : (255 - greenValue)) * ds).round(),
        blueValue + ((ds < 0 ? blueValue : (255 - blueValue)) * ds).round(),
        1,
      );
    }
    return MaterialColor(toARGB32(), swatch);
  }

  /// Returns [Color] from [this] shaded to [shade] and mixed with white as
  /// base color. This assumes [this] color to be a shade of 700.
  Color shade(int shade) {
    final ds = 0.5 - (shade / 1000);
    return Color.fromRGBO(
      redValue + ((ds < 0 ? redValue : (255 - redValue)) * ds).round(),
      greenValue + ((ds < 0 ? greenValue : (255 - greenValue)) * ds).round(),
      blueValue + ((ds < 0 ? blueValue : (255 - blueValue)) * ds).round(),
      1,
    );
  }

  /// Returns hex string of [this] color
  String get hexString => '#${toARGB32().toRadixString(16).padLeft(8, '0')}';

  /// allows to create a tween that start with [this] color
  /// and ends with [color].
  ColorTween tweenTo(Color color) => ColorTween(begin: this, end: color);

  /// allows to create a tween that start with [color] color
  /// and ends with [this].
  ColorTween tweenFrom(Color color) => ColorTween(begin: color, end: this);

  /// Returns the brightness of this color
  Brightness get brightness => ThemeData.estimateBrightnessForColor(this);

  /// Returns true if this color is a light color and has light brightness.
  bool get isLight => brightness == Brightness.light;

  /// Returns true if this color is a dark color and has dark brightness.
  bool get isDark => brightness == Brightness.dark;
}
