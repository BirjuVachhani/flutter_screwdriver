## 3.3.0

- [Deprecation] `TickingWidget` and `TickingStateMixin` are deprecated in favor of separate
  package: [ticking_widget](https://pub.dev/packages/ticking_widget). This will be removed in the next major version.
- Fix lint warnings.
- Fix `Gap` widget crash when used in non-scrollable parent.
- Fix deprecations for color extensions.
- Improve tests and coverage.
- Add `AsyncLoadingBuilder` widget for handling isolated async loading states.
- Add `LinkSpan` for clickable text spans.
- Fix `VerticalAffinity` not using directionality correctly.
- Refactor `VerticalAffinity` and `HorizontalAffinity` to use new spacing param from `Flex` widget.
- Upgrade dev dependencies.

## 3.2.0

- Add `TickingWidget` for creating widgets that need to update on a regular interval.
- Add `TickingStateMixin` for creating stateful widgets that need to update on a regular interval.

## 3.1.0

- Add `Hoverable` widget for reacting to hover events in an easy way.
- Add missing `AppLifecycleState.hidden` introduced in Flutter 3.13.
- Add more BuildContext extensions: `colorScheme` and `textTheme`.
- Add more state extensions: `colorScheme` and `textTheme`.
- Add `DirectionalAffinity`, `VerticalAffinity` and `HorizontalAffinity` widgets.

## 3.0.0

- Upgrade to Dart 3 and Flutter 3.10.0.

## 2.1.0

- Added `AppLifecycleObserver` helper mixin.
- Added `tweenTo` and `tweenFrom` extensions for `int` and `double`.
- Added extensions for `Brightness`.
- Added brightness related extensions for `Color`.
- Added globalPaintBounds extension for `GlobalKey`.
- Fixed `hexString` extension for `Color`. It includes opacity in the hex string now.
- Added `Hoverable` widget for reacting to hover events in an easy way.
- Added `Gap`|`Space` widget for painless creation of gaps between widgets with flex parents such as row, column,
  scrollable.
- Upgraded dependencies.

## 2.0.0

- Migrated to null safety

## 1.0.0

- Initial Release
