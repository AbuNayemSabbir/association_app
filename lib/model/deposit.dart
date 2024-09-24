import 'package:cloud_firestore/cloud_firestore.dart';

class Deposit {
  String investorName;
  String phoneNumber;
  DateTime date;
  double investAmount;
  String title;

  Deposit({required this.investorName, required this.phoneNumber, required this.date, required this.investAmount, required this.title});

  factory Deposit.fromFirestore(Map<String, dynamic> data) {
    return Deposit(
      investorName: data['investor_name'],
      phoneNumber: data['email'],
      date: (data['date'] as Timestamp).toDate(),
      investAmount: data['interest_amount'],
      title: data['title'],
    );
  }
}

class Expense {
  String title;
  double amount;
  DateTime date;

  Expense({required this.title, required this.amount, required this.date});

  factory Expense.fromFirestore(Map<String, dynamic> data) {
    return Expense(
      title: data['expense_title'],
      amount: data['expense_amount'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}
