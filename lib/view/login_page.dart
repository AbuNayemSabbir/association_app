

import 'package:association_app/controller/association_controller.dart';
import 'package:association_app/routes/app_routes.dart';
import 'package:association_app/utills/app_utills.dart';
import 'package:association_app/utills/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'helper_widget/custom_elevated_button.dart';
import 'helper_widget/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailTextEditingController =TextEditingController();
  TextEditingController passwordTextEditingController =TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AssociationController associationController = Get.put(AssociationController());


  @override
  void dispose() {
    emailTextEditingController.clearComposing();
    passwordTextEditingController.clearComposing();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: context.width,
              decoration: customBoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 12),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /* SvgPicture.asset(
                        'assets/icons/logo.svg',
                        height: 100,
                      ),*/
                      // const SizedBox(height: 24),
                      const Center(
                        child: Text(AppUtils.appName,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: CustomColors.grey900),),
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 24),
                       PopupMenuButton<String>(
                        onSelected: (String value) {
                          associationController.rule.value = value;
                          emailTextEditingController.text=associationController.rule.value;
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Member',
                            child: Text('Member'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Admin',
                            child: Text('Admin'),
                          ),
                        ],
                        child: AbsorbPointer(
                          absorbing: true,
                          child: CustomTextField(
                              controller: emailTextEditingController,
                              label: "User Rule",
                              isSuffixIcon: true,
                            ),
                        ),

                  ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Password', controller: passwordTextEditingController,
                        isPassword: true,
                      ),
                      const SizedBox(height: 24),

                      Obx(() {
                        return CustomElevatedButton(
                          color: CustomColors.primaryColor,
                          isLoading: associationController.isLoading.value,
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                FocusScope.of(context).unfocus();
                              });

                              if ((emailTextEditingController.text == "Member" && passwordTextEditingController.text == "Member1122") ||
                                  (emailTextEditingController.text == "Admin" && passwordTextEditingController.text == "Admin1122")) {
                                final box = GetStorage();
                                associationController.isLoading.value = true;  // Start loading
                                await Future.delayed(const Duration(seconds: 2)).then((_){
                                  associationController.isLoading.value = false;
                                  Get.offAllNamed(AppRoutes.home);
                                  box.write('isLoggedIn', true);
                                  box.write('userRule', emailTextEditingController.text);
                                });
                              }
                            }
                          },
                          title: 'Sign In',
                        );

                      }
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
