// Copyright © 2021 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: March 26, 2021

part of '../flutter_screwdriver.dart';

/// provides extensions for [Widget]
extension BrightnessFS<T> on Brightness {
  /// Shorthand for brightness == [Brightness.dark]
  bool get isDark => this == Brightness.dark;

  /// Shorthand for brightness == [Brightness.light]
  bool get isLight => this == Brightness.light;

  /// Returns toggled value of the brightness.
  Brightness get toggled =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;

  /// Returns the brightness as [String]. example: dark | light
  String get name => toString().split('.').last;
}
