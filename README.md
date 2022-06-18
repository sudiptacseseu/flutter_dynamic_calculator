# flutter_dynamic_calculator

A new flutter package to build dynamic calculator easily with full customization ability. It'll be helpful for making a custom keyboard or a bottom sheet modal calculator.

[![pub package](https://img.shields.io/pub/v/flutter_dynamic_calculator.svg)](https://pub.dartlang.org/packages/flutter_dynamic_calculator)


### Default style

<img src="https://github.com/sudiptacseseu/flutter_dynamic_calculator/blob/master/example/screenshot_1.png?raw=true" width="320px"/>

### With custom styles

<img src="https://github.com/sudiptacseseu/flutter_dynamic_calculator/blob/master/example/screenshot_2.png?raw=true" width="320px"/>

````dart
DynamicCalculator(
  theme: const CalculatorTheme(
    displayColor: Colors.black,
    displayStyle: const TextStyle(fontSize: 80, color: Colors.yellow),
    /*...*/
  ),
)
````

## Getting Started

To use this plugin, add `flutter_dynamic_calculator` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```yaml
dependencies:
 flutter_dynamic_calculator: 
```

Import the library in your file.

````dart
import 'package:flutter_dynamic_calculator/flutter_dynamic_calculator.dart';
````

See the `example` directory for a complete sample app using DynamicCalculator.
Or use the DynamicCalculator like below.

````dart
DynamicCalculator(
  value: 123.45,
  hideExpression: true,
  onChanged: (key, value, expression) {
    /*...*/
  },
  theme: const CalculatorTheme(
    displayColor: Colors.black,
    displayStyle: const TextStyle(fontSize: 80, color: Colors.yellow),
  ),
)
````