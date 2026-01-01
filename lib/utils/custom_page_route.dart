import 'package:flutter/material.dart';

// 1. Fade transition - Smooth and eliminates white flash
class FadePageRoute extends PageRouteBuilder {
  final Widget child;

  FadePageRoute({required this.child, super.settings})
    : super(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
}

// 2. Slide from Right (iOS style)
class SlideRightPageRoute extends PageRouteBuilder {
  final Widget child;

  SlideRightPageRoute({required this.child, super.settings})
    : super(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Slide from right
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
}

// 3. Slide from Bottom (Material style)
class SlideUpPageRoute extends PageRouteBuilder {
  final Widget child;

  SlideUpPageRoute({required this.child, super.settings})
    : super(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0); // Slide from bottom
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
}

// 4. Scale transition - Zoom effect
class ScalePageRoute extends PageRouteBuilder {
  final Widget child;

  ScalePageRoute({required this.child, super.settings})
    : super(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      );
}

// 5. Rotation + Fade (Fancy effect)
class RotationPageRoute extends PageRouteBuilder {
  final Widget child;

  RotationPageRoute({required this.child, super.settings})
    : super(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return RotationTransition(
            turns: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      );
}

// 6. Slide + Fade combo (Modern and smooth)
class SlideFadePageRoute extends PageRouteBuilder {
  final Widget child;

  SlideFadePageRoute({required this.child, super.settings})
    : super(
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var slideTween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(slideTween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      );
}

// 7. Scale Down Previous + Slide In New (Modern app style)
class SharedAxisPageRoute extends PageRouteBuilder {
  final Widget child;

  SharedAxisPageRoute({required this.child, super.settings})
    : super(
        transitionDuration: const Duration(milliseconds: 150),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Scale down the old page
          final secondaryScaleAnimation = Tween<double>(
            begin: 1.0,
            end: 0.9,
          ).animate(secondaryAnimation);

          // Slide in the new page
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;

          var slideTween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: Curves.easeInOutCubic));

          return Stack(
            children: [
              // Old page scaling down
              ScaleTransition(
                scale: secondaryScaleAnimation,
                child: Container(),
              ),
              // New page sliding in
              SlideTransition(
                position: animation.drive(slideTween),
                child: FadeTransition(opacity: animation, child: child),
              ),
            ],
          );
        },
      );
}

// 8. No transition - Instant
class InstantPageRoute extends PageRouteBuilder {
  final Widget child;

  InstantPageRoute({required this.child, super.settings})
    : super(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) => child,
      );
}
