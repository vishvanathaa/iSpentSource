import 'package:flutter/material.dart';
import 'database/model/expenditure.dart';
import "dart:collection";

class ExpenditureList extends StatelessWidget {
  final List<Expenditure> expenses;

  ExpenditureList(
    this.expenses, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var expenseList = getConsolidatedList(expenses);
    return ConstrainedBox(
        constraints: new BoxConstraints(
          //minHeight: 300.0,
          maxHeight: MediaQuery.of(context).size.height * 0.50,
        ),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: expenseList == null ? 0 : expenseList.length,
          itemBuilder: (context, index) {
            return Container(
                padding: EdgeInsets.only(left: 25.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          //data[index].itemName,
                          expenseList[index].itemName,
                          style: new TextStyle(
                           // fontFamily: "Quicksand",
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 35.0),
                        child: Text(
                          expenseList[index].amount.toStringAsFixed(2),
                          style: new TextStyle(
                            //fontFamily: "Quicksand",
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                decoration: new BoxDecoration(
                    border: new Border(
                        bottom: new BorderSide(
                            color: Colors.grey[700],
                            )))
            );
          },
        ));
  }
}
List<Expenditure> getConsolidatedList(List<Expenditure> expenses) {
  var _categoryExpense = new List<Expenditure>();
  List<String> categoryList = new List<String>();
  if (expenses != null) {
    for (int i = 0; i < expenses.length; i++) {
      categoryList.add(expenses[i].itemName);
    }
    List<String> distinctCategory =
    LinkedHashSet<String>.from(categoryList).toList();
    for (var j = 0; j < distinctCategory.length; j++) {
      double totalAmount =
      getCategoryAmount(expenses, distinctCategory[j].toString());
      _categoryExpense.add(new Expenditure(
          totalAmount, distinctCategory[j].toString(), null, "", ""));
    }
  }
  return _categoryExpense;
}
double getCategoryAmount(List<Expenditure> source, String categoryName) {
  double totalAmount = 0;
  for (int i = 0; i < source.length; i++) {
    if (source[i].itemName == categoryName) {
      totalAmount = totalAmount + source[i].amount;
    }
  }
  return totalAmount;
}