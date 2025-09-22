![Banner](https://raw.githubusercontent.com/BirjuVachhani/flutter_screwdriver/main/.github/banner.png?raw=true)


# Flutter Screwdriver

A flutter package aiming to provide useful extensions and helper functions to ease and speed up development.

[![Tests](https://github.com/BirjuVachhani/screwdriver/workflows/Tests/badge.svg?branch=master)](https://github.com/BirjuVachhani/screwdriver/actions) [![Code Quality](https://github.com/BirjuVachhani/flutter_screwdriver/workflows/Code%20Quality/badge.svg?branch=master)](https://github.com/BirjuVachhani/flutter_screwdriver/actions)



- 📋  Well Documented
- 🧪  Well Tested
- 👌  Follows Code Quality Guidelines
- 🦾  Production Ready
- 🛹  Easy to Use
- 🛡  Sound Null Safety ️



To checkout all the available extensions, helper functions & classes, see [documentation][docs].

## Stats

<!---stats_start-->
```yaml  
Extensions:                    47
Helper Classes:                16
Helper Functions & Getters:    2
Typedefs:                      6
Mixins:                        3
```

> *Last Updated: Mon, Sep 22, 2025 - 09:09 AM*

<!---stats_end-->

*Stats auto generated using [Github Workflow](https://github.com/BirjuVachhani/screwdriver/blob/main/.github/workflows/stats.yaml).

### Checkout the [Playground](https://birjuvachhani.github.io/flutter_screwdriver/) for available helper widgets.

## Installation

1. Add as a dependency in your project's `pub spec.yaml`

```yaml
dependencies:
  flutter_screwdriver: <latest_version>
```

2. Import library into your code.

```dart
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
```



A Glimpse of **Flutter Screwdriver**

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



## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/BirjuVachhani/flutter_screwdriver/issues
[docs]: https://pub.dev/documentation/flutter_screwdriver/latest/



#### Liked Flutter Screwdriver?

Show some love and support by starring the [repository](https://github.com/birjuvachhani/flutter_screwdriver).

Or You can

<a href="https://www.buymeacoffee.com/birjuvachhani" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-blue.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>




## License

```
Copyright (c) 2020, Birju Vachhani
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
