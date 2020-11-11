# 📝 Examples 

```dart
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
```



```dart
'#FF4433'.toColor(); // returns Color object
context.theme; // short for Theme.of(context)
myConfirmationView.showAsDialog(context);
homeRoute.push(context); // short for Navigation.of(context).push(homeRoute);
closeApp(); // closes the app

Colors.red.hexString; // converts to hex string
Color(0xFF4433).toMaterialColor(); // converts given color to material color with standard shades
Color(0xFF4433).shade(300); // creates white based shades of given color
Colors.red.tweenTo(Colors.blue); // creates ColorTween
```



#### State and Context Extensions

Access common inherited widgets directly from state.

```dart
theme; // Short for Theme.of(context)
mediaQuery; // Short for MediaQuery.of(context)
focusScope; // Short for FocusScope.of(context)
navigator; // Short for Navigator.of(context)
hideKeyboard(); // hides soft input keyboard

context.theme;
context.mediaQuery;
context.focusScope;
context.navigator;
context.hideKeyboard();
```



#### TextEditingController

```dart
emailController.trimmed;
emailController.isBlank;
emailController.onChanged((value) => print(value));
emailController.onSelectionChanged((selection) => print(selection));
emailController.textChanges(); // Returns a Stream<String>
emailController.selectionChanges(); // Returns a Stream<TextSelection>
```



#### Routes

```dart
FadeScalePageRoute();
FadeThroughPageRoute();
SharedAxisPageRoute();
```



##### Hiding keyboard when clicked outside tap-able views

```dart
import 'package:flutter_screwdriver/flutter_screwdriver.dart';


HideKeyboard(
  MaterialApp(
    theme: ThemeData.light(),
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: MyWidget(),
    ),
  ),
);

```



##### Clearing focus when navigation happens (mainly to close keyboard if visible)

```dart
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

MaterialApp(
  theme: ThemeData.light(),
  debugShowCheckedModeBanner: false,
  navigatorObservers: [
    ClearFocusNavigatorObserver(),
  ],
  home: Scaffold(
    body: MyWidget(),
  ),
);
```



Checkout [documentation][docs]
