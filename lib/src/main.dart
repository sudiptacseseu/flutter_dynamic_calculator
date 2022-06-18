import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_calculator/src/model/calculator_theme.dart';
import 'package:flutter_grid_item/flutter_grid_item.dart';
import 'package:intl/intl.dart' as intl;
import 'controller/calculator_controller.dart';

/// Signature for callbacks that report that the [DynamicCalculator] value has changed.
typedef CalcChanged = void Function(
    String? key, double? value, String? expression);

/// DynamicCalculator
///
/// {@tool sample}
///
/// This example shows a simple [DynamicCalculator].
///
/// ```dart
/// DynamicCalculator(
///   value: 123.45,
///   hideExpression: true,
///   onChanged: (key, value, expression) {
///     /*...*/
///   },
///   theme: const CalculatorThemeData(
///     displayColor: Colors.black,
///     displayStyle: const TextStyle(fontSize: 80, color: Colors.yellow),
///   ),
/// )
/// ```
/// {@end-tool}
///
class DynamicCalculator extends StatefulWidget {
  /// Visual properties for this widget.
  final CalculatorTheme? theme;

  /// Whether to show surrounding borders.
  final bool hideSurroundingBorder;

  /// Whether to show expression area.
  final bool hideExpression;

  /// Whether to show calculator display.
  final bool? showCalculatorDisplay;

  /// The value currently displayed on this calculator.
  final double value;

  /// Called when the button is tapped or the value is changed.
  final CalcChanged? onChanged;

  /// Called when the display area is tapped.
  final Function(double?, TapDownDetails)? onTappedDisplay;

  /// The [NumberFormat] used for display
  final intl.NumberFormat? numberFormat;

  /// Maximum number of digits on display.
  final int maximumDigits;

  /// True if this widget will be selected as the initial focus when no other
  /// node in its scope is currently focused.
  final bool autofocus;

  /// An optional focus node to use as the focus node for this widget.
  final FocusNode? focusNode;

  /// Controller for calculator.
  final CalculatorController? controller;

  const DynamicCalculator({
    Key? key,
    this.theme,
    this.hideExpression = false,
    this.showCalculatorDisplay = false,
    this.value = 0,
    this.onChanged,
    this.onTappedDisplay,
    this.numberFormat,
    this.maximumDigits = 10,
    this.hideSurroundingBorder = false,
    this.autofocus = false,
    this.focusNode,
    this.controller,
  }) : super(key: key);

  @override
  DynamicCalculatorState createState() => DynamicCalculatorState();
}

class DynamicCalculatorState extends State<DynamicCalculator> {
  late CalculatorController _controller;
  String? _acLabel;

  final List<String?> _nums = List.filled(10, '', growable: false);
  final _baseStyle = const TextStyle(fontSize: 18);

  FocusNode get _focusNode => widget.focusNode ?? FocusNode();

  /// This allows a value of type T or T?
  /// to be treated as a value of type T?.
  T? _ambiguate<T>(T? value) => value;

  void _handleKeyEvent(int row, int col) {
    final renderObj = context.findRenderObject();
    if (renderObj is! RenderBox) return;
    final cellW = renderObj.size.width / 4;
    final cellH = renderObj.size.width / 4;
    final pos = renderObj.localToGlobal(
        Offset(cellW * col + cellW / 2, cellH * (row + 1) + cellH / 2));
    _ambiguate(GestureBinding.instance)!
      ..handlePointerEvent(PointerDownEvent(position: pos))
      ..handlePointerEvent(PointerUpEvent(position: pos));
  }

  void _initController() {
    final controller = widget.controller;
    if (controller == null) {
      if (widget.numberFormat == null) {
        var myLocale = Localizations.localeOf(context);
        var nf = intl.NumberFormat.decimalPattern(myLocale.toLanguageTag())
          ..maximumFractionDigits = 6;
        _controller =
            CalculatorController.numberFormat(nf, widget.maximumDigits);
      } else {
        _controller = CalculatorController.numberFormat(
            widget.numberFormat!, widget.maximumDigits);
      }
    } else {
      _controller = controller;
    }
    _controller.addListener(_didChangeCalcValue);
  }

  @override
  void didChangeDependencies() {
    _initController();
    for (var i = 0; i < 10; i++) {
      _nums[i] = _controller.numberFormat.format(i);
    }
    _controller.allClear();
    _controller.setValue(widget.value);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(DynamicCalculator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller!.removeListener(_didChangeCalcValue);
      _initController();
    }
  }

