/*
 * Copyright © 2023 Birju Vachhani. All rights reserved.
 * Use of this source code is governed by a BSD 3-Clause License that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Provides a widget that runs a callback after the first frame is rendered.
class PostFrame extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// The callback to be executed after the first frame is rendered.
  final FrameCallback onPostFrame;

  /// Creates a new [PostFrame] instance.
  const PostFrame({
    super.key,
    required this.child,
    required this.onPostFrame,
  });

  @override
  State<PostFrame> createState() => _PostFrameState();
}

class _PostFrameState extends State<PostFrame> with PostFrameCallbackMixin {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void onPostFrame(Duration duration) => widget.onPostFrame(duration);
}

/// Provides a mixin that runs a callback after the first frame is rendered.
mixin PostFrameCallbackMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((duration) => onPostFrame(duration));
  }

  /// The callback to be executed after the first frame is rendered.
  void onPostFrame(Duration duration);
}
