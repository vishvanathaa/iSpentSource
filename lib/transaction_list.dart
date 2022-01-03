import 'package:flutter/material.dart';
import "database/model/expenditure.dart";
import 'expense_delete.dart';
import 'screenarguments.dart';
import 'package:ispent/home_presenter.dart';
import 'package:intl/intl.dart';
import 'package:ispent/utilities.dart';

class TransactionList extends StatefulWidget {
  final List<Expenditure> expenses;

  TransactionList(
    this.expenses, {
    Key key,
  }) : super(key: key);

  @override
  _TransactionListExpenseState createState() => _TransactionListExpenseState();
}

class _TransactionListExpenseState extends State<TransactionList>
    implements HomeContract {
  @override
  void initState() {
    // Disable animations for image tests.
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.indigo[60],
        child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.indigo[50],
            child: Column(children: [
              ConstrainedBox(
                  constraints: new BoxConstraints(
                    //minHeight: 300.0,
                    maxHeight: MediaQuery.of(context).size.height * 0.63,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount:
                        widget.expenses == null ? 0 : widget.expenses.length,
                    itemBuilder: (context, index) {
                      return Container(
                          child: Padding(
                              padding: EdgeInsets.only(left: 3),
                              child: Row(
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Icon(
                                    getIconName(widget.expenses[index].icon),
                                    color: Colors.indigo,
                                  )),
                                  Expanded(
                                      flex: 2,
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 0),
                                          child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Column(children: [
                                                Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      widget.expenses[index]
                                                              .note.isEmpty
                                                          ? widget
                                                              .expenses[index]
                                                              .itemName
                                                          : widget
                                                              .expenses[index]
                                                              .note,
                                                    )),
                                                Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      DateFormat(
                                                              'EEEE, d MMM, yyyy')
                                                          .format(DateTime
                                                              .parse(widget
                                                                  .expenses[
                                                                      index]
                                                                  .entryDate)),
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .indigoAccent),
                                                    )),
                                              ])))),
                                  Expanded(
                                    child: Text(
                                        widget.expenses[index].amount
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      tooltip: "Click to edit",
                                      icon: Icon(Icons.edit,
                                          color: Colors.indigo),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DeleteExpenseScreen(
                                                      args: new ScreenArguments(
                                                          widget.expenses[index].itemName,
                                                          getIconName(widget.expenses[index].icon),
                                                          widget.expenses[index]
                                                              .itemName,
                                                          widget.expenses[index]
                                                              .icon,
                                                          widget.expenses[index]
                                                              .entryDate,
                                                          widget.expenses[index]
                                                              .note,
                                                          widget.expenses[index]
                                                              .id,
                                                          widget.expenses[index]
                                                              .amount))),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              )),
                          decoration: new BoxDecoration(
                              color: Colors.indigo[50],
                              border: new Border(
                                  bottom: new BorderSide(
                                      color: Colors.indigo[100],
                                      style: BorderStyle.solid))));
                    },
                  ))
            ])));
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}
