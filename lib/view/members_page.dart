import 'dart:math';
import 'package:association_app/services/fire_store_services.dart';
import 'package:association_app/utills/app_utills.dart';
import 'package:association_app/utills/custom_colors.dart';
import 'package:association_app/view/helper_widget/custom_elevated_button.dart';
import 'package:association_app/view/helper_widget/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class MembersPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final box = GetStorage();

  MembersPage({super.key});

  String formatDate(DateTime date) {
    return DateFormat('dd MMM, yyyy').format(date);
  }

  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppUtils.membersSectionTitle)),
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

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "You have no members. Please Add your association members",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )); // Show message if no members
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final member = snapshot.data!.docs[index];
              final String name = member['name'];
              final String phone = member['phone'];
              final userRule=box.read("userRule");

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: customBoxDecoration(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: getRandomColor(),
                      ),
                      const SizedBox(width: 8),

                      // Name and Phone Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              phone,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // Total Investment Text
                      _firestoreService.showTotalInvestment(phone),
                      userRule=="Admin"?InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20), // Custom border radius
                                    ),
                                    insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                  child:  Container(
                                    padding: const EdgeInsets.all(16),
                                    width: MediaQuery.of(context).size.width * 0.9,

                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                    const Text("Do you want to delete This Member?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: CustomColors.warningColor),),
                                    SizedBox(height: 16,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: CustomColors.warningColor
                                          ),
                                          onPressed: () {
                                            _firestoreService.deleteMember(phone,context);
                                          },
                                          child: const Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog without saving
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    ),
                                      ],
                                    ),
                                  ),);
                                });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.delete,
                              color: CustomColors.warningColor,
                            ),
                          )):const SizedBox.shrink(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomElevatedButton(
          onPressed: () {
            _showAddMemberModal(context);
          },
          title: 'Add Member',
        ),
      ),
    );
  }

  void _showAddMemberModal(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    String formattedDate = formatDate(DateTime.now()); // Get formatted date

    // Error message to display in the dialog
    final RxString errorMessage = ''.obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Custom border radius
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          // Reducing the padding from the edges
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            // Set the desired width
            padding: const EdgeInsets.all(16),
            // Add some padding inside the container
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add New Member',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pop(); // Close the dialog without saving
                          },
                          child: const Icon(Icons.close,
                              color: CustomColors.warningColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Space between title and input fields
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      controller: nameController,
                      label: 'Member Name',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      controller: phoneController,
                      label: 'Phone Number',
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  // Display error message if duplicate phone number is found
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
                    return const SizedBox
                        .shrink(); // Return an empty widget if no error
                  }),

                  const SizedBox(height: 8),
                  // Space between title and input fields
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() {
                      return CustomElevatedButton(
                        isLoading: _firestoreService.isAddMemberLoading.value,
                        title: 'Save',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool isDuplicate = await _firestoreService
                                .checkDuplicatePhoneNumber(
                                    phoneController.text);
                            if (isDuplicate) {
                              // Update the error message to be displayed inside the dialog
                              errorMessage.value =
                                  'Phone number already exists!';
                            } else {
                              // Clear any previous error messages
                              errorMessage.value = '';

                              // If not duplicate, add member
                              _firestoreService.addMember(
                                phone: phoneController.text,
                                name: nameController.text,
                                date: formattedDate,
                              );

                              Navigator.of(context)
                                  .pop(); // Close dialog after saving
                            }
                          }
                        },
                      );
                    }),
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
