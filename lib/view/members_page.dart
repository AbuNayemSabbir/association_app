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
      appBar: AppBar(title: const Text(AppUtils.membersSectionTitle),centerTitle: true,),
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
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
            )); // Show message if no members
          }

          final uniquePhones = <String>{}; // Using Set for unique phone numbers
          final uniqueMembers = <QueryDocumentSnapshot<Object?>>[];

          for (var doc in snapshot.data!.docs) {
            // Cast to QueryDocumentSnapshot
            final QueryDocumentSnapshot<Object?> memberDoc = doc;
            String phone = memberDoc['phone'];
            if (!uniquePhones.contains(phone)) {
              uniquePhones.add(phone);
              uniqueMembers.add(memberDoc);
            }
          }


          return ListView.builder(
            itemCount: uniqueMembers.length,
            itemBuilder: (context, index) {
              final member = uniqueMembers[index];
              final id = member['id'];
              final String name = member['name'];
              final String phone = member['phone'];
              final userRule = box.read("userRule");

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Circle Avatar for Name's Initial
                        CircleAvatar(
                          backgroundColor: CustomColors.primaryColor,
                          child: Text(
                            name[0],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Name and Phone Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name and Phone
                              Row(
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
                                      phone,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Total Investment Info (from Firestore)
                              _firestoreService.showTotalInvestment(phone),
                            ],
                          ),
                        ),

                        // Popup Menu for Admin
                        if (userRule == "Admin")
                          PopupMenuButton<String>(
                            onSelected: (String result) {
                              if (result == 'Edit') {
                                showEditDialog(context, member,id); // Call edit method
                              } else if (result == 'Delete') {
                                showDeleteDialog(context, phone); // Call delete method
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

  void showDeleteDialog(BuildContext context, String phone) {
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
                  "Do you want to delete this member?",
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
                        _firestoreService.deleteMember(phone, context);
                      },
                      child: const Text('Delete'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: const Text('Cancel'),
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
  void showEditDialog(BuildContext context, QueryDocumentSnapshot member,id) {
    final nameController = TextEditingController(text: member['name']);
    final phoneController = TextEditingController(text: member['phone']);

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
                  "Edit Member",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: nameController,
                  label: 'Name',
                ),
                const SizedBox(height: 12,),
                CustomTextField(
                  controller: phoneController,
                  label: 'Phone',
                  keyboardType: TextInputType.phone,
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
                        final newName = nameController.text;
                        final newPhone = phoneController.text;

                        // Check for duplicate phone number
                        var snapshot = await FirebaseFirestore.instance
                            .collection('members')
                            .where('phone', isEqualTo: newPhone)
                            .get();

                        if (snapshot.docs.isNotEmpty && newPhone != member['phone']) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Phone number already exists!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {

                          try {
                            // Query the collection to find the document where the phone matches the oldPhone
                            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                .collection('members')
                                .where('phone', isEqualTo: member['phone'])
                                .get();

                            if (querySnapshot.docs.isNotEmpty) {
                              for (var doc in querySnapshot.docs) {
                                await FirebaseFirestore.instance
                                    .collection('members')
                                    .doc(doc.id) // Use the document ID from the query
                                    .update({
                                  'name': newName,
                                  'phone': newPhone,
                                });
                              }
                            } else {
                              print("Member with phone number $member['phone'] not found.");
                            }
                          } catch (e) {
                            print("Error updating member: $e");
                          }
                          Navigator.of(context).pop(); // Close the dialog
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
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
                              errorMessage.value = '';

                              _firestoreService.addMember(
                                phone: phoneController.text,
                                name: nameController.text,
                                date: formattedDate,
                              );

                              Navigator.of(context).pop(); // Close dialog after saving
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
