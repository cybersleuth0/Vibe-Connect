import "dart:ui" as dart_ui;

import "package:vibe_connect/screens/auth/login_cubit/login_cubit.dart";
import "package:vibe_connect/screens/auth/login_cubit/login_state.dart";
import "package:vibe_connect/screens/core/home_cubit/home_cubit.dart";
import "package:vibe_connect/screens/core/home_cubit/home_state.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

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

  final List<Map<String, dynamic>> _navItems = [
    {"icon": Icons.message_outlined, "activeIcon": Icons.message_rounded, "label": "Chats"},
    {"icon": Icons.call_outlined, "activeIcon": Icons.call_rounded, "label": "Calls"},
    {"icon": Icons.people_outline_rounded, "activeIcon": Icons.people_rounded, "label": "People"},
    {"icon": Icons.settings_outlined, "activeIcon": Icons.settings_rounded, "label": "Settings"},
  ];

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadChatRooms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

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
                  ? Container(
                      height: 45,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (value) => setState(() {}),
                        style: const TextStyle(color: Colors.white, fontFamily: "Poppins", fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Search conversations...",
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontFamily: "Poppins",
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 20),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 18),
                            onPressed: () {
                              setState(() {
                                _isSearching = false;
                                _searchController.clear();
                              });
                            },
                          ),
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
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: PopupMenuButton(
                  position: PopupMenuPosition.under,
                  offset: const Offset(0, 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: const Color(0xff0A1832).withValues(alpha: 0.95),
                  elevation: 8,
                  icon: const Icon(Icons.more_vert_outlined, color: Colors.white),
                  onSelected: (value) {
                    if (value == "logout") {
                      context.read<LoginCubit>().logout();
                    }
                  },
                  itemBuilder: (_) {
                    return const [
                      PopupMenuItem(
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
                ),
              ).animate().scale(delay: 500.ms, duration: 400.ms),
            ],
          ),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                // Loading Spinner
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
              } else if (state is HomeError) {
                return Center(
                  child: Text("Error: ${state.error}", style: const TextStyle(color: Colors.white)),
                );
              } else if (state is HomeLoaded) {
                final chatRoomsWithUsers = state.chatRooms;

                if (chatRoomsWithUsers.isEmpty) {
                  return const Center(
                    child: Text("No chats yet. Start vibing!", style: TextStyle(color: Colors.white)),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff0A1832).withValues(alpha: 0.8),
                        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1)),
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 10, bottom: 100),
                        itemCount: chatRoomsWithUsers.length,
                        itemBuilder: (context, index) {
                          final item = chatRoomsWithUsers[index];
                          final chatRoom = item.chatRoom;
                          final user = item.user;

                          // Basic filtering logic
                          if (_isSearching &&
                              !(user.name ?? "").toLowerCase().contains(_searchController.text.toLowerCase())) {
                            return const SizedBox.shrink();
                          }

                          final avatarUrl =
                              "https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.name ?? 'User')}&background=random";

                          final lastMessageTime = chatRoom.lastMessageTime != null
                              ? DateFormat("h:mm a").format(chatRoom.lastMessageTime!)
                              : "";

                          return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.ROUTE_CHATSCREEN,
                                      arguments: {"name": user.name, "avatar": avatarUrl, "id": user.userId},
                                    );
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        // Avatar with Online Status
                                        Stack(
                                          children: [
                                            Container(
                                              width: 54,
                                              height: 54,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(18),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withValues(alpha: 0.2),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(18),
                                                child: Image.network(
                                                  "$avatarUrl&format=png",
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey.withValues(alpha: 0.3),
                                                      child: const Icon(Icons.person, color: Colors.white),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            if (user.isOnline)
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                  width: 14,
                                                  height: 14,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF69F0AE),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: const Color(0xff0A1832), width: 2),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(0xFF69F0AE).withValues(alpha: 0.5),
                                                        blurRadius: 6,
                                                        spreadRadius: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
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
                                                    user.name ?? "User",
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                      fontFamily: "Poppins",
                                                      color: Colors.white,
                                                      letterSpacing: 0.2,
                                                    ),
                                                  ),
                                                  Text(
                                                    lastMessageTime,
                                                    style: TextStyle(
                                                      color: Colors.white.withValues(alpha: 0.4),
                                                      fontSize: 11,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      chatRoom.lastMessage ?? "Start chatting...",
                                                      style: TextStyle(
                                                        color: (chatRoom.unreadCounts?[currentUserId] ?? 0) > 0
                                                            ? Colors.white
                                                            : Colors.white.withValues(alpha: 0.6),
                                                        fontSize: 13,
                                                        fontFamily: "Poppins",
                                                        fontWeight: (chatRoom.unreadCounts?[currentUserId] ?? 0) > 0
                                                            ? FontWeight.w600
                                                            : FontWeight.w400,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if ((chatRoom.unreadCounts?[currentUserId] ?? 0) > 0)
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 8),
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        //color: const Color(0xFFD96FF8),
                                                        color: Colors.green,
                                                        borderRadius: BorderRadius.circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: const Color(0xFFD96FF8).withValues(alpha: 0.3),
                                                            blurRadius: 6,
                                                            offset: const Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Text(
                                                        "${chatRoom.unreadCounts?[currentUserId]}",
                                                        //chatRoom.unreadCounts![currentUserId].toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                        ),
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
                              )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOut);
                        },
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Floating Bottom Navigation
          extendBody: true,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: dart_ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
                              Container(
                                decoration: isSelected
                                    ? BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withValues(alpha: 0.3),
                                            blurRadius: 12,
                                            spreadRadius: -2,
                                          ),
                                        ],
                                      )
                                    : null,
                                child: Icon(
                                  isSelected ? (item["activeIcon"] as IconData) : (item["icon"] as IconData),
                                  key: ValueKey(isSelected),
                                  color: isSelected ? Colors.white : Colors.grey.shade400,
                                  size: 26,
                                ),
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
          floatingActionButton: FloatingActionButton(
            tooltip: "New Message",
            backgroundColor: const Color(0xFFD96FF8),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.ROUTE_SELECT_USER_TO_CHAT_SCREEN);
              HapticFeedback.lightImpact();
            },
            child: Icon(Icons.add, color: Colors.white.withValues(alpha: 0.8)),
          ).animate().slideY(begin: 1, duration: 600.ms, curve: Curves.easeOutBack),
        ),
      ),
    );
  }
}
