import 'package:association_app/utills/app_utills.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/fire_store_services.dart';
import '../utills/custom_colors.dart';
import 'helper_widget/custom_text_field.dart';

class MemberDetailPage extends StatelessWidget {
  final String phoneNumber;
  final String name;
  final FirestoreService _firestoreService = FirestoreService();
  final box = GetStorage();
  MemberDetailPage({super.key, required this.phoneNumber, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppUtils.individualDepositInfoTitle),centerTitle: true,),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getDepositsByPhoneNumber(phoneNumber),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final deposits = snapshot.data!.docs;
          double totalInvest = deposits.fold(0.0, (sum, doc) {
            // Safely parse the invest_amount; use 0.0 if parsing fails
            double amount = double.tryParse(doc['invest_amount']??'0') ?? 0.0;
            return sum + amount;
          });

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: context.width,
                  height: 80,
                  decoration: customBoxDecoration(),
                  child:  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: CustomColors.primaryColor,
                          child: Text(
                            name[0],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "$name, ",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      phoneNumber,
                                      style: const TextStyle(color: Colors.grey,fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.monetization_on, color: CustomColors.primaryColor, size: 22),
                                  const SizedBox(width: 6),
                                  const Text(AppUtils.totalDeposit, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                  Text("৳ $totalInvest", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.primaryColor)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: deposits.length,
                    itemBuilder: (context, index) {
                      final deposit = deposits[index].data() as Map<String, dynamic>;
                      final depositId = deposits[index].id;


                      final String currentDate = deposit['date'];

                      bool showDate = (index == 0) || ((deposits[index - 1].data() as Map<String, dynamic>)['date'] != currentDate);
                      final userRule = box.read("userRule");

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
                                height: 40,
                                color: CustomColors.primaryColor,
                                margin: const EdgeInsets.only(right: 12.0,left: 20),
                              ),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Container(
                                    decoration: customBoxDecoration(),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //Amount in the next line
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                             Row(
                                              children: [
                                                const Icon(Icons.monetization_on, color: CustomColors.primaryColor, size: 20),
                                                const SizedBox(width: 6),
                                                const Text(
                                                  AppUtils.amount,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  "৳ ${deposit['invest_amount'] ?? '0.0' }",
                                                  style: const TextStyle(
                                                      color: CustomColors.primaryColor,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            ),

                                            if (userRule == "Admin")
                                              PopupMenuButton<String>(
                                                onSelected: (String result) {
                                                  if (result == 'Edit') {
                                                    showEditDialog(context, depositId,deposit['invest_amount']);
                                                  } else if (result == 'Delete') {
                                                    showDeleteDialog(context, depositId);
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
                ),
              )
            ],
          );
        },
      ),
    );
  }
  void showEditDialog(BuildContext context, id,amount) {
    final amountController = TextEditingController(text: amount);

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
                const Text(
                 AppUtils.updateAmountTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: amountController,
                  label: AppUtils.amountLabel,
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
                              .collection('members')
                              .doc(id)
                              .update({
                            'invest_amount': newAmount,
                          });

                          Navigator.of(context).pop(); // Close the dialog

                      },
                      child:  const Text(
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
                        _firestoreService.deleteDeposit(id, context);
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

}
