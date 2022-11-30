// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: August 31, 2020

part of flutter_screwdriver;

/// provides extensions for [String]
extension StringFS on String {
  /// allows to convert a hex string to [Color]. Returns null if unable
  /// to convert.
  /// 3 digit hex codes are also supported.
  Color? toColor() {
    try {
      var colorString = startsWith('#') ? substring(1) : this;
      if (colorString.length == 3) {
        colorString = (colorString.substring(0, 1) * 2) +
            (colorString.substring(1, 2) * 2) +
            colorString.substring(2) * 2;
      }
      final hexNumber = int.parse(colorString, radix: 16);
      return Color.fromARGB(
        255,
        (hexNumber >> 16) & 0xFF,
        ((hexNumber >> 8) & 0xFF),
        (hexNumber >> 0) & 0xFF,
      );
    } catch (_) {
      return null;
    }
  }
}
