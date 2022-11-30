// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: April 26, 2021
part of flutter_screwdriver;

/// provides extensions for [int]
extension IntFS on int {
  /// allows to create a tween that start with [this] value
  /// and ends with [end] value.
  Tween<int> tweenTo(int end) => Tween<int>(begin: this, end: end);

  /// allows to create a tween that start with [begin] value
  /// and ends with [this] value.
  Tween<int> tweenFrom(int begin) => Tween<int>(begin: begin, end: this);
}
