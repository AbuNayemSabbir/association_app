import 'package:association_app/routes/app_routes.dart';
import 'package:association_app/utills/app_utills.dart';
import 'package:association_app/utills/custom_colors.dart';
import 'package:association_app/view/helper_widget/custom_elevated_button.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(AppUtils.dashboardTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
              },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(AppUtils.appName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Container(
                 width: context.width,
                 height: 80,
                 decoration: customBoxDecoration(),
                 child: const Padding(
                   padding: EdgeInsets.all(12.0),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(AppUtils.totalBalanceTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                       Text(" \$xxxx", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColors.primaryColor)),
                     ],
                   ),
                 ),
               ),
             ),
            const SizedBox(height: 10),
            _buildContainer(
              title: AppUtils.membersInfoTitle,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MembersPage())),
            ),
            _buildContainer(
              title: AppUtils.allDepositsInfoTitle,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllDepositsPage())),
            ),
            _buildContainer(
              title: AppUtils.allExpensesInfoTitle,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllExpensesPage())),
            ),
            _buildContainer(
              title: AppUtils.individualDepositInfoTitle,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const IndividualMemberPage())),
            ),
          ],
        ),
      ),
      endDrawer: _buildEndDrawer(), // End drawer added
    );
  }

  Widget _buildContainer({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        decoration: customBoxDecoration(),
        child: CustomElevatedButton(
          title: title,
          onPressed: onTap,
          color: CustomColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildEndDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: CustomColors.primaryColor,
            ),
            child: Center(
              child: Text("hhhbh",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("gjgjh"),
            onTap: () {
              // Add navigation to profile section here
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("hjh"),
            onTap: () {
              // Add navigation to settings section here
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title:  const Text('gj'),
            onTap: () {
              // Add navigation to notifications section here
            },
          ),
          const Spacer(), // Pushes the logout button to the bottom
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Add logout functionality here
              _logout();
            },
          ),
        ],
      ),
    );
  }

  void _logout() {
    final box = GetStorage();
    box.remove('userRule');
    box.remove('isLoggedIn');
    Get.offAllNamed(AppRoutes.login);

  }
}
