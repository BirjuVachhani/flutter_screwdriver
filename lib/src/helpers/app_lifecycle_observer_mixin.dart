// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause License that can be
// found in the LICENSE file.

// Author: Birju Vachhani
// Created Date: April 27, 2021

import 'package:flutter/widgets.dart';

/// Allows to observe app lifecycle without any boilerplate code.
/// It registers a listener to receive lifecycle events and auto disposes it
/// when the widget is disposed.
@optionalTypeArgs
mixin AppLifecycleObserver<T extends StatefulWidget> on State<T> {
  late _AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = _AppLifecycleListener(this);
    WidgetsBinding.instance.addObserver(_listener);
  }

  /// Called when app lifecycle state is changed to [AppLifecycleState.resumed]
  void onResume() {}

  /// Called when app lifecycle state is changed to [AppLifecycleState.paused]
  void onPause() {}

  /// Called when app lifecycle state is changed to [AppLifecycleState.detached]
  void onDetach() {}

  /// Called when app lifecycle state is changed to [AppLifecycleState.inactive]
  void onInactive() {}

  /// Called when app lifecycle state changes.
  /// [state] is the current state of the app.
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_listener);
    super.dispose();
  }
}

/// Internal implementation of [WidgetsBindingObserver] that invokes methods
/// on [AppLifecycleObserver] whenever app lifecycle state is changed.
class _AppLifecycleListener extends WidgetsBindingObserver {
  final AppLifecycleObserver _observer;

  _AppLifecycleListener(this._observer);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _observer.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _observer.onResume();
        break;
      case AppLifecycleState.inactive:
        _observer.onInactive();
        break;
      case AppLifecycleState.paused:
        _observer.onPause();
        break;
      case AppLifecycleState.detached:
        _observer.onDetach();
        break;
    }
  }
}
