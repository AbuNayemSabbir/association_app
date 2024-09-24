import 'package:association_app/utills/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RxBool isAddMemberLoading=false.obs;
  Future<void> addMember({
    required String date,
    required String name,
    required String phone,
  }) async {
    try {
      isAddMemberLoading.value=true;
      await _db.collection('members').add({
        'date': date,
        'invest_amount': null,   // Setting invest_amount as null
        'invest_title': null,    // Setting invest_title as null
        'name': name,
        'phone': phone,
      });
      isAddMemberLoading.value=false;
      Get.snackbar('Success', "Members add Successfully",snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', "e",colorText: CustomColors.errorColor,snackPosition: SnackPosition.BOTTOM);     }
  }

  Stream<QuerySnapshot> getAllDeposits() {
    return _db.collection('members').orderBy('date').snapshots();
  }

  Stream<QuerySnapshot> getAllExpenses() {
    return _db.collection('expenses').orderBy('date').snapshots();
  }

  Stream<QuerySnapshot> getDepositsByPhoneNumber(String phoneNumber) {
    return _db.collection('members').where('phoneNumber', isEqualTo: phoneNumber).snapshots();
  }

  Future<double> getTotalInvestment(String phoneNumber) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('members')
        .doc(phoneNumber)
        .collection('investments') // Assuming you have a subcollection for investments
        .get();

    double totalInvestment = 0;
    for (var doc in querySnapshot.docs) {
      totalInvestment += double.tryParse(doc['invest_amount']) ?? 0;
    }
    return totalInvestment;
  }

  // Function to check for duplicate phone numbers
  Future<bool> checkDuplicatePhoneNumber(String phoneNumber) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('members')
        .where('phone', isEqualTo: phoneNumber)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  FutureBuilder<double> showTotalInvestment(String phoneNumber) {
    return FutureBuilder<double>(
      future: getTotalInvestment(phoneNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator
        }
        if (snapshot.hasError) {
          return const Text('Error');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Total Invest: '),
            Text('\$${snapshot.data?.toStringAsFixed(2) ?? '0.00'}'),
          ],
        );
      },
    );
  }
  Future<void> deleteMember(String phoneNumber,context) async {
    try {
      // Query for the document with the matching phone number
      QuerySnapshot querySnapshot = await _db.collection('members').where('phone', isEqualTo: phoneNumber).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await _db.collection('members').doc(doc.id).delete(); // Delete each matched document
        }
        Navigator.of(context).pop(); // Close the dialog without saving

        Get.snackbar('Success', 'Member deleted successfully', snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Member not found', colorText: CustomColors.errorColor, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: CustomColors.errorColor, snackPosition: SnackPosition.BOTTOM);
    }
  }

}
