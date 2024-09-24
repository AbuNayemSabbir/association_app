import 'package:association_app/view/home_page.dart';
import 'package:get/get.dart';

import '../view/login_page.dart';
import 'middlewire.dart';


class AppRoutes {
  static const String initial = '/';
  static const String main = '/main';
  static const String home = '/home';
  static const String login = '/login';


  static final List<GetPage> routes = [
    GetPage(name: initial, page: () => DashboardPage(),middlewares: [AuthMiddleware()],),
   // GetPage(name: main, page: () =>  MainPage()),
    GetPage(name: login, page: () =>  const LoginPage()),

    GetPage(name: home, page: () =>   DashboardPage()),

  ];
}