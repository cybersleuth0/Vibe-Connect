import '../../../utils/AppConstants/appconstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Navigate after animations complete (500ms fade + 700ms scale = 1200ms or 1.2 seconds)
    Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.ROUTE_ONBOARDINGPAGE);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: "splash",
          child:
              const Text.rich(
                    TextSpan(
                      text: "Vibe",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                      children: [
                        TextSpan(
                          text: " Connect",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.deepPurple,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fade(duration: 500.ms)
                  .scale(
                    delay: 600.ms,
                    duration: 1200.ms,
                    begin: const Offset(0.1, 0.1),
                    curve: Curves.elasticOut,
                  ), // Add fade and scale animations
        ),
      ),
    );
  }
}