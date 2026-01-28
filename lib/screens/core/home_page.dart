import "dart:ui" as dart_ui;

import "package:chat_app/data/models/user_model.dart";
import "package:chat_app/data/remote/repository/firebase_repository.dart";
import "package:chat_app/screens/auth/login_cubit/login_cubit.dart";
import "package:chat_app/screens/auth/login_cubit/login_state.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../utils/app_constants/app_constants.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late Future<QuerySnapshot<Map<String, dynamic>>> _usersFuture;

  final List<Map<String, dynamic>> _navItems = [
    {"icon": Icons.message_outlined, "activeIcon": Icons.message_rounded, "label": "Chats"},
    {"icon": Icons.call_outlined, "activeIcon": Icons.call_rounded, "label": "Calls"},
    {"icon": Icons.people_outline_rounded, "activeIcon": Icons.people_rounded, "label": "People"},
    {"icon": Icons.settings_outlined, "activeIcon": Icons.settings_rounded, "label": "Settings"},
  ];

  @override
  void initState() {
    super.initState();
    _usersFuture = FirebaseRepository.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginInitial) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.ROUTE_SIGNINPAGE, (route) => false);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2E0249), Color(0xff0A1832)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            forceMaterialTransparency: true,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isSearching
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (value) => setState(() {}),
                      style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
                      decoration: InputDecoration(
                        hintText: "Search chats...",
                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontFamily: "Poppins"),
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.search, color: Colors.white54),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _isSearching = false;
                              _searchController.clear();
                            });
                          },
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Vibe Connect",
                            style: TextStyle(
                              fontFamily: "Pacifico",
                              fontSize: 28,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
                          Text(
                            "Online",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: Colors.greenAccent.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
                        ],
                      ),
                    ),
            ),
            actions: [
              if (!_isSearching)
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
                ).animate().scale(delay: 400.ms, duration: 400.ms),
              PopupMenuButton(
                position: PopupMenuPosition.under,
                offset: const Offset(0, 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: const Color(0xff0A1832).withValues(alpha: 0.95),
                elevation: 8,
                onSelected: (value) {
                  if (value == "logout") {
                    context.read<LoginCubit>().logout();
                  }
                },
                itemBuilder: (_) {
                  return [
                    const PopupMenuItem(
                      value: "logout",
                      child: Row(
                        children: [
                          Icon(Icons.logout_rounded, color: Color(0xFFD96FF8), size: 20),
                          SizedBox(width: 12),
                          Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.more_vert_outlined, color: Colors.white),
                  ),
                ).animate().scale(delay: 500.ms, duration: 400.ms),
              ),
            ],
          ),
          body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: _usersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: 6,
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.05), angle: 0.45);
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)),
                );
              } else if (snapshot.hasData) {
                final users = snapshot.data!.docs.map((doc) => UserModel.fromDoc(doc.data())).toList();

                if (users.isEmpty) {
                  return const Center(
                    child: Text("No users found", style: TextStyle(color: Colors.white)),
                  );
                }

                return Column(
                  children: [
                    // Story/Status (Top Horizontal List) - Keeping it for visual flair
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        itemCount: users.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                              "https://ui-avatars.com/api/?name=You&background=random",
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(colors: [Color(0xFFD96FF8), Color(0xFF6A1B9A)]),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.add, color: Colors.white, size: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    "My Vibe",
                                    style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: "Poppins"),
                                  ),
                                ],
                              ).animate().scale(duration: 400.ms),
                            );
                          }
                          final user = users[index - 1];
                          final avatarUrl =
                              "https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.name ?? 'User')}&background=random";

                          return RepaintBoundary(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2.5),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [Color(0xFFD96FF8), Color(0xFF69F0AE)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Container(
                                      width: 55,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black, width: 2),
                                      ),
                                      child: Hero(
                                        tag: "avatar_story_${user.userId}",
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(avatarUrl),
                                          backgroundColor: Colors.deepPurple.shade900,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    user.name != null && user.name!.isNotEmpty
                                        ? user.name![0].toUpperCase() + user.name!.substring(1).split(" ")[0]
                                        : "User",
                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: "Poppins"),
                                  ),
                                ],
                              ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.2),
                            ),
                          );
                        },
                      ),
                    ),

                    // Main Chat List
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                        child: BackdropFilter(
                          filter: dart_ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff0A1832).withValues(alpha: 0.4),
                              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.25), width: 1)),
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 20, bottom: 100),
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                // Basic filtering logic
                                if (_isSearching &&
                                    !(user.name ?? "").toLowerCase().contains(_searchController.text.toLowerCase())) {
                                  return const SizedBox.shrink();
                                }

                                final avatarUrl =
                                    "https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.name ?? 'User')}&background=random";

                                return RepaintBoundary(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.ROUTE_CHATSCREEN,
                                          arguments: {"name": user.name, "avatar": avatarUrl, "id": user.userId},
                                        );
                                      },
                                      splashColor: Colors.white.withValues(alpha: 0.1),
                                      highlightColor: Colors.white.withValues(alpha: 0.05),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                        child: Container(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(width: 1, color: Colors.white.withValues(alpha: 0.08)),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              // Hero Avatar
                                              Hero(
                                                tag: "avatar_chat_${user.userId}",
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: 58,
                                                      height: 58,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12),
                                                        image: DecorationImage(
                                                          image: NetworkImage(avatarUrl),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        color: Colors.deepPurple.shade800,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withValues(alpha: 0.2),
                                                            blurRadius: 8,
                                                            offset: const Offset(0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (user.isOnline)
                                                      Positioned(
                                                        top: -2,
                                                        right: -2,
                                                        child: Container(
                                                          width: 16,
                                                          height: 16,
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFF69F0AE),
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                              color: const Color(0xff0A1832),
                                                              width: 2.5,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: const Color(0xFF69F0AE).withValues(alpha: 0.6),
                                                                blurRadius: 8,
                                                                spreadRadius: 1,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              // Content
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          user.name != null && user.name!.isNotEmpty
                                                              ? user.name![0].toUpperCase() + user.name!.substring(1)
                                                              : "Name",
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 16,
                                                            fontFamily: "Poppins",
                                                            color: Colors.white,
                                                            letterSpacing: 0.3,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Now", // Placeholder for actual last message time
                                                          style: TextStyle(
                                                            color: Colors.white.withValues(alpha: 0.5),
                                                            fontSize: 11,
                                                            fontFamily: "Poppins",
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            user.email ?? "Tap to chat", // Placeholder
                                                            style: TextStyle(
                                                              color: Colors.white.withValues(alpha: 0.6),
                                                              fontSize: 13,
                                                              fontFamily: "Poppins",
                                                              fontWeight: FontWeight.normal,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ).animate().fadeIn(duration: 400.ms, delay: (index * 50).ms).slideY(begin: 0.1),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink(); // Initial state
            },
          ),
          // Floating Bottom Navigation
          extendBody: true,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: dart_ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white.withValues(alpha: 0.15), Colors.white.withValues(alpha: 0.05)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(_navItems.length, (index) {
                      final isSelected = _selectedIndex == index;
                      final item = _navItems[index];
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact(); // Tactile feedback
                          setState(() => _selectedIndex = index);
                        },
                        child: AnimatedContainer(
                          duration: 300.ms,
                          curve: Curves.easeOutBack,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: isSelected
                              ? BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                )
                              : const BoxDecoration(color: Colors.transparent),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSelected ? (item["activeIcon"] as IconData) : (item["icon"] as IconData),
                                key: ValueKey(isSelected),
                                color: isSelected ? Colors.white : Colors.grey.shade400,
                                size: 26,
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                Text(
                                  item["label"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                    fontSize: 12,
                                  ),
                                ).animate().fadeIn(duration: 200.ms).slideX(begin: -0.2),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ).animate().slideY(begin: 1, duration: 600.ms, curve: Curves.easeOutBack),
          ),
        ),
      ),
    );
  }
}
