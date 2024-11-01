/*
 * Copyright © 2024 Birju Vachhani. All rights reserved.
 * Use of this source code is governed by a BSD 3-Clause License that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Represents the mode of ticking. It can be millisecond, second, minute, or hour.
/// This is used to determine when to rebuild the widget.
/// For example, if the mode is set to [TickingMode.second], the widget will rebuild
/// every second.
/// If the mode is set to [TickingMode.minute], the widget will rebuild every minute.
/// If the mode is set to [TickingMode.hour], the widget will rebuild every hour.
/// If the mode is set to [TickingMode.millisecond], the widget will rebuild every millisecond.
/// The default mode is [TickingMode.second].
/// The mode can be changed at runtime using [TickingInterface.setMode] method.
@Deprecated('This is moved to another package. Please use the `ticking_widget` package instead. This package will be removed in the next major version.')
enum TickingMode {
  /// Represents the mode when the widget should rebuild every millisecond.
  /// This is the most frequent mode and should be used with caution.
  /// This mode is not recommended for most use cases.
  millisecond,

  /// Represents the mode when the widget should rebuild every second.
  /// This is the most common mode and is the default mode.
  /// This mode is recommended for most use cases.
  /// This is useful for building stopwatches and countdowns.
  second,

  /// Represents the mode when the widget should rebuild every minute.
  /// This mode is recommended for use cases where the widget needs to be
  /// updated every minute.
  /// This is useful for building clocks and timers.
  minute,

  /// Represents the mode when the widget should rebuild every hour.
  /// This mode is recommended for use cases where the widget needs to be
  /// updated every hour.
  /// This is useful for building clocks and timers.
  hour;

  /// Returns true if the mode is [TickingMode.millisecond].
  bool get isMillisecond => this == TickingMode.millisecond;

  /// Returns true if the mode is [TickingMode.second].
  bool get isSecond => this == TickingMode.second;

  /// Returns true if the mode is [TickingMode.minute].
  bool get isMinute => this == TickingMode.minute;

  /// Returns true if the mode is [TickingMode.hour].
  bool get isHour => this == TickingMode.hour;
}

/// A builder function type that is used to build the ticking widget.
@Deprecated('This is moved to another package. Please use the `ticking_widget` package instead. This package will be removed in the next major version.')
typedef TickingWidgetBuilder = Widget Function(
    BuildContext context, DateTime currentTime, Widget? child);

/// A widget that rebuilds itself at a given interval.
/// This widget is useful for building widgets that need to be updated at a given interval.
/// For example, this widget can be used to build clocks, timers, stopwatches, and countdowns.
/// This widget can be used to build any widget that needs to be updated at a given interval.
/// Example:
/// ```dart
/// TickingWidget(
///  mode: TickingMode.second,
///  builder: (context, currentTime, child) {
///     // This widget will rebuild every second.
///     return Text(currentTime.toString());
///   },
///  ),
///  ```
@Deprecated('This is moved to another package. Please use the `ticking_widget` package instead. This package will be removed in the next major version.')
class TickingWidget extends StatefulWidget {
  /// The builder function that is used to build the ticking widget.
  /// This function is called every time the widget needs to be rebuilt.
  ///
  /// The [currentTime] parameter is the current time when the widget is
  /// being rebuilt.
  ///
  /// The [child] parameter is the child widget that is passed to
  /// the [TickingWidget].
  ///
  /// If the [builder] is not provided, the [child] must be provided.
  ///
  /// If both [builder] and [child] are provided, the [builder] will be used
  /// and the [child] will be passed to the [builder] function.
  final TickingWidgetBuilder? builder;

  /// The child widget that is passed to the [TickingWidget].
  /// If the [builder] is not provided, the [child] must be provided.
  /// If both [builder] and [child] are provided, the [builder] will be used
  /// and the [child] will be passed to the [builder] function.
  final Widget? child;

  /// The mode of ticking. It can be millisecond, second, minute, or hour.
  /// This is used to determine when to rebuild the widget.
  /// For example, if the mode is set to [TickingMode.second],
  /// the widget will rebuild every second.
  final TickingMode mode;

  /// If true, the ticker will start automatically when the widget is initialized.
  /// If false, the ticker will not start automatically when the widget is initialized.
  /// The default value is true.
  /// This can be changed at runtime using [TickingInterface.startTicker] and
  /// [TickingInterface.stopTicker] methods.
  ///
  /// Any child widget of this widget can access the [TickingInterface] using
  /// [TickingWidget.of] method with appropriate context.
  final bool autoStart;

  /// Creates a new [TickingWidget].
  const TickingWidget({
    super.key,
    this.builder,
    this.child,
    required this.mode,
    this.autoStart = true,
  }) : assert(builder != null || child != null,
            'Either builder or child must be provided');

  /// Returns the [TickingInterface] of the nearest [TickingWidget] ancestor.
  /// This method can be used to access the [TickingInterface] of the nearest
  /// [TickingWidget] ancestor to control the ticking of the widget.
  /// Example:
  /// ```dart
  /// final ticking = TickingWidget.of(context);
  /// ticking.startTicker();
  /// ```
  /// This method throws an error if the [TickingInterface] is not found in the
  /// ancestor tree.
  static TickingInterface of(BuildContext context) =>
      context.findAncestorStateOfType<_TickingWidgetState>()!;

  /// Returns the [TickingInterface] of the nearest [TickingWidget] ancestor.
  /// This method can be used to access the [TickingInterface] of the nearest
  /// [TickingWidget] ancestor to control the ticking of the widget.
  /// Example:
  /// ```dart
  /// final ticking = TickingWidget.maybeOf(context);
  /// ticking?.startTicker();
  /// ```
  /// This method returns null if the [TickingInterface] is not found in the
  /// ancestor tree.
  static TickingInterface? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_TickingWidgetState>();

  @override
  State<TickingWidget> createState() => _TickingWidgetState();
}

class _TickingWidgetState extends State<TickingWidget>
    with SingleTickerProviderStateMixin, TickingStateMixin {
  @override
  void initState() {
    // set the autoStart and mode from the widget.
    autoStart = widget.autoStart;
    mode = widget.mode;

    // It is important to call super.initState() after setting the autoStart
    // and mode. This is because the initState method of the mixin class
    // uses these values.
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TickingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode) mode = widget.mode;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) =>
            widget.builder?.call(context, currentTime, widget.child) ??
            widget.child!);
  }
}

/// A mixin class that provides the ticking functionality to the widget.
/// This mixin class can be used with the [State] class to provide the ticking
/// functionality to the widget.
///
/// This will automatically start the ticker when the widget is initialized
/// based on the [autoStart] property.
///
/// This will automatically rebuild the widget at the given interval based on
/// the [mode] property.
///
/// To use this mixin, the [State] class must also use the [TickerProvider]
/// mixin via the [SingleTickerProviderStateMixin] or [TickerProviderStateMixin].
///
/// Note that [SingleTickingStateMixin] must be defined after [TickerProvider]
/// in the mixin list, otherwise, it will throw a compile-time error.
@Deprecated('This is moved to another package. Please use the `ticking_widget` package instead. This package will be removed in the next major version.')
mixin TickingStateMixin<T extends StatefulWidget>
    on State<T>, TickerProvider
    implements TickingInterface {
  @override
  late Ticker ticker;

  @override
  late DateTime currentTime;

  @override
  Duration elapsed = Duration.zero;

  @override
  TickingMode mode = TickingMode.second;

  /// If true, the ticker will start automatically when the widget is initialized.
  /// If this is set to false, the ticker will not start automatically when the
  /// widget is initialized. To start the ticker, use the [startTicker] method.
  ///
  /// Alternatively to start the ticker from descendant widgets, use the
  /// [TickingInterface.startTicker] method.
  /// Example:
  /// ```dart
  /// final ticking = TickingWidget.of(context);
  /// ticking.startTicker();
  /// ```
  /// The default value is true.
  bool autoStart = true;

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
    ticker = createTicker(onTick);
    if (autoStart) ticker.start();
  }

  /// Called every time the ticker ticks. Determines when to rebuild the widget.
  void onTick(Duration elapsed) {
    this.elapsed = elapsed;
    final newTime = DateTime.now();
    // rebuild only if change is detected on given mode instead of every frame.
    switch (mode) {
      case TickingMode.millisecond
          when currentTime.millisecond != newTime.millisecond:
      case TickingMode.second when currentTime.second != newTime.second:
      case TickingMode.minute when currentTime.minute != newTime.minute:
      case TickingMode.hour when currentTime.hour != newTime.hour:
        if (mounted) setState(() => currentTime = newTime);
      default:
        // Do nothing!
        break;
    }
  }

  @override
  void startTicker() {
    elapsed = Duration.zero;
    ticker.start();
  }

  @override
  void stopTicker() => ticker.stop();

  @override
  void setMode(TickingMode mode) {
    this.mode = mode;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }
}

/// A ticking interface that provides methods to control the ticking of the widget.
@Deprecated('This is moved to another package. Please use the `ticking_widget` package instead. This package will be removed in the next major version.')
abstract interface class TickingInterface {
  /// The ticker that is used to control the ticking of the widget.
  abstract Ticker ticker;

  /// The current time when the widget is being rebuilt.
  late DateTime currentTime;

  /// The mode of ticking. It can be millisecond, second, minute, or hour.
  /// This is used to determine when to rebuild the widget.
  ///
  /// For example, if the mode is set to [TickingMode.second],
  /// the widget will rebuild every second.
  abstract TickingMode mode;

  /// Duration elapsed since the ticker started.
  /// Resets to zero when ticker is started.
  abstract Duration elapsed;

  /// Starts the ticker.
  void startTicker();

  /// Stops the ticker.
  void stopTicker();

  /// Sets the mode of the ticker to the given [TickingMode].
  void setMode(TickingMode mode);
}
