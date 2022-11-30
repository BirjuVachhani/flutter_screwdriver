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

// Author: Birju Vachhani
// Created Date: November 30, 2022

import 'package:flutter/widgets.dart';

/// Builder function type for [HoverBuilder] where [hovering] is a boolean
/// indicating whether the widget is currently being hovered or not.
/// [child] is the child widget of [HoverBuilder] which won't be rebuilt
/// when [hovering] changes.
typedef HoverWidgetBuilder = Widget Function(
  BuildContext context,
  bool hovering,
  Widget? child,
);

/// A widget that detects mouse hover events and notifies its child.
/// This widget is useful when you want to change the appearance of a widget
/// when the mouse hovers over it.
class HoverBuilder extends StatefulWidget {
  final HoverWidgetBuilder builder;

  /// Refers to the [MouseRegion.opaque] property.
  final bool opaque;

  /// Refers to the [MouseRegion.cursor] property.
  final MouseCursor cursor;

  /// Refers to the [MouseRegion.onEnter] property.
  final HitTestBehavior? hitTestBehavior;

  final Widget? child;

  const HoverBuilder({
    super.key,
    required this.builder,
    this.opaque = true,
    this.cursor = MouseCursor.defer,
    this.hitTestBehavior,
    this.child,
  });

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
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
