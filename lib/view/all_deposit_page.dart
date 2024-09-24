import 'package:association_app/services/fire_store_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllDepositsPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  AllDepositsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Deposits")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getAllDeposits(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final deposits = snapshot.data!.docs;
          return ListView.builder(
            itemCount: deposits.length,
            itemBuilder: (context, index) {
              final deposit = deposits[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text("${deposit['title']}"),
                subtitle: Text("Investor: ${deposit['investor_name']}, Phone: ${deposit['phone_number']}"),
                trailing: Text("${deposit['date'].toDate()}"),
              );
            },
          );
        },
      ),
    );
  }
}
