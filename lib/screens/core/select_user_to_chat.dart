
import "package:chat_app/data/models/user_model.dart";
import "package:chat_app/data/remote/repository/firebase_repository.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";

import "../../../utils/app_constants/app_constants.dart";

class SelectUserToChat extends StatefulWidget {
  const SelectUserToChat({super.key});

  @override
  State<SelectUserToChat> createState() => _SelectUserToChatState();
}

class _SelectUserToChatState extends State<SelectUserToChat> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late Future<QuerySnapshot<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = FirebaseRepository.getAllUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isSearching
                ? Container(
                    height: 45,
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
                        hintText: "Search users...",
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
                : const Text(
                    "New Message",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(duration: 400.ms),
          ),
          actions: [
            if (!_isSearching)
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () => setState(() => _isSearching = true),
              ).animate().scale(duration: 400.ms),
            const SizedBox(width: 8),
          ],
        ),
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: _usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)),
              );
            } else if (snapshot.hasData) {
              final currentUser = FirebaseRepository.firebaseAuth.currentUser;
              final users = snapshot.data!.docs
                  .map((doc) => UserModel.fromDoc(doc.data()))
                  .where((user) => user.userId != currentUser?.uid)
                  .toList();

              if (users.isEmpty) {
                return const Center(
                  child: Text("No users found", style: TextStyle(color: Colors.white)),
                );
              }

              return ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff0A1832).withValues(alpha: 0.8),
                    border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1)),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      if (_isSearching &&
                          !(user.name ?? "").toLowerCase().contains(_searchController.text.toLowerCase())) {
                        return const SizedBox.shrink();
                      }

                      final avatarUrl =
                          "https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.name ?? 'User')}&background=random";

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.ROUTE_CHATSCREEN,
                              arguments: {"name": user.name, "avatar": avatarUrl, "id": user.userId},
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 54,
                                      height: 54,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.network("$avatarUrl&format=png", fit: BoxFit.cover),
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
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name ?? "User",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          fontFamily: "Poppins",
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        user.email ?? "",
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.5),
                                          fontSize: 13,
                                          fontFamily: "Poppins",
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.3)),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: (index * 30).ms).slideX(begin: 0.1);
                    },
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          itemCount: 8,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(18),
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
        .shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.05));
  }
}
