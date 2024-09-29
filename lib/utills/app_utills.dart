import 'package:flutter/material.dart';

import 'custom_colors.dart';

/*
class AppUtils {
  // App Name
  static const String appName = 'Association App';

  // Dashboard Titles
  static const String dashboardTitle = 'Dashboard';
  static const String totalBalanceTitle = 'Total Balance:';
  static const String membersInfoTitle = 'Members Information';
  static const String allDepositsInfoTitle = 'All Deposit Information';
  static const String allExpensesInfoTitle = 'All Expense Information';
  static const String individualDepositInfoTitle = 'Individual Deposit Information';

  // Member Section Titles
  static const String membersSectionTitle = 'Members Section';
  static const String allMembersInfoTitle = 'All Members Information';

  static const String editTitle = 'Edit Member';
  static const String updateAmountTitle = 'Update Amount';
  static const String amountLabel = 'Amount';
  static const String nameLabel = 'Member Name';
  static const String newMemberAddTitle = 'Add new Member';
  static const String phoneLabel = 'Member Phone';
  static const String expenseTitleLabel = 'Expense Title';
  static const String passwordWarning = 'Please must be 8 characters';
  static const String fieldWarning = 'field is required field';
  static const String deleteWarning = 'Do you want to delete?';

  // Deposit Section Titles
  static const String allDepositSectionTitle = 'All Deposit Section';
  static const String showAllDepositsTitle = 'Show All Deposits';

  // Expense Section Titles
  static const String allExpenseSectionTitle = 'All Expense Section';
  static const String showAllExpensesTitle = 'Show All Expenses';

  // Individual Section Titles
  static const String individualSectionTitle = 'Individual Section';
  static const String showAllMembersTitle = 'Show All Members';
  static const String memberDepositInfoTitle = 'Member Deposit Information';

  // Common
  static const String numberOfExpense = 'Expense';
  static const String numberOfDeposit = 'Deposit';
  static const String totalDeposit = 'Total Deposit: ';
  static const String totalExpense = 'Total Expense: ';
  static const String amount = 'Amount: ';
  static const String amount1 = 'Amount';
  static const String emptyMembersTitle = 'You have no members. Please Add your association members';
  static const String emptyAllDepositTitle = 'You have no deposit yet.';
  static const String emptyDepositTitle = 'You have no deposit yet.';
  static const String emptyExpenseTitle = 'You have no expense yet.';
  static const String saveButtonTitle = 'Save';
  static const String loginButtonTitle = 'Login';
  static const String addMemberButtonTitle = 'Add Member';
  static const String addDepositButtonTitle = 'Add Deposit';
  static const String detailsDepositButtonTitle = 'Details View';
  static const String addExpenseButtonTitle = 'Add Expense';
  static const String cancelButtonTitle = 'Cancel';
  static const String deleteButton = 'Delete';
  static const String loadingMessage = 'Loading...';
  static  String error = 'Error';
  static const String errorMessage = 'Phone number already exists!';
  static  String success = 'Success';
  static const String successMessageMemberAdd = 'Members add Successfully';
  static const String successMessageMemberDelete = 'Member deleted successfully';
  static const String successMessageDepositAdd = 'Deposit added Successfully';
  static const String successMessageDepositDelete= 'Deposit deleted Successfully';
  static const String successMessageExpenseAdd = 'An error occurred. Please try again later.';
  static const String successMessageExpenseDelete = 'Expense deleted successfully';
  static const String successMessageExpenseUpdate = 'Expense Update successfully';
}
*/
class AppUtils {
  // অ্যাপ নাম
  static const String appName = 'ইত্তেহাদুল মুুদাররিস ফান্ড';
  static const String incorrectPassword = 'ভুল পাসওয়ার্ড';

  // ড্যাশবোর্ড শিরোনাম
  static const String dashboardTitle = 'ড্যাশবোর্ড';
  static const String totalBalanceTitle = 'মোট ব্যালেন্স:';
  static const String membersInfoTitle = 'সদস্যদের তথ্য';
  static const String allDepositsInfoTitle = 'সমস্ত জমার তথ্য';
  static const String allExpensesInfoTitle = 'সমস্ত খরচের তথ্য';
  static const String individualDepositInfoTitle = 'ব্যক্তিগত জমার তথ্য';

