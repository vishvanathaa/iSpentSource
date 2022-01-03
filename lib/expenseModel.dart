class Expense{
  String entryDate;
  String itemName;
  int itemRate;
  Expense({
    this.entryDate,
    this.itemName,
    this.itemRate
  });
  factory Expense.fromJson(Map<String, dynamic> parsedJson){
    return Expense(
        entryDate: parsedJson['entryDate'],
        itemName : parsedJson['itemName'],
        itemRate : parsedJson['itemRate']
    );
  }
}