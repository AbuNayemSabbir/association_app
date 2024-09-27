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
        appBar: AppBar(title: const Text(AppUtils.allExpensesInfoTitle),centerTitle: true,),
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
                  AppUtils.emptyExpenseTitle,
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
                  final expenseId = expense['id'];

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
                                "$expenseCountOnDate ${AppUtils.numberOfExpense}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],

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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Title and amount in one line
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${expense['expense_title']}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.monetization_on, color: CustomColors.primaryColor, size: 16),
                                            const SizedBox(width: 6),
                                            const Text(
                                              "Amount: ",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "৳ ${expense['expense_amount'] ?? '0.0'}",
                                              style: const TextStyle(
                                                color: CustomColors.primaryColor,
                                                fontSize: 16,
                                              ),
                                            )
                                          ],
                                        ),

                                      ],
                                    ),

                                    if (userRule == "Admin")
                                      PopupMenuButton<String>(
                                        onSelected: (String result) {
                                          if (result == 'Edit') {
                                            showEditDialog(context, expenseId,expense['expense_amount']); // Call edit method
                                          } else if (result == 'Delete') {
                                            showDeleteDialog(context, expenseId); // Call delete method
                                          }
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.grey,
                                        ),
                                        itemBuilder: (BuildContext context) => [
                                          const PopupMenuItem(
                                            value: 'Edit',
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit, color: Colors.blue),
                                                SizedBox(width: 8),
                                                Text('Edit'),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'Delete',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete, color: Colors.red),
                                                SizedBox(width: 8),
                                                Text('Delete'),
                                              ],
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
              title: AppUtils.addExpenseButtonTitle,
            ),
          ): const SizedBox.shrink() // If not admin, show nothing

    );
  }
  void showEditDialog(BuildContext context, id,amount) {
    final amountController = TextEditingController(text: amount.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Text(
                  AppUtils.updateAmountTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: amountController,
                  label: AppUtils.amountLabel,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        final newAmount = amountController.text;

                        await FirebaseFirestore.instance
                            .collection('expense')
                            .doc(id)
                            .update({
                          'expense_amount': newAmount,
                        });

                        Navigator.of(context).pop();
                        Get.snackbar(
                          AppUtils.success,
                          AppUtils.successMessageExpenseUpdate,
                          snackPosition: SnackPosition.BOTTOM,
                        );

                      },
                      child: const Text(
                        AppUtils.saveButtonTitle,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(AppUtils.cancelButtonTitle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  AppUtils.deleteWarning,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: CustomColors.warningColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: CustomColors.warningColor,
                      ),
                      onPressed: () {
                        _firestoreService.deleteExpenseByID(id, context);
                      },
                      child: const Text(AppUtils.deleteButton),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: const Text(AppUtils.cancelButtonTitle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
                          AppUtils.addExpenseButtonTitle,
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
                      label: AppUtils.expenseTitleLabel,
                    ),
                  ),
                  // Expense Amount
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      controller: amountController,
                      label: AppUtils.amountLabel,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Save button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomElevatedButton(
                      title: AppUtils.saveButtonTitle,
                      onPressed: () {
                        // Validate and save the expense
                        if (titleController.text.isNotEmpty &&
                            amountController.text.isNotEmpty) {
                          _firestoreService.addExpense(
                            expenseTitle: titleController.text,
                            expenseAmount: amountController.text,
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
