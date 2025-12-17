import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/AppConstants/appconstants.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Login In to vibeConnect
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Log in to ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Hero(
                    tag: "splash",
                    child: const Text.rich(
                      TextSpan(
                        text: "Vibe",
                        style: TextStyle(
                          fontFamily: "Pacifico",
                          color: Colors.deepPurple,
                          fontSize: 25,
                          // fontWeight: FontWeight.w900,
                        ),
                        children: [
                          TextSpan(
                            text: " Connect",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 500.ms),
                  ),
                ],
              ).animate().slideX(duration: 500.ms, begin: -1),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              //Welcome Text
              const Text(
                "Welcome back! Sign in using your social account or email to continue us",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                  letterSpacing: 1.2,
                ),
              ).animate().fade(duration: 600.ms, delay: 200.ms),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              //icons for login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1.0),
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "lib/assets/icons/Facebook.svg",
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                  ).animate().scale(duration: 400.ms, delay: 300.ms),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1.0),
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "lib/assets/icons/Google_Pay.svg",
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                  ).animate().scale(duration: 400.ms, delay: 400.ms),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1.0),
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "lib/assets/icons/Apple.svg",
                          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                  ).animate().scale(duration: 400.ms, delay: 500.ms),
                ],
              ),
              // horizontal line
              const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              //login with mail
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Mail",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xff24786d), // Fixed hex color typo
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                        hintText: "Enter your email",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.green, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ).animate().slideX(duration: 500.ms, begin: -1, delay: 600.ms),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              //textbox with password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Password",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xff24786d), // Fixed hex color typo
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                        hintText: "Enter your password",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.green, width: 2),
                        ),
                        suffixIcon: const Icon(
                          Icons.visibility_off_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ).animate().slideX(duration: 500.ms, begin: 1, delay: 700.ms),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.ROUTE_HOMEPAGE,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Color(0xff0A1832),
                    ),
                  ),
                ),
              ).animate().slideY(duration: 500.ms, begin: 1, delay: 800.ms),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              //forget password,
              const SafeArea(
                child: Text(
                  "Forget Password ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff24786D),
                    fontFamily: 'Poppins',
                  ),
                ),
              ).animate().fade(duration: 500.ms, delay: 900.ms),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Don't have an account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.ROUTE_SIGNUPPAGE,
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff24786D),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ).animate().fade(duration: 500.ms, delay: 1000.ms),
            ],
          ),
        ),
      ),
    );
  }
}