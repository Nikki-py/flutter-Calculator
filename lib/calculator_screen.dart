import 'package:flutter/material.dart';
import 'package:prac_app1/button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String num1 = "";
  String operand = "";
  String num2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$num1$operand$num2".isEmpty ? "0" : "$num1$operand$num2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            //buttons
            Wrap(
              children: Btn.buttonvalues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: screenSize.height / 8,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtncolor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }

  Color getBtncolor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [Btn.add, Btn.div, Btn.mul, Btn.sub, Btn.cal, Btn.per].contains(value)
        ? Colors.orange
        : Colors.black87;
  }

  void onBtnTap(value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clear();
      return;
    }

    if (value == Btn.per) {
      percentage();
      return;
    }

    if (value == Btn.cal) {
      calculate();
      return;
    }

    append(value);
  }

  void append(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && num2.isNotEmpty) {}
      operand = value;
    } else if (num1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && num1.contains(Btn.dot)) return;
      if (value == Btn.dot && (num1.isEmpty || num1 == Btn.dot)) {
        value = "0.";
      }
      num1 += value;
    } else {
      if (value == Btn.dot && num2.contains(Btn.dot)) return;
      if (value == Btn.dot && num2.isEmpty) {
        value = "0.";
      }
      num2 += value;
    }

    setState(() {});
  }

  void delete() {
    setState(() {
      if (num2.isNotEmpty) {
        num2 = num2.substring(0, num2.length - 1);
      } else if (operand.isNotEmpty) {
        operand = "";
      } else if (num1.isNotEmpty) {
        num1 = num1.substring(0, num1.length - 1);
      }
    });
  }

  void clear() {
    setState(() {
      num1 = "";
      operand = "";
      num2 = "";
    });
  }

  void percentage() {
    if (num1.isNotEmpty && operand.isNotEmpty && num2.isNotEmpty) {}
    if (operand.isNotEmpty) {
      return;
    }

    final num = double.parse(num1);
    setState(() {
      num1 = "${(num / 100)}";
      operand = "";
      num2 = "";
    });
  }

  void calculate() {
    if (num1.isEmpty) return;
    if (operand.isEmpty) return;
    if (num2.isEmpty) return;

    double numm1 = double.parse(num1);
    double numm2 = double.parse(num2);

    var result = 0.0;

    switch (operand) {
      case Btn.add:
        result = numm1 + numm2;
        break;
      case Btn.sub:
        result = numm1 - numm2;
        break;
      case Btn.mul:
        result = numm1 * numm2;
        break;
      case Btn.div:
        result = numm1 / numm2;
        break;
      default:
    }
    setState(() {
      num1 = "$result";

      if (num1.endsWith(".0")) {
        num1 = num1.substring(0, num1.length - 2);
      }

      operand = "";
      num2 = "";
    });
  }
}
