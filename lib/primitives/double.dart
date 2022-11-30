// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: April 26, 2021

part of flutter_screwdriver;

/// provides extensions for [double]
extension DoubleFS on double {
  /// allows to create a tween that start with [this] value
  /// and ends with [end] value.
  Tween<double> tweenTo(double end) => Tween<double>(begin: this, end: end);

  /// allows to create a tween that start with [begin] value
  /// and ends with [this] value.
  Tween<double> tweenFrom(double begin) =>
      Tween<double>(begin: begin, end: this);
}
