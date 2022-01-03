import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:ispent/screenarguments.dart';
import 'package:ispent/database/database_helper.dart';
import 'package:ispent/database/model/expenditure.dart';
import 'dart:async';
import 'package:ispent/utilities.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class DeleteExpenseScreen extends StatefulWidget {
  final ScreenArguments args;

  DeleteExpenseScreen({Key key, @required this.args}) : super(key: key);

  @override
  _DeleteExpenseState createState() => _DeleteExpenseState();
}

class _DeleteExpenseState extends State<DeleteExpenseScreen> {
  TextEditingController noteController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  bool isPressed = false;
  final format = DateFormat("dd-MM-yyyy");
  var entryDate = DateTime.now().toString();
  final _formKey = GlobalKey<FormState>();
  final doubleRegex = RegExp(r'[+-]?([0-9]*[.])?[0-9]+', multiLine: true);
  bool _autoValidate = false;
  @override
  Widget build(BuildContext context) {
    amountController =
        new TextEditingController(text: widget.args.amount.toStringAsFixed(2));
    noteController = new TextEditingController(text: widget.args.note);

    return Scaffold(
        appBar: AppBar(
          title: Text("Update Expense"),
          backgroundColor: Colors.indigo,
        ),
        resizeToAvoidBottomPadding: false,
        body: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  child: Column(children: [
                    IconButton(
                      icon: new Icon(
                        getIconName(widget.args.iconName),
                        color: Colors.indigo,
                        size: 35,
                      ),
                      //tooltip: 'Second screen',
                      onPressed: () {
                        Navigator.pushNamed(context, '/addexpense');
                        //showOverlay(context);
                      },
                      color: Colors.indigo,
                    ),
                    Text(
                      widget.args.category,
                      style: new TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ]),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)),
                    //    color:  Colors.indigo
                  ),
                  //color: Colors.green[100],
                ),
                Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: Column(children: <Widget>[
                      //Text('Basic date field (${format.pattern})'),
                      DateTimeField(
                        // controller: dateController,
                        format: format,
                        initialValue: DateTime.now(),
                        decoration: new InputDecoration(
                          labelText: "Date (dd-mm-yyyy)",
                          fillColor: Colors.indigo,
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                          // hintText: 'Tell us about yourself',
                          //helperText: 'Keep it short, this is just a demo.',
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.indigo,
                          ),
                        ),
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                          entryDate = date.toString();
                          return date;
                        },
                      ),
                    ])),
                Container(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: new TextFormField(
                            maxLength: 12,
                            controller: amountController,
                            decoration: new InputDecoration(
                              labelText: "Amount",
                              fillColor: Colors.indigo,
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                              prefixIcon: const Icon(
                                Icons.monetization_on,
                                color: Colors.indigo,
                              ),
                            ),
                            inputFormatters: [
                              DecimalTextInputFormatter(decimalRange: 2)
                            ],
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (String arg) {
                              if (arg.length < 1)
                                return 'Enter Amount';
                              else
                                return null;
                            },
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: new TextFormField(
                            maxLength: 50,
                            controller: noteController,
                            decoration: new InputDecoration(
                              labelText: "Note",
                              //fillColor: Colors.green,
                              filled: true,
                              hintText: 'Add note if required',
                              //helperText: 'Keep it short, this is just a demo.',
                              prefixIcon: const Icon(
                                Icons.note_add,
                                color: Colors.indigo,
                              ),
                            ),
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                      ],
                    )),
                Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton.icon(
                                color: Colors.green,
                                icon:
                                    const Icon(Icons.save, color: Colors.white),
                                //`Icon` to display
                                label: Text(
                                  'UPDATE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                //`Text` to display
                                onPressed: () {
                                  //Code to execute when Floating Action Button is clicked
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    var expenseObj = new Expenditure(
                                        widget.args.amount,
                                        widget.args.title,
                                        widget.args.entryDate,
                                        widget.args.iconName,
                                        widget.args.note);
                                    expenseObj.setExpenditureId(widget.args.id);
                                    updateRecord();
                                   /*Navigator.pop(context, () {
                                      setState(() {});
                                    });*/
                                    Navigator.pushNamed(context, 'first');
                                    //...
                                  } else {
                                    //    If all data are not valid then start auto validation.
                                    setState(() {
                                      _autoValidate = true;
                                    });
                                  }
                                },
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: FlatButton.icon(
                                    color: Colors.red,
                                    icon: const Icon(Icons.delete_forever,
                                        color: Colors.white),
                                    //`Icon` to display
                                    label: Text(
                                      'DELETE',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //`Text` to display
                                    onPressed: () {
                                      //Code to execute when Floating Action Button is clicked
                                      var expenseObj = new Expenditure(
                                          widget.args.amount,
                                          widget.args.title,
                                          widget.args.entryDate,
                                          widget.args.iconName,
                                          widget.args.note);
                                      expenseObj
                                          .setExpenditureId(widget.args.id);
                                      delete(expenseObj);
                                    /*  Navigator.pop(context, () {
                                        setState(() {});
                                      });*/
                                      Navigator.pushNamed(context, 'first');
                                      //...
                                    },
                                  )),
                            ]))),
              ],
            )));
  }

  delete(Expenditure user) {
    var db = new DatabaseHelper();
    db.deleteUsers(user);
  }

  Future updateRecord() async {
    var db = new DatabaseHelper();
    final Map<String, IconData> data = new Map<String, IconData>();
    //.log(widget.args.title);
    var expense = new Expenditure(
        double.parse(amountController.text.isEmpty ? 0 : amountController.text),
        widget.args.title,
        entryDate,
        widget.args.iconName,
        noteController.text);

    expense.setExpenditureId(widget.args.id);
    await db.update(expense);
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
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
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
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
