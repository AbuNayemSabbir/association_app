import 'package:association_app/utills/app_utills.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../services/fire_store_services.dart';
import '../utills/custom_colors.dart';

import 'helper_widget/custom_elevated_button.dart';
import 'helper_widget/custom_text_field.dart';

class AllExpensesPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  AllExpensesPage({super.key});
  String formatDate(DateTime date) {
    return DateFormat('dd MMM, yyyy').format(date);
  }
  @override
  Widget build(BuildContext context) {
    final String userRule = GetStorage().read("userRule") ?? "";

    return Scaffold(
        appBar: AppBar(title: const Text("All Expenses")),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestoreService.getAllExpenses(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text("Error: ${snapshot.error}");
            if (!snapshot.hasData) return const CircularProgressIndicator();

            final expenses = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data['expense_amount'] != null;
            }).toList();

            if (expenses.isEmpty) {
              return const Center(
                child: Text(
                  "You have no expenses yet.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index].data() as Map<String, dynamic>;
                  final String currentDate = expense['date'];

                  // Determine if this is the first occurrence of the date
                  bool showDate = (index == 0) || ((expenses[index - 1].data() as Map<String, dynamic>)['date'] != currentDate);

                  // Find how many expenses occurred on the current date
                  int expenseCountOnDate = expenses.where((d) => (d.data() as Map<String, dynamic>)['date'] == currentDate).length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDate) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Text(
                                currentDate,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "$expenseCountOnDate Expenses",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Row with vertical line and expense details
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 4.0,
                            height: 68,
                            color: CustomColors.primaryColor,
                            margin: const EdgeInsets.only(right: 8.0),
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
                                    // Title and amount in one line
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${expense['expense_title']}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        if (userRule == 'Admin')
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: CustomColors.primaryColor),
                                            onPressed: () {
                                              _showEditExpenseModal(context, expense);
                                            },
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),

                                    // Amount in the next line
                                    Text(
                                      "Amount: ${expense['expense_amount'] ?? '0.0'}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
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
              ),
            );
          },
        ),

      // Add button only visible for admins
      bottomNavigationBar: userRule == 'Admin'?  Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomElevatedButton(
              onPressed: () {
                _showAddExpenseModal(context);
              },
              title: 'Add Expense',
            ),
          ): const SizedBox.shrink() // If not admin, show nothing

    );
  }
  void _showEditExpenseModal(BuildContext context, Map<String, dynamic> expense) {
    // Similar modal dialog for editing the expense
    // Implement this function based on your requirements
  }
  void _showAddExpenseModal(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    String formattedDate = formatDate(DateTime.now()); // Get formatted date

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Custom border radius
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Modal header
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Expense',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop(); // Close the dialog without saving
                          },
                          child: const Icon(Icons.close, color: CustomColors.warningColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Expense Title
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      controller: titleController,
                      label: 'Expense Title',
                    ),
                  ),
                  // Expense Amount
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      controller: amountController,
                      label: 'Expense Amount',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Save button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomElevatedButton(
                      title: 'Save',
                      onPressed: () {
                        // Validate and save the expense
                        if (titleController.text.isNotEmpty &&
                            amountController.text.isNotEmpty) {
                          _firestoreService.addExpense(
                            expenseTitle: titleController.text,
                            expenseAmount: double.parse(amountController.text),
                            date: formattedDate,
                          );
                          Navigator.of(context).pop(); // Close modal after saving
                        } else {
                          Get.snackbar("Error", "All fields must be filled",
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
