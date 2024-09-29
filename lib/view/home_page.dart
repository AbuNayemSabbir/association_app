import 'package:association_app/routes/app_routes.dart';
import 'package:association_app/services/fire_store_services.dart';
import 'package:association_app/utills/app_utills.dart';
import 'package:association_app/utills/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'all_deposit_page.dart';
import 'expense_page.dart';
import 'indivisual_member_page.dart';
import 'members_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirestoreService _firebaseService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(AppUtils.dashboardTitle),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset("assets/icons/app_icon.png"),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  AppUtils.appName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(height: 16),

// Total Balance Card using StreamBuilder
              StreamBuilder<double>(
                stream: _firebaseService.getTotalBalanceStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching total balance');
                  }
                  return _buildSummaryCard(
                    title: AppUtils.totalBalanceTitle,
                    value: "৳ ${snapshot.data?.toStringAsFixed(2) ?? '0.00'}",
                    icon: Icons.account_balance_wallet,
                    valueColor: CustomColors.primaryColor,
                  );
                },
              ),
              const SizedBox(height: 10),

// Total Investment Card using StreamBuilder
              StreamBuilder<double>(
                stream: _firebaseService.getAllTotalInvestmentStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching total investment');
                  }
                  return _buildSummaryCard(
                    title: AppUtils.totalDeposit,
                    value: "৳ ${snapshot.data?.toStringAsFixed(2) ?? '0.00'}",
                    icon: Icons.monetization_on,
                    valueColor: Colors.green,
                  );
                },
              ),
              const SizedBox(height: 10),

// Total Expense Card using StreamBuilder
              StreamBuilder<double>(
                stream: _firebaseService.getTotalExpenseStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching total expense');
                  }
                  return _buildSummaryCard(
                    title: AppUtils.totalExpense,
                    value: "৳ ${snapshot.data?.toStringAsFixed(2) ?? '0.00'}",
                    icon: Icons.money_off,
                    valueColor: Colors.red,
                  );
                },
              ),

              const SizedBox(height: 20),
              _buildDashboardButton(
                title: AppUtils.membersInfoTitle,
                icon: Icons.people,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MembersPage())),
              ),
              _buildDashboardButton(
                title: AppUtils.allDepositsInfoTitle,
                icon: Icons.account_balance,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllDepositsPage())),
              ),
              _buildDashboardButton(
                title: AppUtils.allExpensesInfoTitle,
                icon: Icons.money_off,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllExpensesPage())),
              ),
              _buildDashboardButton(
                title: AppUtils.individualDepositInfoTitle,
                icon: Icons.person_search,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IndividualMemberPage())),
              ),
            ],
          ),
        ),
      ),
      endDrawer: _buildEndDrawer(), // End drawer added
    );
  }

  // Method to build a summary card for total balance, investment, etc.
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: valueColor, size: 40),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to build dashboard buttons for navigation
  Widget _buildDashboardButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: CustomColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CustomColors.primaryColor, width: 2),
          ),
          child: Row(
            children: [
              Icon(icon, color: CustomColors.primaryColor, size: 30),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Drawer widget for navigation
  Widget _buildEndDrawer() {
    return SafeArea(
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: CustomColors.primaryColor.withOpacity(0.8),
              ),
              child: const Center(
                child: Text(
                  AppUtils.appName,
                  style: TextStyle(
                    color: CustomColors.primaryDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text(AppUtils.membersInfoTitle,style: TextStyle(color: CustomColors.primaryColor),),
              leading: const Icon(Icons.people,color: CustomColors.primaryColor),
              onTap: () {
                Get.back();
                Navigator.push(context, MaterialPageRoute(builder: (context) => MembersPage()));
              }
            ),
            ListTile(
              title: const Text(AppUtils.allDepositsInfoTitle,style: TextStyle(color: CustomColors.primaryColor),),
              leading: const Icon(Icons.account_balance,color: CustomColors.primaryColor),
              onTap: () {
                Get.back();
                Navigator.push(context, MaterialPageRoute(builder: (context) => AllDepositsPage()));
              }
            ),
            ListTile(
              title: const Text(AppUtils.allExpensesInfoTitle,style: TextStyle(color: CustomColors.primaryColor),),
              leading: const Icon(Icons.money_off,color: CustomColors.primaryColor),
              onTap: () {
                Get.back();
                Navigator.push(context, MaterialPageRoute(builder: (context) => AllExpensesPage()));
              }
            ),
            ListTile(
              title: const Text(AppUtils.individualDepositInfoTitle,style: TextStyle(color: CustomColors.primaryColor),),
              leading: const Icon(Icons.person_search,color: CustomColors.primaryColor,),
              onTap: () {
                Get.back();
                Navigator.push(context, MaterialPageRoute(builder: (context) => IndividualMemberPage()));
              }
            ),
            const Spacer(), // Pushes the logout button to the bottom
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Logout functionality
  void _logout() {
    final box = GetStorage();
    box.remove('userRule');
    box.remove('isLoggedIn');
    Get.offAllNamed(AppRoutes.login);
  }
}
