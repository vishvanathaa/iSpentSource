import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'package:flutter/services.dart';

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}


class _AppSettingsState extends State<AppSettings> {
  TextEditingController amountController = new TextEditingController();
  int _mode = 0;
  var _productId = "";
  int _budget = 0;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData;
  bool _autoValidate = false;

  _AppSettingsState();

  int selectedRadio;
  int _radioValue1 = 0;

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  @override
  void initState() {
    getSettings();
    super.initState();
  }


  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 35, top: 20),
                      child: Align(alignment: Alignment.bottomLeft,
                        child: Text("ID : " + _productId
                          , style: TextStyle(color: Colors.purple,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),),),
                    )

                    ,
                    Container(
                        padding:
                        const EdgeInsets.only(left: 20, top: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Radio(
                              value: 0,
                              groupValue: _radioValue1,
                              onChanged: _handleRadioValueChange1,
                            ),
                            Text("Monthly", style: TextStyle(fontSize: 18),),
                            Radio(
                              value: 1,
                              groupValue: _radioValue1,
                              onChanged: _handleRadioValueChange1,
                            ),
                            Text("Yearly", style: TextStyle(fontSize: 18),),
                          ],
                        )),
                    Container(
                        padding:
                        const EdgeInsets.only(left: 20, top: 30, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: new TextFormField(
                                maxLength: 12,
                                controller: amountController,
                                decoration: new InputDecoration(
                                  //labelText: "Budget",

                                  hintText: 'Your Monthly budget',
                                  prefixIcon: const Icon(
                                    Icons.monetization_on,
                                    color: Colors.indigo,
                                  ),
                                  /* border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),*/
                                  filled: true,
                                ),
                                inputFormatters: [
                                  DecimalTextInputFormatter(decimalRange: 2)
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                validator: (String arg) {
                                  if (arg.length < 1)
                                    return 'Enter Budget';
                                  else
                                    return null;
                                },
                                style: new TextStyle(
                                    fontFamily: "Poppins", fontSize: 18
                                ),
                              ),
                            ),

                          ],
                        )),
                    Center(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: FlatButton.icon(
                              color: Colors.indigo,

                              icon: const Icon(Icons.save, color: Colors.white),
                              //`Icon` to display
                              label: Text(
                                'SAVE SETTINGS',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: _validateInputs,
                            ))),
                  ],
                ))));
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      _save(
          int.parse(
              amountController.text.isEmpty ? 0 : amountController.text),
          _radioValue1);
      //getSettings();
      Navigator.of(context).pushNamed("first");
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  // ignore: missing_return
  void getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final budgetKey = 'budget_double_key';
    final modeKey = 'mode_int_key';
    final productKey = 'product_int_key';
    final mode = prefs.getInt(modeKey) ?? 0;
    final budget = prefs.getInt(budgetKey) ?? 0;
    final productId = prefs.getString(productKey) ?? "0";
    var productKeyValue = "";
    if (productId == null || productId == "0" || productId.isEmpty) {
      var currentDate = DateTime.now();
      var randomNumber = new Random().nextInt(10);
      productKeyValue = currentDate.year.toString() +
          currentDate.month.toString() + currentDate.day.toString() +
          currentDate.hour.toString() + currentDate.minute.toString() +
          currentDate.second.toString() + randomNumber.toString();
      prefs.setString(productKey, productKeyValue);
    }
    setState(() {
      selectedRadio = mode;
      _mode = mode;
      _radioValue1 = mode;
      _productId = productId;
      _budget = budget;
      _productId = prefs.getString(productKey)??productKeyValue;
    });
    amountController.text = _budget.toString();
  }

  static int findYearIndex(int year) {
    var currentYear = DateTime
        .now()
        .year;
    int startYear = currentYear - 3;
    int index = 0;
    for (var i = startYear; i <= currentYear; i++) {
      if (i == year) return index;
      index++;
    }
    return index;
  }

  _save(int budget, int mode) async {
    final prefs = await SharedPreferences.getInstance();
    final budgetKey = 'budget_double_key';
    final modeKey = 'mode_int_key';
    prefs.setInt(modeKey, mode);
    prefs.setInt(budgetKey, budget);
    //print('saved $value');
  }
}

class Settings {
  int budget;
  int month;
  int year;
  int mode;

  Settings(this.budget, this.month, this.year, this.mode);
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, // unused.
      TextEditingValue newValue,) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(',') ||
          value.contains('-') ||
          value.contains(' ') ||
          value.contains('..')) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value.contains(".") &&
          value
              .substring(value.indexOf(".") + 1)
              .length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: min(truncated.length, truncated.length + 1),
          extentOffset: min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}