import 'package:flutter/material.dart';
import 'package:ispent/addExpense.dart';
import 'package:ispent/home_presenter.dart';
import 'package:ispent/database/model/expenditure.dart';
import 'package:ispent/database/database_helper.dart';
import 'package:ispent/expenditure_list.dart';
import 'package:ispent/flutter_dash.dart';
import 'package:ispent/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ispent/appSettings.dart';
import 'package:ispent/transaction_list.dart';
import 'package:flutter/services.dart';
import 'package:ispent/report.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ispent/utilities.dart';
double _totalExpense = 0;
double _budget = 0;
int _mode = 0;
int _year = DateTime.now().year;
int _monthNumber = DateTime.now().month;
List<Expenditure> _expenditureList;
bool visible = true;

var db = new DatabaseHelper();
DateTime _currentDateTime = DateTime.now();

class ISpentContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          'first': (BuildContext context) => new ISpentHome(),
          '/second': (BuildContext context) => new ExpenseScreen(),
        },
        home: ISpentHome());
  }

}

class ISpentHome extends StatefulWidget {
  ISpentHome({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<ISpentHome> implements HomeContract {
  @override
  void screenUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    getSettings();
    _currentDateTime = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final budgetKey = 'budget_double_key';
    final modeKey = 'mode_int_key';
    final mode = prefs.getInt(modeKey) ?? 0;
    final budget = prefs.getInt(budgetKey) ?? 0.00;
    setState(() {
      _budget = budget.toDouble();
      _monthNumber = DateTime.now().month;
      _year = DateTime.now().year;
      _mode = mode == null ? 0 : mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentMonth = getMonthName(_monthNumber);
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          centerTitle: false,
          leading: Transform.translate(
            offset: Offset(0, 0),
            child: Icon(Icons.add_shopping_cart),
          ),
          //titleSpacing: -5,
          elevation: 0.2,
          backgroundColor: Colors.indigo,
          title: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_left,
                    color: Colors.yellow,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_mode == 0) {
                        var newDate =
                            Jiffy(_currentDateTime).subtract(months: 1);
                        _monthNumber = newDate.month;
                        _currentDateTime = newDate;
                        _year = newDate.year;
                      } else {
                        _year -= 1;
                      }
                    });
                    // do what you need to do when "Click here" gets clicked
                  }),
              Text(
                (_mode == 0 ? currentMonth : "Year") + " - " + _year.toString(),
                style: TextStyle(fontSize: 25),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_right,
                  color: Colors.yellow,
                ),
                onPressed: () {
                  setState(() {
                    if (_mode == 0) {
                      var newDate = Jiffy(_currentDateTime).add(months: 1);
                      _monthNumber = newDate.month;
                      _currentDateTime = newDate;
                      _year = newDate.year;
                    } else {
                      _year += 1;
                    }
                  });
                },
              ),
            ],
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.yellow,
            labelStyle: TextStyle(letterSpacing: 0.2),
            tabs: choices.map((Choice choice) {
              return Tab(
                text: choice.title,
                icon: Icon(choice.icon),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: choices.map((Choice choice) {
            return Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                  // height: MediaQuery.of(context).size.height,
                  child: ChoiceCard(choice: choice)),
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
            Navigator.pushNamed(context, '/second');
          },
          icon: Icon(Icons.add),
          label: Text(
            "ADD EXPENSE",
            style: TextStyle(
              letterSpacing: 0.3,
              wordSpacing: 0.3,
            ),
          ),
          backgroundColor: Colors.green,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class ChoiceCard extends StatefulWidget {
  final Choice choice;
  const ChoiceCard({Key key, this.choice}) : super(key: key);
  @override
  _ChoiceCardState createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard> {
  @override
  Widget build(BuildContext context) {
    var choiceType = widget.choice.title.toUpperCase();
    if (choiceType == "SPENDING") {
      return new Container(
          color: Colors.grey.shade800,
          child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.grey.shade800,
              child: Column(children: [
                _headerBudgetView(context),
                _separator(context),
                _expenseListView(context),
              ])));
    } else if (choiceType == "SETTINGS") {
      return AppSettings();
    } else if (choiceType == "REPORT") {
      return new Report(_monthNumber, _year, _mode);
    } else {
      return new FutureBuilder<List<Expenditure>>(
          future: getExpenseList(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            var data = snapshot.data;
            if (snapshot.hasData) {
              return new TransactionList(data);
            }
            return new Center(child: new CircularProgressIndicator());
          });
    }
  }
}

Widget _separator(BuildContext context) {
  return Row(children: [
    Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 1.5, bottom: 5.0, top: 8.0),
        child: Dash(direction: Axis.horizontal, dashColor: Colors.white),
      ),
    ),
    Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(right: 1.5, bottom: 5.0, top: 8.0),
        child: Dash(direction: Axis.horizontal, dashColor: Colors.white),
      ),
    )
  ]);
}

Widget _headerBudgetView(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 12.0, bottom: 3.0, top: 20.0),
          child: Text(
            "BUDGET",
            style: new TextStyle(
              //fontFamily: "Quicksand",
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 35.0, bottom: 3.0, top: 20.0),
          child: Text(
            _budget.toStringAsFixed(2),
            style: new TextStyle(
              //fontFamily: "Quicksand",
              fontSize: 16.0,
              color: Colors.lightGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )
    ],
  );
}

Widget _balanceView(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 12.0, bottom: 5.0, top: 2.0),
          child: Text(
            "BALANCE",
            style: new TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 35.0, bottom: 5.0, top: 3.0),
          child: Text(
            (_budget - _totalExpense).toStringAsFixed(2),
            style: new TextStyle(
              //fontFamily: "Quicksand",
              fontSize: 16.0,
              color: Colors.lightBlueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )
    ],
  );
}

Widget _headerExpenseView(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 12.0, bottom: 5.0, top: 5),
          child: Text(
            "EXPENSE",
            style: new TextStyle(
              //fontFamily: "Quicksand",
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 35.0),
          child: Text(
            _totalExpense.toStringAsFixed(2),
            style: new TextStyle(
              //fontFamily: "Quicksand",
              fontSize: 16.0,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )
    ],
  );
}

Future<List<Expenditure>> getExpenseList() {
  return db.getExpenses(_monthNumber, _year, _mode);
}

double getTotalExpense(List<Expenditure> expenses) {
  double totalExpense = 0.0;
  for (var expense in expenses) {
    totalExpense = totalExpense + expense.amount;
  }
  return totalExpense;
}

Widget _expenseListView(BuildContext context) {
  return FutureBuilder<List<Expenditure>>(
      future: getExpenseList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        _expenditureList = snapshot.data;
        if (snapshot.hasData) {
          _totalExpense = getTotalExpense(_expenditureList);
          return new Column(children: [
            ExpenditureList(_expenditureList),
            //_separator(context),
            _headerExpenseView(context),
            _separator(context),
            _balanceView(context)
          ]);
        }
        return new Center(child: new CircularProgressIndicator());
      });
}

void main() {
  runApp(ISpentContainer());
}