  @override
  Widget build(BuildContext context) {
    var metaKey = false;
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          return KeyEventResult.ignored;
        }
        if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
            event.logicalKey == LogicalKeyboardKey.shiftRight) {
          return KeyEventResult.ignored;
        }
        if (event.logicalKey == LogicalKeyboardKey.metaLeft ||
            event.logicalKey == LogicalKeyboardKey.metaRight ||
            event.logicalKey == LogicalKeyboardKey.controlLeft ||
            event.logicalKey == LogicalKeyboardKey.controlRight) {
          metaKey = event is KeyDownEvent;
          return KeyEventResult.ignored;
        }
        if (event is KeyUpEvent) {
          return KeyEventResult.ignored;
        }
        if (metaKey) {
          if (event.logicalKey == LogicalKeyboardKey.keyC) {
            final data = ClipboardData(text: _controller.value.toString());
            Clipboard.setData(data);
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.keyV) {
            Clipboard.getData('text/plain').then((value) {
              final val = double.tryParse(value?.text ?? '');
              if (val != null) {
                _controller.setValue(val);
              }
            });
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        }
        if (event.logicalKey == LogicalKeyboardKey.keyC) {
          _handleKeyEvent(0, 0);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.delete ||
            event.logicalKey == LogicalKeyboardKey.backspace) {
          _handleKeyEvent(0, 1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.percent) {
          _handleKeyEvent(0, 2);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.slash ||
            event.logicalKey == LogicalKeyboardKey.numpadDivide) {
          _handleKeyEvent(0, 3);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.asterisk ||
            event.logicalKey == LogicalKeyboardKey.numpadMultiply) {
          _handleKeyEvent(1, 3);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.minus ||
            event.logicalKey == LogicalKeyboardKey.numpadSubtract) {
          _handleKeyEvent(2, 3);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.equal ||
            event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter ||
            event.logicalKey == LogicalKeyboardKey.numpadEqual) {
          _handleKeyEvent(4, 3);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.add ||
            event.logicalKey == LogicalKeyboardKey.numpadAdd) {
          _handleKeyEvent(3, 3);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.period ||
            event.logicalKey == LogicalKeyboardKey.comma ||
            event.logicalKey == LogicalKeyboardKey.numpadDecimal) {
          _handleKeyEvent(4, 1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit0 ||
            event.logicalKey == LogicalKeyboardKey.numpad0) {
          _handleKeyEvent(4, 0);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit1 ||
            event.logicalKey == LogicalKeyboardKey.numpad1) {
          _handleKeyEvent(3, 0);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit2 ||
            event.logicalKey == LogicalKeyboardKey.numpad2) {
          _handleKeyEvent(3, 1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit3 ||
            event.logicalKey == LogicalKeyboardKey.numpad3) {
          _handleKeyEvent(3, 2);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit4 ||
            event.logicalKey == LogicalKeyboardKey.numpad4) {
          _handleKeyEvent(2, 0);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit5 ||
            event.logicalKey == LogicalKeyboardKey.numpad5) {
          _handleKeyEvent(2, 1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit6 ||
            event.logicalKey == LogicalKeyboardKey.numpad6) {
          _handleKeyEvent(2, 2);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit7 ||
            event.logicalKey == LogicalKeyboardKey.numpad7) {
          _handleKeyEvent(1, 0);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit8 ||
            event.logicalKey == LogicalKeyboardKey.numpad8) {
          _handleKeyEvent(1, 1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit9 ||
            event.logicalKey == LogicalKeyboardKey.numpad9) {
          _handleKeyEvent(1, 2);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      descendantsAreFocusable: false,
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
        },
        child: Column(children: <Widget>[
          Visibility(
            visible: widget.showCalculatorDisplay!,
            child: Expanded(
              child: _CalcDisplay(
                displayCalculatorRadius: widget.theme!.displayCalculatorRadius,
                hideSurroundingBorder: widget.hideSurroundingBorder,
                hideExpression: widget.hideExpression,
                onTappedDisplay: (a, b) {
                  _focusNode.requestFocus();
                  widget.onTappedDisplay?.call(a, b);
                },
                theme: widget.theme,
                controller: _controller,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            flex: 5,
            child: _getGridItems(),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_didChangeCalcValue);
    super.dispose();
  }

  void _didChangeCalcValue() {
    if (_acLabel == _controller.acLabel) return;
    setState(() {
      _acLabel = _controller.acLabel;
    });
  }

  Widget _getGridItems() {
    return GridItem(
      textStyle:
          _baseStyle.copyWith(color: Theme.of(context).textTheme.button?.color),
      borderColor: widget.theme?.borderColor ?? Theme.of(context).dividerColor,
      textDirection: TextDirection.ltr,
      hideSurroundingBorder: widget.hideSurroundingBorder,
      borderWidth: widget.theme?.borderWidth ?? 0,
      onPressed: (dynamic val) {
        _focusNode.requestFocus();
        switch (val) {
          case '⌫':
            _controller.removeDigit();
            break;
          case '00':
            _controller.addDoubleZero(0);
            break;
          case '+':
            _controller.setAdditionOp();
            break;
          case '-':
            _controller.setSubtractionOp();
            break;
          case '×':
            _controller.setMultiplicationOp();
            break;
          case '÷':
            _controller.setDivisionOp();
            break;
          case '=':
            _controller.operate();
            break;
          case 'AC':
            _controller.allClear();
            break;
          case 'C':
            _controller.clear();
            break;
          default:
            if (val == _controller.numberFormat.symbols.DECIMAL_SEP) {
              _controller.addPoint();
            }
            if (val == _controller.numberFormat.symbols.PERCENT) {
              _controller.setPercent();
            }
            if (_nums.contains(val)) {
              _controller.addDigit(_nums.indexOf(val));
            }
        }
        if (widget.onChanged != null) {
          widget.onChanged!(val, _controller.value, _controller.expression);
        }
      },
      items: _getGrids(),
    );
  }

  List<List<Grid>> _getGrids() {
    return [
      [_acLabel, '⌫', _controller.numberFormat.symbols.PERCENT, '÷'],
      [_nums[7], _nums[8], _nums[9], '×'],
      [_nums[4], _nums[5], _nums[6], '-'],
      [_nums[1], _nums[2], _nums[3], '+'],
      [_nums[0], _controller.numberFormat.symbols.DECIMAL_SEP, '00', '='],
    ].map((items) {
      return items.map((title) {
        Color color =
            widget.theme?.numColor ?? Theme.of(context).scaffoldBackgroundColor;
        TextStyle? style = widget.theme?.numStyle;
        if (title == '=') {
          color = widget.theme?.operatorColor ?? Theme.of(context).primaryColor;
          style = widget.theme?.operatorStyle ??
              _baseStyle.copyWith(
                  color: Theme.of(context).primaryTextTheme.headline6!.color);
        }
        if (title == '⌫' || title == 'C' || title == 'AC') {
          color = widget.theme?.commandColor ?? Theme.of(context).splashColor;
          style = widget.theme?.commandStyle;
        }
        if (title == '÷' || title == '×' || title == '-' || title == '+') {
          color = Colors.grey.shade100;
        }
        return Grid(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(child: Text(title!)),
          ),
          title: title,
          color: color,
          textStyle: style,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: (title == '÷' || title == '=')
                  ? const Radius.circular(10)
                  : Radius.zero,
              topRight: (title == '÷' || title == '=')
                  ? const Radius.circular(10)
                  : Radius.zero,
              bottomLeft: (title == '=' || title == '+')
                  ? const Radius.circular(10)
                  : Radius.zero,
              bottomRight: (title == '=' || title == '+')
                  ? const Radius.circular(10)
                  : Radius.zero,
            ),
          ),
        );
      }).toList();
    }).toList();
  }
}

class _CalcDisplay extends StatefulWidget {
  /// Whether to show surrounding borders.
  final double? displayCalculatorRadius;

  /// Whether to show surrounding borders.
  final bool? hideSurroundingBorder;

  /// Whether to show expression area.
  final bool? hideExpression;

  /// Visual properties for this widget.
  final CalculatorTheme? theme;

  /// Controller for calculator.
  final CalculatorController controller;

  /// Called when the display area is tapped.
  final Function(double?, TapDownDetails)? onTappedDisplay;

  const _CalcDisplay({
    Key? key,
    this.displayCalculatorRadius,
    this.hideSurroundingBorder,
    this.hideExpression,
    required this.onTappedDisplay,
    this.theme,
    required this.controller,
  }) : super(key: key);

  @override
  _CalcDisplayState createState() => _CalcDisplayState();
}

class _CalcDisplayState extends State<_CalcDisplay> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeCalcValue);
  }

  @override
  void didUpdateWidget(_CalcDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_didChangeCalcValue);
      widget.controller.addListener(_didChangeCalcValue);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeCalcValue);
    super.dispose();
  }

  void _didChangeCalcValue() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.all(
              Radius.circular(widget.displayCalculatorRadius!))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) => widget.onTappedDisplay == null
                  ? null
                  : widget.onTappedDisplay!(widget.controller.value, details),
              child: Container(
                decoration: BoxDecoration(
                    color: widget.theme?.displayBackgroundColor ?? Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(widget.displayCalculatorRadius!),
                        topRight:
                            Radius.circular(widget.displayCalculatorRadius!))),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: AutoSizeText(
                      widget.controller.display!,
                      style: widget.theme?.displayStyle ??
                          const TextStyle(fontSize: 30),
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !widget.hideExpression!,
            child: Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color:
                        widget.theme?.expressionBackgroundColor ?? Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft:
                            Radius.circular(widget.displayCalculatorRadius!),
                        bottomRight:
                            Radius.circular(widget.displayCalculatorRadius!))),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      widget.controller.expression!,
                      style: widget.theme?.expressionStyle ??
                          const TextStyle(color: Colors.grey),
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
