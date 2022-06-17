import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_calculator/flutter_dynamic_calculator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('DynamicCalculator'),
        ),
        body: const SizedBox(
          width: double.infinity,
          child: CalcButton(),
        ),
      ),
    );
  }
}

class CalcButton extends StatefulWidget {
  const CalcButton({Key? key}) : super(key: key);

  @override
  _CalcButtonState createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> {
  double? _currentValue = 0;
  @override
  Widget build(BuildContext context) {
    var calc = DynamicCalculator(
      value: _currentValue!,
      hideExpression: false,
      hideSurroundingBorder: true,
      showCalculatorDisplay: true,
      autofocus: true,
      onChanged: (key, value, expression) {
        setState(() {
          _currentValue = value ?? 0;
        });
        if (kDebugMode) {
          print('$key\t$value\t$expression');
        }
      },
      onTappedDisplay: (value, details) {
        if (kDebugMode) {
          print('$value\t${details.globalPosition}');
        }
      },
      theme: const CalculatorTheme(
        borderColor: Colors.transparent,
        borderWidth: 0.0,
        displayCalculatorRadius: 10.0,
        displayBackgroundColor: Colors.white,
        displayStyle: TextStyle(fontSize: 30, color: Colors.green),
        expressionBackgroundColor: Colors.black12,
        expressionStyle: TextStyle(fontSize: 14, color: Colors.black45),
        operatorColor: Colors.green,
        operatorStyle: TextStyle(fontSize: 24, color: Colors.white),
        commandColor: Colors.white,
        commandStyle: TextStyle(fontSize: 24, color: Colors.green),
        numColor: Colors.white,
        numStyle: TextStyle(fontSize: 24, color: Colors.black87),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: TextEditingController(text: _currentValue.toString()),
        enableInteractiveSelection: false,
        showCursor: false,
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8.0),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.green,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.green,
              width: 1.0,
            ),
          ),
        ),
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              barrierColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 5,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 26.0, right: 26.0),
                        child: calc,
                      )),
                );
              });
        },
      ),
    );
  }
}
