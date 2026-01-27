import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../../../utils/app_constants/app_constants.dart";

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff43116A), Color(0xff0A1832)], // Deep Purple to Dark Blue (Harmonized)
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Hero(
              tag: "hero_logo_text", // Unified Tag
              child: Material(
                type: MaterialType.transparency,
                child: Text.rich(
                  TextSpan(
                    text: "Vibe",
                    style: TextStyle(
                      fontFamily: "Pacifico",
                      color: Color(0xFFD96FF8), // Neon Purple
                      fontSize: 30,
                    ),
                    children: [
                      TextSpan(
                        text: " Connect",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Color(0xFF69F0AE), // Neon Green
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Headline
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: const Text(
                    "Connect friends\neasily & quickly",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      wordSpacing: 2,
                      letterSpacing: 2,
                      height: 1.2,
                    ),
                  ).animate().fade(duration: 800.ms).slideY(duration: 800.ms, begin: 0.2, curve: Curves.easeOut),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Our chat app is the perfect way to stay connected with friends and family.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ).animate().fade(delay: 300.ms, duration: 600.ms),

              SizedBox(height: MediaQuery.of(context).size.height * 0.08),

              // Social Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Facebook
                  Hero(
                    tag: "hero_social_facebook",
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.0),
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset("lib/assets/icons/Facebook.svg", height: 30, width: 30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Google
                  Hero(
                    tag: "hero_social_google",
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.0),
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset("lib/assets/icons/Google_Pay.svg", height: 30, width: 30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Apple
                  Hero(
                    tag: "hero_social_apple",
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.0),
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "lib/assets/icons/Apple.svg",
                            height: 30,
                            width: 30,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().fade(delay: 500.ms, duration: 600.ms).slideY(begin: 0.2),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              // OR Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.2), thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.2), thickness: 1)),
                  ],
                ),
              ).animate().fade(delay: 700.ms),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              // Sign Up Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.white.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.ROUTE_SIGNUPPAGE);
                    },
                    child: const Text(
                      "Sign Up with Mail",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0A1832),
                      ),
                    ),
                  ),
                ),
              ).animate().fade(delay: 800.ms).slideY(begin: 0.2),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // Existing Account
              InkWell(
                onTap: () => Navigator.pushNamed(context, AppRoutes.ROUTE_SIGNINPAGE),
                child: Text.rich(
                  TextSpan(
                    text: "Existing account? ",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    children: const [
                      TextSpan(
                        text: "Log in",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ).animate().fade(delay: 900.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
