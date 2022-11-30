// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: September 03, 2020

part of flutter_screwdriver;

/// Represents a function that is responsible for disposing listeners.
typedef Disposable = void Function();

/// provides extensions on [TextEditingController]
extension TextEditingControllerFS on TextEditingController {
  /// Unlike [addListener], this only calls [block] when the [text]
  /// actually changes. This won't be invoked when the focus or selection of
  /// the text changes in [TextField] or [TextFormField].
  ///
  /// Returns [Disposable] function which can be called to
  /// dispose this listener.
  Disposable onChanged(void Function(String text) block) {
    var previousValue = text;
    void onChanged() {
      if (text != previousValue) {
        block(text);
      }
      previousValue = text;
    }

    addListener(onChanged);
    return () => removeListener(onChanged);
  }

  /// Unlike [addListener], this only calls [block] when the selection of
  /// [text] actually changes. This won't be invoked when the focus or text
  /// value of the [text] changes in [TextField] or [TextFormField].
  ///
  /// Returns [Disposable] function which can be called to
  /// dispose this listener.
  Disposable onSelectionChanged(void Function(TextSelection selection) block) {
    var previousValue = selection;
    void onSelectionChanged() {
      if (selection != previousValue) {
        block(selection);
      }
      previousValue = selection;
    }

    addListener(onSelectionChanged);
    return () => removeListener(onSelectionChanged);
  }

  /// Returns a stream of text changes.
  /// Note that as this is an extension, it will return a new stream object
  /// every time this method is called.
  /// Call this method once and store it in a variable for further use.
  Stream<String> textChanges() {
    final controller = StreamController<String>();
    onChanged((text) {
      if (controller.isClosed) return;
      controller.sink.add(text);
    });
    return controller.stream;
  }

  /// Returns a stream of text selection changes
  /// Note that as this is an extension, it will return a new stream object
  /// every time this method is called.
  /// Call this method once and store it in a variable for further use.
  Stream<TextSelection> selectionChanges() {
    final controller = StreamController<TextSelection>();
    onSelectionChanged((selection) {
      if (controller.isClosed) return;
      controller.sink.add(selection);
    });
    return controller.stream;
  }

  /// Returns trimmed [text]
  String get trimmed => text.trim();

  /// Returns true if the [text] is empty or only contains white-spaces
  bool get isBlank => text.trim().isEmpty;

  /// Returns true if the [text] is not empty or contains characters
  /// other than white-spaces.
  bool get isNotBlank => text.trim().isNotEmpty;

  /// Executes [block] function only when [text] is blank.
  void whenBlank(VoidCallback block) => onChanged((_) {
        if (isBlank) block();
      });
}
