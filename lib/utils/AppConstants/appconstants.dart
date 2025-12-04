import 'package:chat_app/Screens/homepage.dart';
import 'package:chat_app/utils/custom_page_route.dart';
import 'package:flutter/cupertino.dart';

import '../../Screens/SignIn.dart';
import '../../Screens/SplashScreen.dart';
import '../../Screens/chatscreen.dart';
import '../../Screens/onboarding.dart';

class AppRoutes {
  static const String ROUTE_SPLASHPAGE = "/splash";
  static const String ROUTE_ONBOARDINGPAGE = "/onboarding";
  static const String ROUTE_SIGNINPAGE = "/signin";
  static const String ROUTE_SIGNUPPAGE = "/signup";
  static const String ROUTE_HOMEPAGE = "/home";
  static const String ROUTE_CHATSCREEN = "/chat";

  // OLD METHOD - Not used anymore but kept for reference
  // static Map<String, WidgetBuilder> getRoutes() => {
  //   ROUTE_SPLASHPAGE: (context) => const SplashPage(),
  //   ROUTE_ONBOARDINGPAGE: (context) => const OnBoardingPage(),
  //   ROUTE_SIGNINPAGE: (context) => const SignInPage(),
  //   ROUTE_HOMEPAGE: (context) => const HomePage(),
  //   ROUTE_CHATSCREEN: (context) => const ChatScreen(),
  // };

  // NEW METHOD - Custom route generator with fade transitions
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ROUTE_SPLASHPAGE:
        return FadePageRoute(
          child: const SplashPage(),
          settings: settings,
        );
      case ROUTE_ONBOARDINGPAGE:
        return FadePageRoute(
          child: const OnBoardingPage(),
          settings: settings,
        );
      case ROUTE_SIGNINPAGE:
        return SlideUpPageRoute(
          child: const SignInPage(),
          settings: settings,
        );
      case ROUTE_HOMEPAGE:
        return FadePageRoute(
          child: const HomePage(),
          settings: settings,
        );
      case ROUTE_CHATSCREEN:
        return SharedAxisPageRoute(
          child: const ChatScreen(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}