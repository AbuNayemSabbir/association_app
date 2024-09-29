import 'package:association_app/utills/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../services/fire_store_services.dart';
import '../utills/app_utills.dart';
import 'helper_widget/custom_elevated_button.dart';
import 'helper_widget/custom_text_field.dart';
import 'member_details_page.dart';

class IndividualMemberPage extends StatelessWidget {
  IndividualMemberPage({super.key});
  final FirestoreService _firestoreService = FirestoreService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppUtils.memberDepositInfoTitle), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('members').snapshots(),
        builder: (context, snapshot) {
          if (kDebugMode) {
            print(snapshot.error);
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // If no members are found
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  AppUtils.emptyDepositTitle,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          // Create a set to track unique phone numbers
          final Set<String> uniquePhones = {};
          final List<DocumentSnapshot> uniqueMembers = [];

          // Collect unique members
          for (var doc in snapshot.data!.docs) {
            String phone = doc['phone'];
            if (!uniquePhones.contains(phone)) {
              uniquePhones.add(phone);
              uniqueMembers.add(doc);
            }
          }

          return ListView.builder(
            itemCount: uniqueMembers.length,
            itemBuilder: (context, index) {
              final member = uniqueMembers[index];
              final String name = member['name'];
              final String phone = member['phone'];
              final userRule = box.read("userRule");

              return InkWell(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MemberDetailPage(
                        phoneNumber: phone,
                        name: name,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and Phone Row with Icon
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: CustomColors.primaryColor,
                                child: Text(name[0], style: const TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone, color: Colors.grey, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          phone,
                                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Show total investment
                          _firestoreService.showTotalInvestment(phone),

                          const Divider(color: Colors.grey),

                          // Buttons: View and Add Deposit
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // View Button
                              Flexible(
                                child: ElevatedButton.icon(
                                  label: const Text(AppUtils.detailsDepositButtonTitle, style: TextStyle(fontSize: 16)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Navigate to the view member details page
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MemberDetailPage(
                                          phoneNumber: phone,
                                          name: name,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Add Deposit Button (Visible for Admin)
                              if (userRule == 'Admin')
                                Flexible(
                                  child: ElevatedButton.icon(
                                    label: const Text(AppUtils.addDepositButtonTitle, style: TextStyle(fontSize: 16)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CustomColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      _showAddDepositModal(context, name, phone,member['id']);
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );

        },
      ),
    );
  }

  void _showAddDepositModal(BuildContext context, String name, String phone,id) {
    String formatDate(DateTime date) {
      return DateFormat('dd MMM, yyyy').format(date);
    }

    final TextEditingController amountController = TextEditingController();
    final RxString errorMessage = ''.obs;
    String formattedDate = formatDate(DateTime.now());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          AppUtils.addDepositButtonTitle,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.close, color: CustomColors.warningColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Amount input field
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      controller: amountController,
                      label: AppUtils.amountLabel,
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  // Display error message if needed
                  Obx(() {
                    if (errorMessage.value.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          errorMessage.value,
                          style: const TextStyle(
                            color: CustomColors.errorColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomElevatedButton(
                      title: AppUtils.addDepositButtonTitle,
                      onPressed: () async {
                        String amountText = amountController.text;

                        // Check if the input is empty
                        if (amountText.isEmpty) {
                          errorMessage.value = 'Please enter a valid amount';
                        } else {
                          // Try parsing the input to a double
                          double? amount = double.tryParse(amountText);

                          // Check if the parsed value is null or negative
                          if (amount == null) {
                            errorMessage.value = 'Please enter a numeric value';
                          } else if (amount < 0) {
                            errorMessage.value = 'Amount cannot be negative';
                          } else {
                            errorMessage.value = '';

                            // Call method to save deposit
                            await _firestoreService.addDeposit(
                              phone: phone,
                              amount: amountController.text,
                              date: formattedDate,
                              name: name,
                            );

                            Navigator.of(context).pop(); // Close dialog after saving
                          }
                        }
                      },
                    ),
                  )

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
