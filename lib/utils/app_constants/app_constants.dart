import "package:vibe_connect/screens/auth/login_cubit/login_cubit.dart";
import "package:vibe_connect/screens/auth/profile_setup.dart";
import "package:vibe_connect/screens/auth/profile_setup_cubit/profile_setup_cubit.dart";
import "package:vibe_connect/screens/chat/chat_cubit/chat_cubit.dart";
import "package:vibe_connect/screens/core/home_cubit/home_cubit.dart";
import "package:vibe_connect/utils/custom_page_route.dart";
import "package:flutter/cupertino.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../data/remote/repository/firebase_repository.dart";
import "../../screens/auth/sign_in.dart";
import "../../screens/auth/sign_up.dart";
import "../../screens/auth/sign_up_cubit/sign_up_cubit.dart";
import "../../screens/chat/chat_screen.dart";
import "../../screens/core/home_page.dart";
import "../../screens/core/select_user_to_chat.dart";
import "../../screens/splash/splash_screen.dart";
import "../../screens/onboarding/onboarding_page.dart";

class AppRoutes {
  static const String ROUTE_SPLASHPAGE = "/"; // Root route
  static const String ROUTE_ONBOARDINGPAGE = "/welcome";
  static const String ROUTE_SIGNINPAGE = "/auth/login";
  static const String ROUTE_SIGNUPPAGE = "/auth/register";
  static const String ROUTE_PROFILE_SETUP = "/auth/profile_setup";
  static const String ROUTE_HOMEPAGE = "/dashboard";
  static const String ROUTE_CHATSCREEN = "/chat";
  static const String ROUTE_SELECT_USER_TO_CHAT_SCREEN = "/select-user-to-chat";

  // NEW METHOD - Custom route generator with fade transitions
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ROUTE_SPLASHPAGE:
        return FadePageRoute(child: const SplashPage(), settings: settings);
      case ROUTE_ONBOARDINGPAGE:
        return FadePageRoute(child: const OnBoardingPage(), settings: settings);
      case ROUTE_SIGNINPAGE:
        return SlideUpPageRoute(
          child: BlocProvider(
            create: (context) => LoginCubit(firebaseRepository: FirebaseRepository()),
            child: const SignInPage(),
          ),
          settings: settings,
        );
      case ROUTE_SIGNUPPAGE:
        return SlideUpPageRoute(
          child: BlocProvider(
            create: (context) => RegisterCubit(firebaseRepository: FirebaseRepository()),
            child: const SignUpPage(),
          ),
          settings: settings,
        );
      case ROUTE_PROFILE_SETUP:
        return SlideUpPageRoute(
          child: BlocProvider(
            create: (context) => ProfileSetupCubit(firebaseRepository: FirebaseRepository()),
            child: const ProfileSetupPage(),
          ),
          settings: settings,
        );
      case ROUTE_HOMEPAGE:
        return FadePageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => LoginCubit(firebaseRepository: FirebaseRepository())),
              BlocProvider(create: (context) => HomeCubit(firebaseRepository: FirebaseRepository())),
            ],
            child: const HomePage(),
          ),
          settings: settings,
        );
      case ROUTE_CHATSCREEN:
        return SlideRightPageRoute(
          child: BlocProvider(
            create: (context) => ChatCubit(firebaseRepository: FirebaseRepository()),
            child: const ChatScreen(),
          ),
          settings: settings,
        );
      case ROUTE_SELECT_USER_TO_CHAT_SCREEN:
        return SlideRightPageRoute(child: const SelectUserToChat(), settings: settings);
      default:
        return null;
    }
  }
}
