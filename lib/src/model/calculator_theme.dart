// Copyright 2022 Sudipta Karmakar. All rights reserved.

import 'package:flutter/material.dart';

/// Holds the color and typography values for the [DynamicCalculator].
class CalculatorTheme {
  /// The color to use when painting the line.
  final Color? borderColor;

  /// Width of the divider border, which is usually 1.0.
  final double borderWidth;

  /// Width of the divider border, which is usually 1.0.
  final double displayCalculatorRadius;

  /// The color of the display panel background.
  final Color? displayBackgroundColor;

  /// The background color of the expression area.
  final Color? expressionBackgroundColor;

  /// The background color of operator buttons.
  final Color? operatorColor;

  /// The background color of command buttons.
  final Color? commandColor;

  /// The background color of number buttons.
  final Color? numColor;

  /// The text style to use for the display panel.
  final TextStyle? displayStyle;

  /// The text style to use for the expression area.
  final TextStyle? expressionStyle;

  /// The text style to use for operator buttons.
  final TextStyle? operatorStyle;

  /// The text style to use for command buttons.
  final TextStyle? commandStyle;

  /// The text style to use for number buttons.
  final TextStyle? numStyle;

  const CalculatorTheme({
    this.displayBackgroundColor,
    this.borderWidth = 1.0,
    this.displayCalculatorRadius = 10,
    this.expressionBackgroundColor,
    this.borderColor,
    this.operatorColor,
    this.commandColor,
    this.numColor,
    this.displayStyle,
    this.expressionStyle,
    this.operatorStyle,
    this.commandStyle,
    this.numStyle,
  });
}
