import "package:vibe_connect/screens/auth/profile_setup_cubit/profile_setup_cubit.dart";
import "package:vibe_connect/screens/auth/profile_setup_cubit/profile_setup_state.dart";
import "package:vibe_connect/utils/app_constants/app_constants.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  int _shakeTrigger = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.read<ProfileSetupCubit>().updateProfile(
          userId: user.uid,
          name: _nameController.text,
          phone: _phoneController.text,
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User not found. Please log in again.")));
        Navigator.pushReplacementNamed(context, AppRoutes.ROUTE_SIGNINPAGE);
      }
    } else {
      setState(() {
        _shakeTrigger++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff43116A), Color(0xff0A1832)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // No going back from here
          title: const Text(
            "Complete Profile",
            style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocConsumer<ProfileSetupCubit, ProfileSetupState>(
            listener: (context, state) {
              if (state is ProfileSetupSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Profile updated!"), backgroundColor: Colors.green));
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.ROUTE_HOMEPAGE, (route) => false);
              } else if (state is ProfileSetupFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Error: ${state.error}"), backgroundColor: Colors.red));
              }
            },
            builder: (context, state) {
              final bool isLoading = state is ProfileSetupLoading;

              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    // --- Profile Pic Placeholder ---
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
                            ),
                            child: const Icon(Icons.person, size: 50, color: Colors.white54),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFD96FF8), // Neon Purple
                              ),
                              child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                    // --- Form ---
                    Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Name
                              const Text(
                                "Full Name",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline, color: Colors.white70),
                                  hintText: "Enter your full name",
                                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.05),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: const BorderSide(color: Color(0xFFD96FF8), width: 1.5),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide(color: Colors.red.shade400.withValues(alpha: 0.7), width: 1),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) return "Name is required";
                                  if (value.length < 2) return "Name too short";
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Phone
                              const Text(
                                "Phone Number",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _phoneController,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.phone_outlined, color: Colors.white70),
                                  hintText: "Enter your phone number",
                                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.05),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: const BorderSide(color: Color(0xFFD96FF8), width: 1.5),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide(color: Colors.red.shade400.withValues(alpha: 0.7), width: 1),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) return "Phone number is required";
                                  if (value.length < 10) return "Invalid phone number";
                                  return null;
                                },
                              ),

                              SizedBox(height: MediaQuery.of(context).size.height * 0.06),

                              // Save Button
                              ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      backgroundColor: Colors.white,
                                      disabledBackgroundColor: Colors.white,
                                      disabledForegroundColor: const Color(0xff0A1832),
                                      foregroundColor: const Color(0xff0A1832),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                    ),
                                    onPressed: isLoading ? null : () => _handleSubmit(context),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0A1832)),
                                            ),
                                          )
                                        : const Text(
                                            "Continue",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                  )
                                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                                  .shimmer(
                                    duration: 3000.ms,
                                    delay: 1500.ms,
                                    color: const Color(0xFF69F0AE).withValues(alpha: 0.3),
                                  ),
                            ],
                          ),
                        )
                        .animate(target: _shakeTrigger > 0 ? 1 : 0)
                        .shake(hz: 4, curve: Curves.easeInOutCubic, duration: 400.ms)
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOut),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
