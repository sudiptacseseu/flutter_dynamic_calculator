// Copyright 2022 Sudipta Karmakar. All rights reserved.

import 'package:flutter_dynamic_calculator/src/view/calculator_display.dart';
import 'package:flutter_dynamic_calculator/src/view/calculator_expression.dart';
import 'package:intl/intl.dart';

/// Calculator
class Calculator {
  final CalcExpression _expression;
  final CalculatorDisplay _display;
  bool _operated = false;

  /// The [NumberFormat] used for display
  final NumberFormat numberFormat;

  /// Maximum number of digits on display.
  final int maximumDigits;

  /// Create a [Calculator] with [maximumDigits] is 10 and maximumFractionDigits of [numberFormat] is 6.
  Calculator({maximumDigits = 10})
      : this.numberFormat(
            NumberFormat()..maximumFractionDigits = 6, maximumDigits);

  /// Create a [Calculator].
  Calculator.numberFormat(this.numberFormat, this.maximumDigits)
      : _expression =
            CalcExpression(zeroDigit: numberFormat.symbols.ZERO_DIGIT),
        _display = CalculatorDisplay(numberFormat, maximumDigits);

  /// Display string
  get displayString => _display.string;

  /// Display value
  get displayValue => _display.value;

  /// Expression
  get expression => _expression.value;

  /// Set the value.
  void setValue(double val) {
    _display.setValue(val);
    _expression.setVal(_display);
  }

  /// Add a digit to the display.
  void addDigit(int digit) {
    if (!_display.validValue()) {
      return;
    }
    if (_expression.needClearDisplay()) {
      _display.clear();
    }
    if (_operated) {
      allClear();
    }
    _display.addDigit(digit);
    _expression.setVal(_display);
  }

  /// Add a decimal point.
  void addPoint() {
    if (!_display.validValue()) {
      return;
    }
    if (_expression.needClearDisplay()) {
      _display.clear();
    }
    if (_operated) {
      allClear();
    }
    _display.addPoint();
    _expression.setVal(_display);
  }

  /// Clear all entries.
  void allClear() {
    _expression.clear();
    _display.clear();
    _expression.setVal(_display);
    _operated = false;
  }

  /// Clear last entry.
  void clear() {
    _display.clear();
    _expression.setVal(_display);
  }

  /// Perform operations.
  void operate() {
    if (!_display.validValue()) {
      return;
    }
    if (_operated) {
      _expression.repeat(_display);
    } else {
      _display.setValue(_expression.operate().toDouble());
    }
    _operated = true;
  }

  /// Remove the last digit.
  void removeDigit() {
    if (_check()) return;
    _display.removeDigit();
    _expression.setVal(_display);
  }

  /// Set the operation. The [op] must be either +, -, ×, or ÷.
  void setOperator(String op) {
    if (_check()) return;
    _expression.setOperator(op);
    if (op == '+' || op == '-') {
      operate();
      _operated = false;
    }
  }

  /// Set a percent sign.
  void setPercent() {
    if (_check()) return;
    var string = _display.string + numberFormat.symbols.PERCENT;
    var val = _expression.setPercent(string, _display.value);
    _display.setValue(val);
  }

  /// Toggle between a plus sign and a minus sign.
  void toggleSign() {
    if (_check()) return;
    _display.toggleSign();
    _expression.setVal(_display);
  }

  ///
  bool _check() {
    if (!_display.validValue()) {
      return true;
    }
    if (_operated) {
      _expression.clear();
      _expression.setVal(_display);
      _operated = false;
    }
    return false;
  }
}
