// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

/// Provides page route with fade-scale material transition
/// from animations package.
class FadeScalePageRoute<T> extends PageRouteBuilder<T> {
  /// duration is in milliseconds
  FadeScalePageRoute({required Widget child, int duration = 300})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: Duration(milliseconds: duration),
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeScaleTransition(animation: animation, child: child);
  }
}
