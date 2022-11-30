// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: September 03, 2020

import 'package:flutter/widgets.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

/// Hides keyboard on tap outside tap-able widgets.
/// This should be used as the parent of your [MaterialApp]. This way, it will
/// detect any touches outside text fields and other touchable areas and will
/// close the soft keyboard if open.
/// Flag [hide] can be used to toggle this behavior.
/// e.g.
///
/// HideKeyboard(
///   child: MaterialApp(
///     ...
///   ),
/// );
///
class HideKeyboard extends StatelessWidget {
  /// flag to toggle hiding of keyboard
  final bool hide;

  /// child widget, in most cases, [MaterialApp]
  final Widget child;

  /// Refers to the [GestureDetector.behavior] property.
  final HitTestBehavior? behavior;

  /// Default Constructor
  const HideKeyboard({
    Key? key,
    required this.child,
    this.hide = true,
    this.behavior,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: behavior,
      onTap: hide ? context.hideKeyboard : null,
      child: child,
    );
  }
}
