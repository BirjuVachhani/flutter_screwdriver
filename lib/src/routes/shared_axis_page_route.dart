// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

/// Provides page route with shared axis material transition
/// from animations package.
/// User [SharedAxisTransitionType.vertical] for (y-axis) page transition.
/// User [SharedAxisTransitionType.horizontal] for (x-axis) page transition.
/// User [SharedAxisTransitionType.scaled] for (z-axis) page transition.
class SharedAxisPageRoute<T> extends PageRouteBuilder<T> {
  /// enum which determines the animation type
  final SharedAxisTransitionType type;

  /// Secondary constructor which sets [type] to
  /// [SharedAxisTransitionType.vertical]
  SharedAxisPageRoute.vertical({required Widget child, int duration = 300})
      : type = SharedAxisTransitionType.vertical,
        super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: Duration(milliseconds: duration),
        );

  /// Secondary constructor which sets [type] to
  /// [SharedAxisTransitionType.horizontal]
  SharedAxisPageRoute.horizontal({required Widget child, int duration = 300})
      : type = SharedAxisTransitionType.horizontal,
        super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: Duration(milliseconds: duration),
        );

  /// Secondary constructor which sets [type] to
  /// [SharedAxisTransitionType.scaled]
  SharedAxisPageRoute.scaled({required Widget child, int duration = 300})
      : type = SharedAxisTransitionType.scaled,
        super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: Duration(milliseconds: duration),
        );

  /// Primary constructor
  /// duration is in milliseconds
  SharedAxisPageRoute({
    required Widget child,
    required this.type,
    int duration = 300,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: Duration(milliseconds: duration),
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SharedAxisTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      transitionType: type,
      child: child,
    );
  }
}
