// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: September 01, 2020

part of '../flutter_screwdriver.dart';

/// Provides extensions for [Color]
extension ColorFS on Color {
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
        red + ((ds < 0 ? red : (255 - red)) * ds).round(),
        green + ((ds < 0 ? green : (255 - green)) * ds).round(),
        blue + ((ds < 0 ? blue : (255 - blue)) * ds).round(),
        1,
      );
    }
    return MaterialColor(value, swatch);
  }

  /// Returns [Color] from [this] shaded to [shade] and mixed with white as
  /// base color. This assumes [this] color to be a shade of 700.
  Color shade(int shade) {
    final ds = 0.5 - (shade / 1000);
    return Color.fromRGBO(
      red + ((ds < 0 ? red : (255 - red)) * ds).round(),
      green + ((ds < 0 ? green : (255 - green)) * ds).round(),
      blue + ((ds < 0 ? blue : (255 - blue)) * ds).round(),
      1,
    );
  }

  /// Returns hex string of [this] color
  String get hexString => '#${value.toRadixString(16).padLeft(8, '0')}';

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
