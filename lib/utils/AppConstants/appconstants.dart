import 'package:flutter/cupertino.dart';

import '../../SplashScreen.dart';
import '../../login.dart';

class AppRoutes {
  static const String ROUTE_SPLASHPAGE = "/splash";
  static const String ROUTE_LOGINPAGE = "/login";

  static Map<String, WidgetBuilder> getRoutes() => {
    ROUTE_SPLASHPAGE: (context) => SplashPage(),
    ROUTE_LOGINPAGE: (context) => LoginPage(),
  };
}
