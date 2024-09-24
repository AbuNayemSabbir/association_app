import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/fire_store_services.dart';

class MemberDetailPage extends StatelessWidget {
  final String phoneNumber;
  final FirestoreService _firestoreService = FirestoreService();

  MemberDetailPage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Deposits for $phoneNumber")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getDepositsByPhoneNumber(phoneNumber),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final deposits = snapshot.data!.docs;
          double totalInvest = deposits.fold(0.0, (sum, doc) => sum + doc['interest_amount']);

          return Column(
            children: [
              ListTile(
                title: const Text("Total Investment"),
                subtitle: Text("\$$totalInvest"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: deposits.length,
                  itemBuilder: (context, index) {
                    final deposit = deposits[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(deposit['title']),
                      subtitle: Text("Interest: ${deposit['interest_amount']}"),
                      trailing: Text("${deposit['date'].toDate()}"),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
