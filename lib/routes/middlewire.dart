import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:get_storage/get_storage.dart';

class AuthMiddleware extends GetMiddleware {

  @override
  RouteSettings? redirect(String? route) {
    final box = GetStorage();
    final isLoggedIn = box.read('isLoggedIn') ?? false;
    print(isLoggedIn);
    if (!isLoggedIn) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}
