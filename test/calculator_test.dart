import 'package:flutter_dynamic_calculator/src/view/calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('basic test #1', () {
    Calculator calc = Calculator();
    calc.addDigit(1);
    expect(calc.displayString, '1');
    expect(calc.expression, '1');
    calc.setOperator('+');
    expect(calc.displayString, '1');
    expect(calc.expression, '1 + ?');
    calc.addDigit(2);
    expect(calc.displayString, '2');
    expect(calc.expression, '1 + 2');
    calc.addDigit(3);
    expect(calc.displayString, '23');
    expect(calc.expression, '1 + 23');
    calc.addDigit(4);
    expect(calc.displayString, '234');
    expect(calc.expression, '1 + 234');
    calc.addDigit(5);
    expect(calc.displayString, '2,345');
    expect(calc.expression, '1 + 2,345');
    calc.setOperator('+');
    expect(calc.displayString, '2,346');
    expect(calc.expression, '1 + 2,345 + ?');
    calc.setOperator('-');
    expect(calc.displayString, '2,346');
    expect(calc.expression, '1 + 2,345 - ?');
    calc.addDigit(6);
    expect(calc.displayString, '6');
    expect(calc.expression, '1 + 2,345 - 6');
    calc.setOperator('×');
    expect(calc.displayString, '6');
    expect(calc.expression, '1 + 2,345 - 6 × ?');
    calc.addDigit(7);
    expect(calc.displayString, '7');
    expect(calc.expression, '1 + 2,345 - 6 × 7');
    calc.setOperator('÷');
    expect(calc.displayString, '7');
    expect(calc.expression, '1 + 2,345 - 6 × 7 ÷ ?');
    calc.addDigit(8);
    expect(calc.displayString, '8');
    expect(calc.expression, '1 + 2,345 - 6 × 7 ÷ 8');
    calc.operate();
    expect(calc.displayString, '2,340.75');
    expect(calc.expression, '1 + 2,345 - 6 × 7 ÷ 8');
  });
  test('basic test #2', () {
    Calculator calc = Calculator();
    calc.addDigit(1234567890);
    expect(calc.displayString, '1,234,567,890');
    expect(calc.expression, '1,234,567,890');
    calc.removeDigit();
    expect(calc.displayString, '123,456,789');
    expect(calc.expression, '123,456,789');
    calc.removeDigit();
    expect(calc.displayString, '12,345,678');
    expect(calc.expression, '12,345,678');
    calc.addPoint();
    expect(calc.displayString, '12,345,678.');
    expect(calc.expression, '12,345,678.');
    calc.addDigit(0);
    expect(calc.displayString, '12,345,678.0');
    expect(calc.expression, '12,345,678.0');
    calc.addDigit(1);
    expect(calc.displayString, '12,345,678.01');
    expect(calc.expression, '12,345,678.01');
  });
  test('clear test', () {
    Calculator calc = Calculator();
    calc.addDigit(1);
    calc.setOperator('+');
    calc.addDigit(2);
    expect(calc.displayString, '2');
    expect(calc.expression, '1 + 2');
    calc.clear();
    expect(calc.displayString, '0');
    expect(calc.expression, '1 + 0');
    calc.addDigit(3);
    expect(calc.displayString, '3');
    expect(calc.expression, '1 + 3');
    calc.allClear();
    expect(calc.displayString, '0');
    expect(calc.expression, '0');
  });
  test('percent test', () {
    Calculator calc = Calculator();
    calc.addDigit(3);
    calc.setPercent();
    expect(calc.displayString, '0.03');
    expect(calc.expression, '3%');
    calc.setOperator('×');
    calc.addDigit(3);
    calc.setPercent();
    expect(calc.displayString, '0.03');
    expect(calc.expression, '3% × 3%');
    calc.setOperator('+');
    expect(calc.displayString, '0.0009');
    expect(calc.expression, '3% × 3% + ?');
    calc.addDigit(3);
    calc.setPercent();
    expect(calc.displayString, '0.000027');
    expect(calc.expression, '3% × 3% + 3%');
    calc.operate();
    expect(calc.displayString, '0.000927');
    expect(calc.expression, '3% × 3% + 3%');
  });
}