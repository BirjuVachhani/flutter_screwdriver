// Copyright © 2022 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// An alias name for the [Gap] widget.
typedef Space = Gap;

/// A widget that adds some space between widgets inside Flex widgets
/// such as Columns and Rows or scrolling views.
/// This is alternative to [SizedBox] inside row/column such that
/// you don't have to know the main direction of the parent widget.
///
/// Any usage of [Gap] where the parent is not a Flex widget will result
/// into an error.
///
/// Examples:
///  1. Row                            |    2. Column
///    Row(                             |      Column(
///      children: [                    |        children: [
///        const Icon(Icons.home),      |        const Text('Hello'),
///        const Gap(10),               |        const Gap(10),
///        const Text('Hello World'),   |        const Text('World'),
///      ],                             |      ],
///    )                                |    )
///
///  2. ListView (A scrollable)
///    ListView(
///      children: [
///        const Text('Hello'),
///        const Gap(10),
///        const Text('World'),
///      ],
///    )
class Gap extends LeafRenderObjectWidget {
  /// Size of the gap.
  final double size;

  /// Creates Gap instance with given [Size].
  const Gap(this.size, {super.key})
      : assert(size >= 0 && size < double.infinity);

  @override
  RenderObject createRenderObject(BuildContext context) {
    // Get axis direction from a scrollable parent if any.
    final axisDirection = Scrollable.maybeOf(context)?.axisDirection;
    final direction =
        axisDirection != null ? axisDirectionToAxis(axisDirection) : null;
    return _RenderGap(size, direction);
  }

  @override
  // ignore: library_private_types_in_public_api
  void updateRenderObject(BuildContext context, _RenderGap renderObject) {
    // Get axis direction from a scrollable parent if any.
    final axisDirection = Scrollable.maybeOf(context)?.axisDirection;
    final direction =
        axisDirection != null ? axisDirectionToAxis(axisDirection) : null;
    renderObject
      ..gap = size
      ..direction = direction;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('size', size));
  }
}

/// Render object for [Gap] widget which renders it based on the flex parent.
class _RenderGap extends RenderBox {
  double _gap;

  double get gap => _gap;

  Axis? _direction;

  Axis? get direction => _direction;

  set direction(Axis? value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  set gap(double value) {
    if (_gap == value) return;
    _gap = value;
    markNeedsLayout();
  }

  _RenderGap(this._gap, this._direction);

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final parent = this.parent;
    if (parent is RenderFlex || direction != null) {
      final effectiveDirection =
          parent is RenderFlex ? parent.direction : direction;

      final size = Size(
        effectiveDirection == Axis.horizontal ? _gap : 0,
        effectiveDirection == Axis.vertical ? _gap : 0,
      );

      return constraints.constrain(size);
    }

    throw FlutterError('Gap widget can only be used inside a Flex widget.');
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _compute(
        Axis.horizontal, () => super.computeMinIntrinsicWidth(height));
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _compute(
        Axis.vertical, () => super.computeMinIntrinsicHeight(width));
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _compute(
        Axis.horizontal, () => super.computeMaxIntrinsicWidth(height));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _compute(
        Axis.vertical, () => super.computeMaxIntrinsicHeight(width));
  }

  double _compute(Axis axis, ValueGetter<double> compute) {
    final parent = this.parent;
    if ((parent is RenderFlex && parent.direction == axis) ||
        direction == axis) {
      return _gap;
    }
    return compute();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('gap', gap));
  }
}