  // সদস্য বিভাগ শিরোনাম
  static const String membersSectionTitle = 'সদস্য বিভাগ';
  static const String allMembersInfoTitle = 'সমস্ত সদস্যের তথ্য';
  static const String newMemberAddTitle = 'নতুন সদস্য যোগ করুন';
  static const String addMemberButtonTitle = 'সদস্য যোগ করুন';
  static const String editTitle = 'সদস্য সম্পাদনা';
  static const String nameLabel = 'সদস্যের নাম';
  static const String phoneLabel = 'সদস্যের ফোন';

  // জমা বিভাগ শিরোনাম
  static const String allDepositSectionTitle = 'সমস্ত জমা বিভাগ';
  static const String showAllDepositsTitle = 'সমস্ত জমা দেখুন';
  static const String memberDepositInfoTitle = 'সদস্যের জমার তথ্য';
  static const String addDepositButtonTitle = 'টাকা যোগ করুন';
  static const String detailsDepositButtonTitle = 'বিস্তারিত দেখুন';
  static const String updateAmountTitle = 'পরিমাণ হালনাগাদ করুন';
  static const String numberOfDeposit = 'জমা সংখ্যা';
  static const String totalDeposit = 'মোট জমা: ';

  // খরচ বিভাগ শিরোনাম
  static const String allExpenseSectionTitle = 'সমস্ত খরচ বিভাগ';
  static const String showAllExpensesTitle = 'সমস্ত খরচ দেখুন';
  static const String expenseTitleLabel = 'খরচের শিরোনাম';
  static const String addExpenseButtonTitle = 'খরচ যোগ করুন';
  static const String numberOfExpense = 'খরচ সংখ্যা';
  static const String totalExpense = 'মোট খরচ: ';

  // সাধারণ শিরোনাম এবং বার্তা
  static const String amountLabel = 'পরিমাণ';
  static const String amount = 'পরিমাণ: ';
  static const String amount1 = 'পরিমাণ';
  static const String saveButtonTitle = 'সংরক্ষণ';
  static const String loginButtonTitle = 'লগইন';
  static const String cancelButtonTitle = 'বাতিল করুন';
  static const String deleteButton = 'মুছে ফেলুন';

  // সতর্কতা এবং বার্তা
  static const String passwordWarning = 'অনুগ্রহ করে ৮ অক্ষরের পাসওয়ার্ড দিন';
  static const String fieldWarning = 'এই ঘর পূরণ করা আবশ্যক';
  static const String deleteWarning = 'আপনি কি মুছতে চান?';
  static const String loadingMessage = 'লোড হচ্ছে...';

  // সফলতার বার্তা
  static const String successMessageMemberAdd = 'সদস্য সফলভাবে যোগ করা হয়েছে';
  static const String successMessageMemberDelete = 'সদস্য সফলভাবে মুছে ফেলা হয়েছে';
  static const String successMessageDepositAdd = 'জমা সফলভাবে যোগ করা হয়েছে';
  static const String successMessageDepositDelete = 'জমা সফলভাবে মুছে ফেলা হয়েছে';
  static const String successMessageExpenseAdd = 'খরচ সফলভাবে যোগ করা হয়েছে';
  static const String successMessageExpenseDelete = 'খরচ সফলভাবে মুছে ফেলা হয়েছে';
  static const String successMessageExpenseUpdate = 'খরচ সফলভাবে আপডেট করা হয়েছে';

  // ত্রুটি বার্তা
  static String error = 'ত্রুটি';
  static const String errorMessage = 'ফোন নম্বর ইতিমধ্যেই রয়েছে!';
  static String success = 'সফল';

  // খালি বার্তা
  static const String emptyMembersTitle = 'আপনার কোনো সদস্য নেই। অনুগ্রহ করে সদস্য যোগ করুন।';
  static const String emptyAllDepositTitle = 'আপনার কোনো জমা নেই।';
  static const String emptyDepositTitle = 'আপনার কোনো জমা নেই।';
  static const String emptyExpenseTitle = 'আপনার কোনো খরচ নেই।';
}

BoxDecoration customBoxDecoration({
  Color borderColor = CustomColors.grey300,
  Color boxColor = Colors.white,
  double borderRadius = 8,
  double borderWidth = 1.0,
}) {
  return BoxDecoration(
    border: Border.all(
      color: borderColor,
      width: borderWidth,
    ),
    color: boxColor ,
    borderRadius: BorderRadius.circular(borderRadius),
  );
}