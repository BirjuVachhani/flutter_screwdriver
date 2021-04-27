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
    WidgetsBinding.instance?.addObserver(_listener);
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
    WidgetsBinding.instance?.removeObserver(_listener);
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
