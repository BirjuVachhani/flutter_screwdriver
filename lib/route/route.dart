// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: September 02, 2020

part of flutter_screwdriver;

/// provides extensions for [Route]
extension RouteFS<T> on Route<T> {
  /// Short for [Navigator.push]
  Future<T?> push(BuildContext context) => Navigator.push(context, this);

  /// Short for [Navigator.pushAndRemoveUntil]
  Future<T?> pushAndRemoveUntil(
          BuildContext context, RoutePredicate predicate) =>
      Navigator.pushAndRemoveUntil(context, this, predicate);

  /// Short for [Navigator.pushReplacement]
  Future<T?> pushReplacement(BuildContext context) =>
      Navigator.pushReplacement(context, this);
}
