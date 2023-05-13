// Copyright © 2022 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: November 30, 2022

import 'package:flutter/widgets.dart';

/// Builder function type for [Hoverable] where [hovering] is a boolean
/// indicating whether the widget is currently being hovered or not.
/// [child] is the child widget of [Hoverable] which won't be rebuilt
/// when [hovering] changes.
typedef HoverWidgetBuilder = Widget Function(
  BuildContext context,
  bool hovering,
  Widget? child,
);

/// A widget that detects mouse hover events and notifies its child.
/// This widget is useful when you want to change the appearance of a widget
/// when the mouse hovers over it.
///
/// Example:
///   HoverBuilder(
///     builder: (context, hovering, child) {
///       return AnimatedContainer(
///         duration: const Duration(milliseconds: 200),
///         width: 100,
///         height: 100,
///         color: hovering ? Colors.orange : Colors.red,
///         alignment: Alignment.center,
///         child: child,
///       );
///     },
///     child: const Text('Hover Me'),
///   ),
///
class Hoverable extends StatefulWidget {
  /// Builder that builds the child.
  final HoverWidgetBuilder builder;

  /// Refers to the [MouseRegion.opaque] property.
  final bool opaque;

  /// Refers to the [MouseRegion.cursor] property.
  final MouseCursor cursor;

  /// Refers to the [MouseRegion.onEnter] property.
  final HitTestBehavior? hitTestBehavior;

  /// Child of this widget.
  final Widget? child;

  /// Creates Hoverable widget with given values.
  const Hoverable({
    super.key,
    required this.builder,
    this.opaque = true,
    this.cursor = MouseCursor.defer,
    this.hitTestBehavior,
    this.child,
  });

  @override
  State<Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      opaque: widget.opaque,
      cursor: widget.cursor,
      hitTestBehavior: widget.hitTestBehavior,
      onEnter: (_) => setState(() => hovering = true),
      onHover: (event) {
        if (hovering) return;
        setState(() => hovering = true);
      },
      onExit: (event) => setState(() => hovering = false),
      child: widget.builder(context, hovering, widget.child),
    );
  }
}
