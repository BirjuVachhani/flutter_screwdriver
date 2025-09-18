/*
 * Copyright © 2025 Birju Vachhani. All rights reserved.
 * Use of this source code is governed by a BSD 3-Clause License that can be
 * found in the LICENSE file.
 */

import 'package:flutter/widgets.dart';

import 'hoverable.dart';

/// A [WidgetSpan] that represents a link with hover effects and tap handling.
///
/// It can be used to create clickable text spans with a hover style and
/// optional background decoration. This allows easy and clean implementation of
/// links within rich text widgets.
///
/// The [LinkSpan] widget provides various customization options such as
/// text [style], [hoverStyle], [background] decoration, [padding], animation [duration],
/// and curve. It also supports optional [prefix] and [suffix] widgets that can be
/// displayed before and after the text respectively.
///
/// Example usage:
///
/// ```dart
/// Text.rich(
///   TextSpan(
///     text: 'By signing up, you agree to our ',
///     children: [
///       LinkSpan(
///         onTap: () => launchUrlString('https://example.com/terms'),
///         text: 'Terms of Service',
///         style: TextStyle(color: Colors.blue,
///         hoverStyle: TextStyle(decoration: TextDecoration.underline),
///       ),
///       TextSpan(text: ' and '),
///       LinkSpan(
///       onTap: () => launchUrlString('https://example.com/privacy'),
///       text: 'Privacy Policy',
///       style: TextStyle(color: Colors.blue),
///       hoverStyle: TextStyle(decoration: TextDecoration.underline),
///     ),
///   ],
/// ),
/// ```
///
/// This will create a text span with two clickable links that change style on hover.
class LinkSpan extends WidgetSpan {
  /// The style to apply to the text when not hovering.
  final TextStyle? hoverStyle;

  /// Callback function that is called when the link is tapped.
  final VoidCallback? onTap;

  /// The text to display in the link span.
  final String text;

  /// Optional background decoration for the link span.
  ///
  /// If [hoverBackground] is not provided, this will be used for both
  /// normal and hovered states.
  ///
  /// If neither [background] nor [hoverBackground] is provided, no background
  /// decoration will be applied.
  ///
  /// This is useful when you want to apply a background style. e.g. color highlight
  final Decoration? background;

  /// Optional background decoration for the link span in hovered state.
  final Decoration? hoverBackground;

  /// The cursor to display when hovering over the link span.
  final MouseCursor? cursor;

  /// Foreground color of the text and/or icon in the link span when not hovered.
  ///
  /// This is useful when you want to apply a different color on hover for both
  /// text and icons(prefix/suffix).
  final Color? color;

  /// Foreground color of the text and/or icon in the link span when hovered.
  ///
  /// If not provided, it defaults to [color].
  /// This is useful when you want to apply a different color on hover for both
  /// text and icons(prefix/suffix).
  final Color? hoverColor;

  /// The padding around the link span.
  final EdgeInsets? padding;

  /// The duration of the hover animation.
  ///
  /// If set to [Duration.zero], no animation will be applied and animation mechanism
  /// will be skipped.
  final Duration duration;

  /// The curve of the hover animation.
  ///
  /// This is ignored if [duration] is set to [Duration.zero].
  /// Defaults to [Curves.linear].
  final Curve curve;

  /// An optional widget to display before the text.
  /// This can be used to add an icon or any other widget before the text.
  final Widget? prefix;

  /// An optional widget to display after the text.
  /// This can be used to add an icon or any other widget after the text.
  final Widget? suffix;

  /// Creates a [LinkSpan] with the given parameters.
  const LinkSpan({
    super.style,
    this.hoverStyle,
    this.onTap,
    required this.text,
    this.background,
    this.hoverBackground,
    this.cursor,
    this.color,
    this.hoverColor,
    this.padding,
    this.duration = Duration.zero,
    this.curve = Curves.linear,
    super.alignment = PlaceholderAlignment.baseline,
    super.baseline = TextBaseline.alphabetic,
    this.prefix,
    this.suffix,
  }) : super(child: const SizedBox.shrink());

  @override
  Widget get child => _buildChild();

  Widget _buildChild() {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Hoverable(
        cursor: cursor ?? SystemMouseCursors.click,
        builder: (context, hovering, child) {
          final style = TextStyle(
            color: hovering ? hoverColor ?? color : color,
            decorationColor: hovering ? hoverColor ?? color : null,
          );

          Widget child = Text(
            text,
            style: hovering ? super.style?.merge(hoverStyle) : super.style,
          );

          if (prefix != null || suffix != null) {
            child = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefix != null) prefix!,
                child,
                if (suffix != null) suffix!,
              ],
            );
          }

          if (duration == Duration.zero) {
            // no animation
            return DefaultTextStyle.merge(
              style: style,
              child: IconTheme.merge(
                data: IconThemeData(
                  color: hovering ? hoverColor : color,
                ),
                child: Container(
                  padding: padding ?? EdgeInsets.zero,
                  decoration: hovering ? hoverBackground ?? background : background,
                  child: child,
                ),
              ),
            );
          }

          return AnimatedDefaultTextStyle(
            duration: duration,
            curve: curve,
            style: DefaultTextStyle.of(context).style.merge(style),
            child: IconTheme.merge(
              data: IconThemeData(
                color: hovering ? hoverColor : color,
              ),
              child: AnimatedContainer(
                duration: duration,
                curve: curve,
                padding: padding ?? EdgeInsets.zero,
                decoration: hovering ? hoverBackground ?? background : background,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
