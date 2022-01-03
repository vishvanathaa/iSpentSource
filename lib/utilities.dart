import 'package:flutter/material.dart';

List<Color> colorList = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.teal,
  Colors.indigo,
  Colors.tealAccent,
  Colors.black12,
  Colors.blueGrey,
  Colors.pinkAccent,
  Colors.indigo,
  Colors.indigoAccent,
  Colors.greenAccent,
  Colors.lightBlue,
  Colors.amber,
  Colors.blueGrey,
  Colors.cyan,
  Colors.cyanAccent,
  Colors.deepOrangeAccent,
  Colors.lightBlueAccent,
  Colors.orange,
  Colors.lightGreenAccent,
  Colors.lightGreen,
  Colors.deepOrange,
  Colors.lime,
  Colors.deepPurple,
  Colors.brown,
  Colors.deepPurpleAccent,
  Colors.limeAccent,
  Colors.deepOrangeAccent
];


String getMonthName(int mon) {
  String monthName;
  switch (mon) {
    case 1:
      monthName = "Jan";
      break;
    case 2:
      monthName = "Feb";
      break;
    case 3:
      monthName = "Mar";
      break;
    case 4:
      monthName = "Apr";
      break;
    case 5:
      monthName = "May";
      break;
    case 6:
      monthName = "Jun";
      break;
    case 7:
      monthName = "Jul";
      break;
    case 8:
      monthName = "Aug";
      break;
    case 9:
      monthName = "Sep";
      break;
    case 10:
      monthName = "Oct";
      break;
    case 11:
      monthName = "Nov";
      break;
    case 12:
      monthName = "Dec";
      break;
    case 13:
      monthName = "Year";
      break;
  }
  return monthName;
}
class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Spending', icon: Icons.dashboard),
  const Choice(title: 'Transactions', icon: Icons.format_list_bulleted),
  const Choice(title: 'Report', icon: Icons.show_chart),
  const Choice(title: 'Settings', icon: Icons.settings)
];

IconData getIconName(String iconName) {
  var iconData = Icons.local_grocery_store;
  switch (iconName) {
    case "local_grocery_store":
      iconData = Icons.local_grocery_store;
      break;
    case "local_offer":
      iconData = Icons.local_offer;
      break;
    case "smoking_rooms":
      iconData = Icons.smoking_rooms;
      break;
    case "add_shopping_cart":
      iconData = Icons.add_shopping_cart;
      break;
    case "local_dining":
      iconData = Icons.local_dining;
      break;
    case "local_drink":
      iconData = Icons.local_drink;
      break;
    case "theaters":
      iconData = Icons.theaters;
      break;
    case "loyalty":
      iconData = Icons.loyalty;
      break;
    case "spa":
      iconData = Icons.spa;
      break;
    case "airplanemode_active":
      iconData = Icons.airplanemode_active;
      break;
    case "local_gas_station":
      iconData = Icons.local_gas_station;
      break;
    case "local_gas_station":
      iconData = Icons.local_gas_station;
      break;
    case "home":
      iconData = Icons.home;
      break;
    case "local_movies":
      iconData = Icons.local_movies;
      break;
    case "book":
      iconData = Icons.book;
      break;
    case "phone_iphone":
      iconData = Icons.phone_iphone;
      break;
    case "toys":
      iconData = Icons.toys;
      break;
    case "local_hospital":
      iconData = Icons.local_hospital;
      break;
    case "security":
      iconData = Icons.security;
      break;
    case "school":
      iconData = Icons.school;
      break;
    case "pets":
      iconData = Icons.pets;
      break;
    case "loyalty":
      iconData = Icons.loyalty;
      break;
    case "business":
      iconData = Icons.loyalty;
      break;
    case "location_city":
      iconData = Icons.location_city;
      break;
    case "computer":
      iconData = Icons.computer;
      break;
    case "bug_report":
      iconData = Icons.bug_report;
      break;
    case "games":
      iconData = Icons.games;
      break;
    case "directions_car":
      iconData = Icons.directions_car;
      break;
    case "train":
      iconData = Icons.train;
      break;
    case "local_taxi":
      iconData = Icons.local_taxi;
      break;
    case "directions_bike":
      iconData = Icons.directions_bike;
      break;
    case "directions_bus":
      iconData = Icons.directions_bus;
      break;
    case "monetization_on":
      iconData = Icons.monetization_on;
      break;
    case "star_border":
      iconData = Icons.star_border;
      break;
  }
  return iconData;
}