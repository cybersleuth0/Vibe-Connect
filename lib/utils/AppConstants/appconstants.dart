import 'package:flutter/cupertino.dart';

import '../../Screens/SignIn.dart';
import '../../Screens/SplashScreen.dart';
import '../../Screens/onboarding.dart';

class AppRoutes {
  static const String ROUTE_SPLASHPAGE = "/splash";
  static const String ROUTE_ONBOARDINGPAGE = "/onboarding";
  static const String ROUTE_SIGNINPAGE = "/signin";
  static const String ROUTE_SIGNUPPAGE = "/signup";

  static Map<String, WidgetBuilder> getRoutes() => {
    ROUTE_SPLASHPAGE: (context) => SplashPage(),
    ROUTE_ONBOARDINGPAGE: (context) => OnBoardingPage(),
    ROUTE_SIGNINPAGE: (context) => SignInPage(),
  };
}
