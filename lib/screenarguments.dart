import 'package:flutter/material.dart';
class ScreenArguments {
  final int id;
  final String iconName;
  final String title;
  final IconData icon;
  final String category;
  final String note;
  final String entryDate;
  final double amount;
  ScreenArguments(this.title, this.icon,this.category,this.iconName,this.entryDate,this.note,this.id,this.amount);
}