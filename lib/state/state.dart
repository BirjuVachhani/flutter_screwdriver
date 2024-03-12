// Copyright © 2022 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: September 03, 2020

part of '../flutter_screwdriver.dart';

/// provides extensions for [State]
extension StateFS<T extends StatefulWidget> on State<T> {
  /// Short for `Theme.of(context)`.
  ThemeData get theme => Theme.of(context);

  /// Short for `Theme.of(context).colorScheme`.
  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  /// Short for `Theme.of(context).textTheme`.
  TextTheme get textTheme => Theme.of(context).textTheme;

  /// Short for `MediaQuery.of(context)`.
  MediaQueryData get mediaQuery => MediaQuery.of(context);

  /// Short for `FocusScope.of(context)`.
  FocusScopeNode get focusScope => FocusScope.of(context);

  /// Short for `Navigator.of(context)`.
  NavigatorState get navigator => Navigator.of(context);

  /// hides soft keyboard using platform channel
  void hideKeyboard() => helpers.hideKeyboard(context);
}
