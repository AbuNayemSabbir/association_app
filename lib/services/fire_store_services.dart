import 'package:association_app/utills/app_utills.dart';
import 'package:association_app/utills/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RxBool isAddMemberLoading=false.obs;
  // Get all expenses as a stream
  Stream<QuerySnapshot> getAllExpenses() {
    return _db.collection('expense').snapshots();
  }

  // Add a new expense to Firestore
  Future<void> addExpense({
    required String expenseTitle,
    required String expenseAmount,
    required String date,
  }) async {
    try {
      // Create a new document reference (this will auto-generate an ID)
      final docRef = _db.collection('expense').doc();

      await docRef.set({
        'expense_title': expenseTitle,
        'expense_amount': expenseAmount,
        'date': date,
        'id': docRef.id,
      });

      Get.snackbar('Success', "Expense added successfully", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', "Failed to add expense", colorText: CustomColors.errorColor, snackPosition: SnackPosition.BOTTOM);
    }
  }


  Future<void> addMember({
    required String date,
    required String name,
    required String phone,
  }) async {
    try {
      isAddMemberLoading.value = true;

      // Create a new document reference (this will auto-generate an ID)
      final docRef = _db.collection('members').doc();

      await docRef.set({
        'date': date,
        'invest_amount': null,   // Setting invest_amount as null
        'invest_title': null,    // Setting invest_title as null
        'name': name,
        'phone': phone,
        'id': docRef.id,  // Set the auto-generated ID inside the document
      });

      isAddMemberLoading.value = false;
      Get.snackbar('Success', "Member added successfully", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      isAddMemberLoading.value = false;
      Get.snackbar('Error', e.toString(), colorText: CustomColors.errorColor, snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addDeposit({
    required String date,
    required String name,
    required String phone,
    required String amount,
  }) async {
    try {
      isAddMemberLoading.value=true;
      final docRef = _db.collection('members').doc();

      await _db.collection('members').add({
        'date': date,
        'invest_amount': amount,
        'invest_title': null,
        'name': name,
        'phone': phone,
        'id': docRef.id
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.monetization_on, color: CustomColors.primaryColor, size: 16),
            const SizedBox(width: 6),
            const Flexible(
              child: Text(
                AppUtils.totalDeposit,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Text(
                '৳ ${snapshot.data?.toStringAsFixed(2) ?? '0.00'}',
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
  Future<void> deleteDeposit(String id, BuildContext context) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('members')
          .where('id', isEqualTo: id)
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
  Future<void> deleteExpenseByID(String id, BuildContext context) async {
    try {
      // Fetch the document by ID
      QuerySnapshot querySnapshot = await _db
          .collection('expense')
          .where('id', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await _db.collection('expense').doc(doc.id).delete();
        }

        Navigator.of(context).pop(); // Close dialog
        Get.snackbar(
          'Success',
          'This Expense delete successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Expense not found',
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

// Stream to get the Total Investment from 'members' collection
  Stream<double> getAllTotalInvestmentStream() {
    return _db.collection('members').snapshots().map((snapshot) {
      double totalInvestment = 0.0;
      for (var doc in snapshot.docs) {
        double? investAmount = double.tryParse(doc['invest_amount'] ?? "0.0");
        if (investAmount != null) {
          totalInvestment += investAmount;
        }
      }
      return totalInvestment;
    });
  }

// Stream to get the Total Expense from 'expense' collection
  Stream<double> getTotalExpenseStream() {
    return _db.collection('expense').snapshots().map((snapshot) {
      double totalExpense = 0.0;
      for (var doc in snapshot.docs) {
        double? expenseAmount = double.tryParse(doc['expense_amount'] ?? "0.0");
        if (expenseAmount != null) {
          totalExpense += expenseAmount;
        }
      }
      return totalExpense;
    });
  }

// Stream to calculate the Total Balance by subtracting totalExpense from totalInvestment
  Stream<double> getTotalBalanceStream() {
    return CombineLatestStream.combine2(
      getAllTotalInvestmentStream(),
      getTotalExpenseStream(),
          (double totalInvestment, double totalExpense) {
        return totalInvestment - totalExpense;
      },
    );
  }
}
