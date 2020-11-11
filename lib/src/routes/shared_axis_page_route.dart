/*
 *  Copyright (c) 2020, Birju Vachhani
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *  1. Redistributions of source code must retain the above copyright notice,
 *     this list of conditions and the following disclaimer.
 *
 *  2. Redistributions in binary form must reproduce the above copyright notice,
 *     this list of conditions and the following disclaimer in the documentation
 *     and/or other materials provided with the distribution.
 *
 *  3. Neither the name of the copyright holder nor the names of its
 *     contributors may be used to endorse or promote products derived from
 *     this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 *  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 *  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *  POSSIBILITY OF SUCH DAMAGE.
 */

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

/// Provides page route with shared axis material transition
/// from animations package.
/// User [SharedAxisTransitionType.vertical] for (y-axis) page transition.
/// User [SharedAxisTransitionType.horizontal] for (x-axis) page transition.
/// User [SharedAxisTransitionType.scaled] for (z-axis) page transition.
class SharedAxisPageRoute<T> extends PageRouteBuilder<T> {
  @override
  final Duration transitionDuration;

  /// enum which determines the animation type
  final SharedAxisTransitionType type;

  /// Secondary constructor which sets [type] to
  /// [SharedAxisTransitionType.vertical]
  SharedAxisPageRoute.vertical({@required Widget child, double duration})
      : type = SharedAxisTransitionType.vertical,
        transitionDuration = Duration(milliseconds: duration ?? 300),
        super(pageBuilder: (context, animation, secondaryAnimation) => child);

  /// Secondary constructor which sets [type] to
  /// [SharedAxisTransitionType.horizontal]
  SharedAxisPageRoute.horizontal({@required Widget child, double duration})
      : type = SharedAxisTransitionType.horizontal,
        transitionDuration = Duration(milliseconds: duration ?? 300),
        super(pageBuilder: (context, animation, secondaryAnimation) => child);

  /// Secondary constructor which sets [type] to
  /// [SharedAxisTransitionType.scaled]
  SharedAxisPageRoute.scaled({@required Widget child, double duration})
      : type = SharedAxisTransitionType.scaled,
        transitionDuration = Duration(milliseconds: duration ?? 300),
        super(pageBuilder: (context, animation, secondaryAnimation) => child);

  /// Primary constructor
  /// duration is in milliseconds
  SharedAxisPageRoute(
      {@required Widget child, @required this.type, double duration})
      : transitionDuration = Duration(milliseconds: duration ?? 300),
        super(pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SharedAxisTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
      transitionType: type,
    );
  }
}
