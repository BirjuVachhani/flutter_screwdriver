import 'package:flutter/widgets.dart';

/// Type definition for a function that returns a future.
typedef SetFutureFunction = Future<R> Function<R>(Future<R> future);

/// A builder function type for [AsyncLoadingBuilder] that takes the current
/// [BuildContext], a boolean indicating whether the widget is currently
/// loading, and a function to set a new future. The builder should return a
/// widget that represents the current state of the asynchronous operation.
typedef AsyncLoadingBuilderBuilder = Widget Function(
  BuildContext context,
  bool loading,
  SetFutureFunction setFuture,
);

/// A widget that builds itself based on the state of an asynchronous operation.
/// It uses a [FutureBuilder] to manage the state of the asynchronous operation
/// and provides a builder function that can be used to create the UI based on
/// the current state (loading, error, or success).
///
/// This widget is useful for scenarios where you want to display ephemeral
/// loading states. e.g. on buttons, where you want to show a loading indicator.
class AsyncLoadingBuilder extends StatefulWidget {
  /// An optional initial future to be used when the widget is first built.
  final Future<Object?>? initialFuture;

  /// A builder function that takes the current [BuildContext], a boolean
  /// indicating whether the widget is currently loading, and a function to
  /// set a new future. The builder should return a widget that represents
  /// the current state of the asynchronous operation.
  final AsyncLoadingBuilderBuilder builder;

  /// Creates an [AsyncLoadingBuilder] widget.
  const AsyncLoadingBuilder({
    super.key,
    this.initialFuture,
    required this.builder,
  });

  /// Returns the [AsyncLoadingBuilderState] of the nearest [AsyncLoadingBuilder] ancestor.
  static AsyncLoadingBuilderState<T>? maybeOf<T>(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<_AsyncInheritedState<T>>();
    return context.findAncestorStateOfType<AsyncLoadingBuilderState<T>>();
  }

  /// Returns the [AsyncLoadingBuilderState] of the nearest [AsyncLoadingBuilder] ancestor.
  static AsyncLoadingBuilderState<T> of<T>(BuildContext context) =>
      maybeOf<T>(context)!;

  @override
  State<AsyncLoadingBuilder> createState() => AsyncLoadingBuilderState._();
}

/// State for the [AsyncLoadingBuilder] widget.
class AsyncLoadingBuilderState<T> extends State<AsyncLoadingBuilder> {
  AsyncLoadingBuilderState._();

  late Future<Object?>? _future = widget.initialFuture;

  AsyncSnapshot<Object?>? _snapshot;

  /// The current future being observed by the builder.
  AsyncSnapshot<Object?>? get snapshot => _snapshot;

  /// The current state of the future.
  ConnectionState get state =>
      _snapshot?.connectionState ?? ConnectionState.none;

  /// Indicates whether the current state is loading.
  bool get isLoading => state == ConnectionState.waiting;

  /// Indicates whether the current state has completed.
  bool get hasError => _snapshot?.hasError ?? false;

  /// The error object if the current state has an error.
  Object? get error => _snapshot?.error;

  /// Indicates whether the current state has data.
  bool get hasData => _snapshot?.hasData ?? false;

  /// Indicates whether the current state is successful.
  bool get isSuccess => hasData && !hasError && state != ConnectionState.done;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object?>(
      future: _future,
      builder: (context, snapshot) {
        _snapshot = snapshot;
        final loading = snapshot.connectionState == ConnectionState.waiting;
        return _AsyncInheritedState(
          snapshot: snapshot,
          child: widget.builder(context, loading, setFuture),
        );
      },
    );
  }

  /// Sets a new future and rebuilds the widget.
  Future<R> setFuture<R>(Future<R> future) {
    _future = future;
    if (mounted) setState(() {});
    return future;
  }
}

/// Internal inherited widget to add auto observability to the [AsyncLoadingBuilder.maybeOf] and
/// [AsyncLoadingBuilder.of] calls..
class _AsyncInheritedState<T> extends InheritedWidget {
  final AsyncSnapshot<T> snapshot;

  const _AsyncInheritedState({required this.snapshot, required super.child});

  @override
  bool updateShouldNotify(covariant _AsyncInheritedState<T> oldWidget) =>
      snapshot != oldWidget.snapshot;
}
