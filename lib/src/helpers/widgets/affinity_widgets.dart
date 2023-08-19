/*
 * Copyright © 2023 Birju Vachhani. All rights reserved.
 * Use of this source code is governed by a BSD 3-Clause License that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

/// Represents the affinity of the widget's [leading] and [trailing] widgets
/// in [HorizontalAffinity] widget.
enum Affinity {
  /// Indicates that the [leading] widget is placed before the [child] widget
  /// and the [trailing] widget is placed after the [child] widget in
  /// [HorizontalAffinity] widget.
  start,

  /// Indicates that the [leading] widget is placed after the [child] widget
  /// and the [trailing] widget is placed before the [child] widget in
  /// [HorizontalAffinity] widget.
  end;
}

/// Represents a widget that allows to place a widget before and after the
/// child widget in horizontal direction which is controlled by [affinity].
///
/// If [affinity] is set to [Affinity.start], the [leading] widget will be
/// placed before the [child] widget and the [trailing] widget will be placed
/// after the [child] widget.
///
/// If [affinity] is set to [Affinity.end], the [leading] widget will be
/// placed after the [child] widget and the [trailing] widget will be placed
/// before the [child] widget.
class HorizontalAffinity extends DirectionalAffinity {
  /// Creates a [HorizontalAffinity] widget.
  HorizontalAffinity({
    super.key,
    super.leading,
    super.trailing,
    super.affinity = Affinity.start,
    required super.child,
    super.mainAxisSize = MainAxisSize.min,
    super.mainAxisAlignment = MainAxisAlignment.start,
    super.crossAxisAlignment = CrossAxisAlignment.center,
    super.spacing = 8,
  })  : assert(leading != null || trailing != null,
            'Either leading or trailing widget must be provided.'),
        super(direction: Axis.horizontal);
}

/// Represents a widget that allows to place a widget above and below the
/// child widget in horizontal direction which is controlled by [affinity].
///
/// If [affinity] is set to [Affinity.start], the [leading] widget will be
/// placed above the [child] widget and the [trailing] widget will be placed
/// below the [child] widget.
///
/// If [affinity] is set to [Affinity.end], the [leading] widget will be
/// placed below the [child] widget and the [trailing] widget will be placed
/// above the [child] widget.
class VerticalAffinity extends DirectionalAffinity {
  /// Creates a [HorizontalAffinity] widget.
  VerticalAffinity({
    super.key,
    super.leading,
    super.trailing,
    super.affinity = Affinity.start,
    required super.child,
    super.mainAxisSize = MainAxisSize.min,
    super.mainAxisAlignment = MainAxisAlignment.start,
    super.crossAxisAlignment = CrossAxisAlignment.center,
    super.spacing = 8,
  })  : assert(leading != null || trailing != null,
            'Either leading or trailing widget must be provided.'),
        super(direction: Axis.horizontal);
}

/// Represents a widget that allows to place a widget before and after the
/// child widget which is controlled by [affinity] in either horizontal or
/// vertical [direction].
///
/// Representation:
///
/// Row [leading, gap, child, gap, trailing]
///
/// Column[
///   leading,
///   gap
///   child,
///   gap,
///   trailing
/// ]
///
/// Placement of [leading] and [trailing] widgets is controlled by [affinity].
class DirectionalAffinity extends Flex {
  /// Represents the affinity of the widget's [leading] and [trailing] widgets.
  final Affinity affinity;

  /// Leading widget to be placed before/after the [child] widget based on
  /// [affinity]. Will be placed before the [child] widget if [affinity] is
  /// set to [Affinity.start] and after the [child] widget if [affinity] is
  /// set to [Affinity.end].
  final Widget? leading;

  /// Trailing widget to be placed before/after the [child] widget based on
  /// [affinity]. Will be placed after the [child] widget if [affinity] is
  /// set to [Affinity.start] and before the [child] widget if [affinity] is
  /// set to [Affinity.end].
  final Widget? trailing;

  /// Represents the child widget or body of the [HorizontalAffinity] widget
  /// which will be placed between the [leading] and [trailing] widgets.
  final Widget child;

  /// Represents the spacing between the [leading] and [trailing] widgets
  /// and the [child] widget.
  final double spacing;

  /// Creates a [DirectionalAffinity] widget.
  DirectionalAffinity({
    super.key,
    required super.direction,
    this.leading,
    this.trailing,
    this.affinity = Affinity.start,
    required this.child,
    super.mainAxisSize = MainAxisSize.min,
    super.mainAxisAlignment = MainAxisAlignment.start,
    super.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 8,
  })  : assert(leading != null || trailing != null,
            'Either leading or trailing widget must be provided.'),
        super(
          children: [
            if (affinity == Affinity.start && leading != null) leading,
            if (affinity == Affinity.end && trailing != null) trailing,
            SizedBox(width: spacing),
            child,
            SizedBox(width: spacing),
            if (affinity == Affinity.end && leading != null) leading,
            if (affinity == Affinity.start && trailing != null) trailing,
          ],
        );
}
