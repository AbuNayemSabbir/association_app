import 'package:association_app/utills/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RxBool isAddMemberLoading=false.obs;
  // Get all expenses as a stream
  Stream<QuerySnapshot> getAllExpenses() {
    return _db.collection('expense').snapshots();
  }

  // Add a new expense to Firestore
  Future<void> addExpense({required String expenseTitle, required double expenseAmount, required String date}) async {
    await _db.collection('expense').add({
      'expense_title': expenseTitle,
      'expense_amount': expenseAmount,
      'date': date,
    });
  }


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
  Future<void> addDeposit({
    required String date,
    required String name,
    required String phone,
    required String amount,
  }) async {
    try {
      isAddMemberLoading.value=true;
      await _db.collection('members').add({
        'date': date,
        'invest_amount': amount,
        'invest_title': null,
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


  Stream<QuerySnapshot> getDepositsByPhoneNumber(String phoneNumber) {
    return _db.collection('members').where('phone', isEqualTo: phoneNumber).snapshots();
  }
  Future<double> getTotalInvestment(String phoneNumber) async {
    try {
      // Fetch the document using phone number as a query
      final querySnapshot = await _db.collection('members')
          .where('phone', isEqualTo: phoneNumber)
          .get();

      // Check if any documents were returned
      if (querySnapshot.docs.isNotEmpty) {
        double totalInvestment = 0.0;

        // Iterate over the returned documents (there should ideally be only one)
        for (var memberDoc in querySnapshot.docs) {
          // Assuming invest_amount is a field within the member document
          var investAmount = memberDoc.data();

          investAmount.forEach((key, value) {
            if (key.startsWith('invest_amount')) {
              if (value is String) {
                totalInvestment += double.tryParse(value) ?? 0.0;
              } else if (value is num) {
                totalInvestment += value.toDouble();
              }
            }
          });
        }

        return totalInvestment;
      } else {
        print("No document found for phone number: $phoneNumber");
      }
    } catch (e) {
      print("Error fetching document: $e");
    }

    return 0.0; // Return 0 if document doesn't exist or an error occurred
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
          return const Center(child: CircularProgressIndicator()); // Show loading indicator
        }
        if (snapshot.hasError) {
          return const Text('Error');
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Flexible(
              child: Text(
                'Total Invest:  ',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Text(
                '${snapshot.data?.toStringAsFixed(2) ?? '0.00'} Taka',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteMember(String phoneNumber, BuildContext context) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('members')
          .where('phone', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await _db.collection('members').doc(doc.id).delete();
        }
        Navigator.of(context).pop(); // Close dialog
        Get.snackbar(
          'Success',
          'Member deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Member not found',
          colorText: CustomColors.errorColor,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: CustomColors.errorColor,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  Future<double> getAllTotalInvestment() async {
    double totalInvestment = 0.0;

    try {
      QuerySnapshot snapshot = await _db.collection('members').get();
      for (var doc in snapshot.docs) {
        double? investAmount = double.tryParse(doc['invest_amount']??"0.0");
        if (investAmount != null) {
          totalInvestment += investAmount;
        }
      }
    } catch (e) {
      print("Error fetching total investment: $e");
      return 0.0;
    }
    return totalInvestment;
  }

  // Method to fetch Total Expense from 'expense' collection
  Future<double> getTotalExpense() async {
    double totalExpense = 0.0;

    try {
      QuerySnapshot snapshot = await _db.collection('expense').get();
      for (var doc in snapshot.docs) {
        double? expenseAmount = double.tryParse(doc['expense_amount']??"0.0");
        if (expenseAmount != null) {
          totalExpense += expenseAmount;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching total expense: $e");
      }
      return 0.0;
    }
    return totalExpense;
  }

  // Method to calculate the Total Balance by subtracting totalExpense from totalInvestment
  Future<double> getTotalBalance() async {
    double totalInvestment = await getAllTotalInvestment();
    double totalExpense = await getTotalExpense();

    return totalInvestment - totalExpense;
  }

}
