import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "database/model/expenditure.dart";
import 'package:flutter/foundation.dart';
import "dart:collection";
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:ispent/database/database_helper.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:ispent/utilities.dart';

var db = new DatabaseHelper();
List<charts.Series> seriesList = new List<charts.Series>();
final bool animate = false;
List<Expenditure> _categoryExpense = new List<Expenditure>();
var test;
Map<String, double> dataMap = Map();

class Report extends StatefulWidget {
  final int month;
  final int year;
  final int mode;

  Report(
    this.month,
    this.year,
    this.mode, {
    Key key,
  }) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool toggle = false;
  Map<String, double> dataMap = new Map();
  int chartType = 0;

  double getCategoryAmount(List<Expenditure> source, String categoryName) {
    double totalAmount = 0;
    for (int i = 0; i < source.length; i++) {
      if (source[i].itemName == categoryName) {
        totalAmount = totalAmount + source[i].amount;
      }
    }
    return totalAmount;
  }

  Future<List<Expenditure>> getExpenseList() {
    return db.getExpenses(widget.month, widget.year, widget.mode);
  }

  @override
  void initState() {
    // Disable animations for image tests.
    super.initState();
    chartType = 0;
  }

  void prepareChartData(List<Expenditure> expenses) {
    _categoryExpense = new List<Expenditure>();
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
        dataMap.putIfAbsent(distinctCategory[j].toString(), () => totalAmount);
      }
    }
  }

  List<charts.Series<Expenditure, String>> getBarChartSeries(
      List<Expenditure> expenses) {
    prepareChartData(expenses);
    return _createBarChartData();
  }

  /// Create series list with single series
  List<charts.Series<Expenditure, String>> _createBarChartData() {
    return [
      new charts.Series<Expenditure, String>(
        id: 'Expense Summary',
        domainFn: (Expenditure sales, _) => sales.itemName,
        measureFn: (Expenditure sales, _) => sales.amount,
        data: _categoryExpense,
      ),
    ];
  }

  Map<String, double> getPieChartData(List<Expenditure> expenses) {
    dataMap = Map();
    _categoryExpense = new List<Expenditure>();
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
        dataMap.putIfAbsent(distinctCategory[j].toString(), () => totalAmount);
      }
    }
    return dataMap;
  }

  @override
  Widget build(BuildContext context) {
    return _pieChart(context);
  }

  Widget _pieChart(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Scroll to right for BAR CHART",
                          style: TextStyle(fontStyle: FontStyle.italic,color: Colors.red,),
                        )),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            // Another fixed-height child.
                            padding: EdgeInsets.only(left: 20, bottom: 40),
                            alignment: Alignment.topLeft,
                            child: new FutureBuilder<List<Expenditure>>(
                                future: getExpenseList(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError)
                                    return Text("Error Occurred");
                                  if (snapshot.hasData) {
                                    var data = snapshot.data;
                                    var dataSeries = getPieChartData(data);
                                    if (dataMap != null && dataMap.isNotEmpty) {
                                      return new PieChart(
                                        dataMap: dataSeries,
                                        animationDuration:
                                            Duration(milliseconds: 800),
                                        chartLegendSpacing: 32.0,
                                        chartRadius:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        showChartValuesInPercentage: true,
                                        showChartValues: true,
                                        showChartValuesOutside: true,
                                        chartValueBackgroundColor:
                                            Colors.grey[200],
                                        colorList: colorList,
                                        showLegends: true,
                                        legendPosition: LegendPosition.right,
                                        decimalPlaces: 1,
                                        showChartValueLabel: true,
                                        initialAngle: 0,
                                        chartValueStyle:
                                            defaultChartValueStyle.copyWith(
                                          color: Colors.blueGrey[900]
                                              .withOpacity(0.9),
                                        ),
                                        chartType: ChartType.disc,
                                      );
                                    } else {
                                      return Center(
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text("No data found.")));
                                    }
                                  } else {
                                    return Center(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text("No data found.")));
                                  }
                                })),
                        Container(child: _barChart(context)),
                      ],
                    )
                  ])),
        );
      },
    );
  }

  Widget _barChart(BuildContext context) {
    return new FutureBuilder<List<Expenditure>>(
        future: getExpenseList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          var data = snapshot.data;
          if (snapshot.hasData) {
            return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      //color: Colors.green, // Yellow
                      height: MediaQuery.of(context).size.height * 0.55,
                      width: getWidth(context, data.length),
                      child: charts.BarChart(
                        getBarChartSeries(data),
                        animate: animate,
                        defaultRenderer: new charts.BarRendererConfig(
                            groupingType: charts.BarGroupingType.stacked,
                            strokeWidthPx: 2.0),
                      ))
                ]));
          } else {
            return Center(
                child: Align(
                    alignment: Alignment.center,
                    child: Text("No data found.")));
          }
          return Text("Error");
        });

    /// Sample ordinal data type.
  }

  double getWidth(BuildContext context, int itemCount) {
    int chartWidth = 0;
    chartWidth = (itemCount * 45) + 80;
    return chartWidth.toDouble();
  }

  Widget _chart(BuildContext context) {
    if (chartType == 0) {
      return _pieChart(context);
    } else if (chartType == 1) {
      return _barChart(context);
    } else {
      return DataTable(
          columns: [
            DataColumn(
                label: Text('CATEGORY',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('TOTAL AMOUNT',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: _categoryExpense
              .map(
                  // Loops through dataColumnText, each iteration assigning the value to element
                  (((element) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(element.itemName)),
                          DataCell(Text(element.amount.toStringAsFixed(2))),
                        ],
                      ))))
              .toList());
    }
  }

  /// Sample ordinal data type.

  void _handleRadioValueChange(int value) {
    setState(() {
      chartType = value;
    });
  }
}
