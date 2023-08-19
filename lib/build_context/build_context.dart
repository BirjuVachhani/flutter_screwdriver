// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: September 02, 2020

part of flutter_screwdriver;

/// provides extension to get a dependency from provider
extension ContextExtension on BuildContext {
  /// Short for `Theme.of(context)`.
  ThemeData get theme => Theme.of(this);

  /// Short for `Theme.of(context).textTheme`.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Short for `Theme.of(context).colorScheme`.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Short for `MediaQuery.of(context)`.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Short for `FocusScope.of(context)`.
  FocusScopeNode get focusScope => FocusScope.of(this);

  /// Short for `Navigator.of(context)`.
  NavigatorState get navigator => Navigator.of(this);

  /// hides soft keyboard using platform channel
  void hideKeyboard() => helpers.hideKeyboard(this);
}
