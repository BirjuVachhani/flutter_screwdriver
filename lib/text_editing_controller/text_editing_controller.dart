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
// Created Date: September 03, 2020

part of flutter_screwdriver;

/// provides extensions on [TextEditingController]
extension TextEditingControllerFS on TextEditingController {
  /// Unlike [addListener], this only calls [block] when the [text]
  /// actually changes. This won't be invoked when the focus or selection of
  /// the text changes in [TextField] or [TextFormField].
  void onChanged(void block(String text)) {
    var previousValue = text;
    addListener(() {
      if (text != previousValue) {
        block(text);
      }
      previousValue = text;
    });
  }

  /// Unlike [addListener], this only calls [block] when the selection of
  /// [text] actually changes. This won't be invoked when the focus or text
  /// value of the [text] changes in [TextField] or [TextFormField].
  void onSelectionChanged(void block(TextSelection selection)) {
    var previousValue = selection;
    addListener(() {
      if (selection != previousValue) {
        block(selection);
      }
      previousValue = selection;
    });
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
