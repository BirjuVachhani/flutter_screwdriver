// Copyright © 2022 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: September 01, 2020

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Alias for closing the app by invoking [SystemNavigator.pop]
Future<void> closeApp({bool animated = true}) =>
    SystemNavigator.pop(animated: animated);

/// hides soft keyboard using platform channel
void hideKeyboard(BuildContext context) {
  if (!context.mounted) return;
  final currentFocus = FocusScope.of(context);
  SystemChannels.textInput.invokeMethod<dynamic>('TextInput.hide').ignore();
  if (currentFocus.hasFocus) {
    currentFocus.unfocus();
    currentFocus.focusedChild?.unfocus();
  }
}
