import 'package:association_app/services/fire_store_services.dart';
import 'package:association_app/utills/app_utills.dart';
import 'package:association_app/utills/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllDepositsPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  AllDepositsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Deposits"),centerTitle: true,),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getAllDeposits(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final deposits = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['invest_amount'] != null;
          }).toList();

          if (deposits.isEmpty) {
            return const Center(
              child: Text("You have no deposits yet.",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: deposits.length,
              itemBuilder: (context, index) {
                final deposit = deposits[index].data() as Map<String, dynamic>;
                final String currentDate = deposit['date'];

                // Determine if this is the first occurrence of the date
                bool showDate = (index == 0) || ((deposits[index - 1].data() as Map<String, dynamic>)['date'] != currentDate);

                // Find how many people invested on the current date
                int peopleInvestedOnDate = deposits
                    .where((d) => (d.data() as Map<String, dynamic>)['date'] == currentDate)
                    .length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDate) ...[
                      // Display date and number of people invested for the day
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(
                              currentDate, // Display the date
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "$peopleInvestedOnDate Deposit",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Row with vertical line and deposit details
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 4.0,
                          height: 68,
                          color: CustomColors.primaryColor,
                          margin: const EdgeInsets.only(right: 12.0,left: 20),
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: customBoxDecoration(),
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name and phone in one line
                                  Text(
                                    "${deposit['name']}, ${deposit['phone']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Amount in the next line
                                  Row(
                                    children: [
                                      const Icon(Icons.monetization_on, color: CustomColors.primaryColor, size: 16),
                                      const SizedBox(width: 6),
                                      const Text(
                                        "Amount: ",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "৳ ${deposit['invest_amount'] ?? '0.0'}",
                                        style: const TextStyle(
                                          color: CustomColors.primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            )
            ,
          );

        },
      ),
    );
  }
}
