// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: September 03, 2020

part of '../flutter_screwdriver.dart';

/// provides extensions for [Widget]
extension WidgetFS<T> on Widget {
  /// Displays [this] widget as a dialog on screen
  Future<T?> showAsDialog(
    BuildContext context, {
    bool useRootNavigator = false,
    ModalConfiguration configuration = const FadeScaleTransitionConfiguration(),
  }) {
    return showModal<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      configuration: configuration,
      builder: (context) => this,
    );
  }
}
