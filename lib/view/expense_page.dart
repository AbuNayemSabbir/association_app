import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/fire_store_services.dart';

class AllExpensesPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  AllExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Expenses")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getAllExpenses(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final expenses = snapshot.data!.docs;
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(expense['expense_title']),
                subtitle: Text("Amount: ${expense['expense_amount']}"),
                trailing: Text("${expense['date'].toDate()}"),
              );
            },
          );
        },
      ),
    );
  }
}
