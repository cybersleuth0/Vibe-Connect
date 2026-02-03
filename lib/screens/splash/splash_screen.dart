import "../../../utils/app_constants/app_constants.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Navigate after animations complete
    Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.ROUTE_ONBOARDINGPAGE);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff2E0249), Color(0xff0A1832)], // Deep Purple to Dark Blue
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child:
              const Hero(
                    tag: "hero_logo_text", // Unified Tag
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text.rich(
                        TextSpan(
                          text: "Vibe",
                          style: TextStyle(
                            fontFamily: "Pacifico",
                            color: Color(0xFFD96FF8), // Neon Purple
                            fontSize: 40, // Slightly larger for Splash
                          ),
                          children: [
                            TextSpan(
                              text: " Connect",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                color: Color(0xFF69F0AE), // Neon Green
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fade(duration: 800.ms)
                  .scale(
                    delay: 300.ms,
                    duration: 1200.ms,
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.elasticOut,
                  ),
        ),
      ),
    );
  }
}
