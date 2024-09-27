import 'package:flutter/material.dart';

import 'custom_colors.dart';

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
  static const String loadingMessage = 'Loading...';
  static  String error = 'Error';
  static const String errorMessage = 'An error occurred. Please try again later.';
  static  String success = 'Success';
  static const String successMessageMemberAdd = 'Members add Successfully';
  static const String successMessageMemberDelete = 'Member deleted successfully';
  static const String successMessageDepositAdd = 'Deposit added Successfully';
  static const String successMessageDepositDelete= 'Deposit deleted Successfully';
  static const String successMessageExpenseAdd = 'An error occurred. Please try again later.';
  static const String successMessageExpenseDelete = 'Expense deleted successfully';
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