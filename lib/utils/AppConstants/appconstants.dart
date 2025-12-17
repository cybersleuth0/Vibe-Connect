import 'package:chat_app/utils/custom_page_route.dart';
import 'package:flutter/cupertino.dart';

import '../../Screens/Auth/SignIn.dart';
import '../../Screens/Auth/SignUp.dart';
import '../../Screens/Core/SplashScreen.dart';
import '../../Screens/Chat/ChatScreen.dart';
import '../../Screens/Core/HomePage.dart';
import '../../Screens/Onboarding/OnboardingPage.dart';

class AppRoutes {
  static const String ROUTE_SPLASHPAGE = "/";  // Root route
  static const String ROUTE_ONBOARDINGPAGE = "/welcome";
  static const String ROUTE_SIGNINPAGE = "/auth/login";
  static const String ROUTE_SIGNUPPAGE = "/auth/register";
  static const String ROUTE_HOMEPAGE = "/dashboard";
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
      case ROUTE_SIGNUPPAGE:
        return SlideUpPageRoute(
          child: const SignUpPage(),
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