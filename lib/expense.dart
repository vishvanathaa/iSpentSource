import 'package:flutter/material.dart';
import 'package:ispent/addExpense.dart';
import 'package:ispent/screenarguments.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseState createState() => _ExpenseState();
}

class _ExpenseState extends State<ExpenseScreen> {
  bool isPressed = false;
  Color _iconColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Category"),
        backgroundColor: Colors.indigo,
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.80,
            child: CustomScrollView(
              primary: false,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(15),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    crossAxisCount: 4,
                    children: <Widget>[

                      getCategory(Icons.local_grocery_store, "Grocery", "local_grocery_store"),
                      getCategory(Icons.local_offer , "Meat", "local_offer"),
                      getCategory(Icons.smoking_rooms, "Smoking", "smoking_rooms"),
                      getCategory(Icons.add_shopping_cart, "Shopping", "add_shopping_cart"),
                      getCategory(Icons.local_dining, "Eatables", "local_dining"),
                      getCategory(Icons.local_drink, "Drinks", "local_drink"),
                      getCategory(Icons.theaters, "Fun", "theaters"),
                      getCategory(Icons.loyalty, "Bills", "loyalty"),
                      getCategory(Icons.spa, "Fashion", "spa"),
                      getCategory(Icons.airplanemode_active, "Travel", "airplanemode_active"),
                      getCategory(Icons.local_gas_station, "Fuel", "local_gas_station"),

                      getCategory(Icons.home, "Household", "home"),
                      getCategory(Icons.local_movies, "Function", "local_movies"),
                      getCategory(Icons.book, "Stationary", "book"),
                      getCategory(Icons.phone_iphone, "Phone", "phone_iphone"),
                      getCategory(Icons.toys, "Toys", "toys"),
                      getCategory(Icons.local_hospital, "Health", "local_hospital"),
                      getCategory(Icons.security, "Insurance", "security"),
                      getCategory(Icons.school, "Education", "school"),
                      getCategory(Icons.pets, "Pets", "pets"),
                      getCategory(Icons.security, "Security", "Security"),
                      getCategory(Icons.loyalty, "EMI", "loyalty"),
                      getCategory(Icons.business, "Business", "business"),
                      getCategory(Icons.location_city, "Construction", "location_city"),

                      getCategory(Icons.computer, "Computer", "computer"),
                      getCategory(Icons.bug_report, "Repair", "bug_report"),
                      getCategory(Icons.games, "Sports", "games"),
                      getCategory(Icons.directions_car, "Car", "directions_car"),
                      getCategory(Icons.train, "Train", "train"),
                      getCategory(Icons.local_taxi, "Taxi", "local_taxi"),
                      getCategory(Icons.directions_bike, "Bike", "directions_bike"),
                      getCategory(Icons.directions_bus, "Bus", "directions_bus"),
                      getCategory(Icons.monetization_on, "Rent", "monetization_on"),
                      getCategory(Icons.star_border, "Others", "star_border"),

                   ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getCategory(IconData icon, String categoryName, String iconName) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(children: [
        Ink(
            decoration: ShapeDecoration(
              color: Colors.lime[100],
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: new Icon(
                icon,
                color: Colors.indigo,
              ),
              //tooltip: 'Second splashColor: Colors.redscreen',
              onPressed: () {
                setState(() {
                  _iconColor = Colors.indigo;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddExpenseScreen(
                          args: new ScreenArguments(
                              categoryName,
                              icon,
                              iconName,"","","",1,1))),
                );
              },
            )),
        Padding(
          padding: EdgeInsets.only(top:10),
            child: Text(
          categoryName,
          style: new TextStyle(
            //color: (isPressed) ? Colors.white : Colors.black,
            fontWeight: FontWeight.normal,
          ),
        )),
      ]),
    );
  }

  void showOverlay(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Material(
        //Use a Material Widget
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter text',
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
  }
}
