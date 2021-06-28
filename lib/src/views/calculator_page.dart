import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final options = [
    "AC",
    "%",
    "*",
    "/",
    "7",
    "8",
    "9",
    "-",
    "4",
    "5",
    "6",
    "+",
    "1",
    "2",
    "3",
    "=",
    "0",
    "."
  ];

  var displayValue = '0';
  bool clearDisplay = false;
  var operation;
  List values = [0, 0];
  var current = 0;

  clearMemory() {
    displayValue = '0';
    clearDisplay = false;
    operation = null;
    values = [0, 0];
    current = 0;
    setState(() {});
  }

  setOperation(operation) {
    var values = [...this.values];
    print(values);

    if (current == 0) {
      print('current 0');
      current = 1;
      clearDisplay = true;
      this.operation = operation;

      setState(() {});
    } else {
      var equals = operation == '=';

      var result;

      print('OP:${this.operation}');
      switch (this.operation) {
        case '+':
          result = values[0] + values[1];
          break;
        case '-':
          result = values[0] - values[1];
          break;
        case '/':
          result = values[0] / values[1];
          break;
        case '*':
          result = values[0] * values[1];
          break;
        default:
          break;
      }

      values[0] = result;
      values[1] = 0;

      current = equals ? 0 : 1;
      clearDisplay = !equals;
      this.operation = equals ? null : operation;
      this.displayValue = values[0];
      this.values = values;

      setState(() {});
    }
  }

  addDigit(n) {
    print(n);
    if (n == '.' && this.displayValue.contains('.')) return;

    var display = this.displayValue == '0' || clearDisplay;
    var currentValue = display ? '' : this.displayValue;
    var displayValue = currentValue + n;
    this.displayValue = displayValue;
    clearDisplay = false;
    print(displayValue);
    setState(() {});

    if (n != '.') {
      var i = current;
      var newValue = double.parse(displayValue);
      var values = [...this.values];
      values[i] = newValue;
      this.values = values;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                // color: Colors.white,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 24, bottom: 36, left: 24),
                    child: Text(
                      displayValue,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: StaggeredGridView.countBuilder(
                  padding: EdgeInsets.zero,
                  crossAxisCount: 4,
                  itemCount: 18,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    onTap: () {
                      final numeric = RegExp(r'^[0-9]');

                      if (numeric.hasMatch(options[index])) {
                        addDigit(options[index]);
                      } else if (options[index] == 'AC') {
                        clearMemory();
                      } else {
                        setOperation(options[index]);
                      }
                    },
                    child: Container(
                        color:
                            index == 15 ? Color(0xFFF57C00) : Color(0xFF212121),
                        child: Center(
                          child: Text(
                            options[index],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          ),
                        )),
                  ),
                  staggeredTileBuilder: (int index) {
                    if (index == 15) {
                      return StaggeredTile.count(1, 2);
                    } else if (index == 16) {
                      return StaggeredTile.count(2, 1);
                    } else {
                      return StaggeredTile.count(1, 1);
                    }
                  },
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                )),
          ],
        ),
      ),
    );
  }
}
