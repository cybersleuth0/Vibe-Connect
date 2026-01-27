import "dart:ui" as dart_ui;

import "../../../utils/app_constants/app_constants.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";

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

  final List<Map<String, dynamic>> chats = [
    {
      "id": "1",
      "name": "Sarah Johnson",
      "message": "Omg you have to see this! \u{1F525}",
      "time": "2 min ago",
      "unread": 3,
      "online": true,
      "avatar": "https://i.pravatar.cc/150?u=1",
      "initials": "SJ",
    },
    {
      "id": "2",
      "name": "Mike Wilson",
      "message": "Voice message (0:15)",
      "time": "15 min ago",
      "unread": 0,
      "online": true,
      "avatar": "https://i.pravatar.cc/150?u=2",
      "initials": "MW",
      "isVoice": true,
      "read": true,
    },
    {
      "id": "3",
      "name": "Emma Davis",
      "message": "Sent a photo",
      "time": "1h ago",
      "unread": 1,
      "online": false,
      "avatar": "https://i.pravatar.cc/150?u=3",
      "initials": "ED",
      "isPhoto": true,
    },
    {
      "id": "4",
      "name": "John Smith",
      "message": "See you at the party! \u{1F389}",
      "time": "2h ago",
      "unread": 0,
      "online": false,
      "avatar": "https://i.pravatar.cc/150?u=4",
      "initials": "JS",
      "read": true,
    },
    {
      "id": "5",
      "name": "Alex Chen",
      "message": "Bro, did you check the code?",
      "time": "Yesterday",
      "unread": 0,
      "online": false,
      "avatar": "https://i.pravatar.cc/150?u=5",
      "initials": "AC",
      "read": true,
    },
  ];

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
                          style: TextStyle(fontFamily: "Pacifico", fontSize: 28, color: Colors.white, letterSpacing: 1),
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
            // Container(
            //   margin: const EdgeInsets.only(right: 16),
            //   decoration: BoxDecoration(
            //     color: Colors.white.withValues(alpha: 0.1),
            //     shape: BoxShape.circle,
            //     border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            //   ),
            //   child: const Padding(
            //     padding: EdgeInsets.all(8.0),
            //     child: Icon(Icons.person, color: Colors.white),
            //   ),
            // ).animate().scale(delay: 500.ms, duration: 400.ms),
          ],
        ),
        body: Column(
          children: [
            // Story/Status
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: chats.length + 1,
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
                                    image: NetworkImage("https://i.pravatar.cc/150?u=0"),
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
                  final user = chats[index - 1];
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
                                tag: 'avatar_story_${user['id']}',
                                child: CircleAvatar(
                                  backgroundImage: user["avatar"].toString().startsWith("http")
                                      ? NetworkImage(user["avatar"])
                                      : null,
                                  backgroundColor: Colors.deepPurple.shade900,
                                  child: user["avatar"].toString().startsWith("http")
                                      ? null
                                      : Text(
                                          user["initials"] ?? user["name"].toString().substring(0, 1),
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            user["name"].split(" ")[0],
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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                child: BackdropFilter(
                  filter: dart_ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff0A1832).withValues(alpha: 0.4),
                      border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 1)),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 20, bottom: 100),
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        // Basic filtering logic (optional, for visual demo)
                        if (_isSearching &&
                            !chat["name"].toString().toLowerCase().contains(_searchController.text.toLowerCase())) {
                          return const SizedBox.shrink();
                        }

                        return RepaintBoundary(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.ROUTE_CHATSCREEN, arguments: chat);
                              },
                              splashColor: Colors.white.withValues(alpha: 0.1),
                              highlightColor: Colors.white.withValues(alpha: 0.05),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                child: Row(
                                  children: [
                                    // Hero Avatar
                                    Hero(
                                      tag: 'avatar_chat_${chat['id']}',
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 58,
                                            height: 58,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              image: chat["avatar"].toString().startsWith("http")
                                                  ? DecorationImage(
                                                      image: NetworkImage(chat["avatar"]),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null,
                                              color: Colors.deepPurple.shade800,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.2),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: chat["avatar"].toString().startsWith("http")
                                                ? null
                                                : Center(
                                                    child: Text(
                                                      (chat["initials"] ?? chat["name"].toString().substring(0, 1)),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                          if (chat["online"] == true)
                                            Positioned(
                                              top: -2,
                                              right: -2,
                                              child: Container(
                                                width: 16,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF69F0AE),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: const Color(0xff0A1832), width: 2.5),
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
                                                chat["name"],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  fontFamily: "Poppins",
                                                  color: Colors.white,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              Text(
                                                chat["time"],
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
                                              if (chat["read"] == true)
                                                const Icon(Icons.done_all, size: 16, color: Color(0xFF69F0AE)),
                                              if (chat["read"] == true) const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  chat["message"],
                                                  style: TextStyle(
                                                    color: chat["unread"] > 0
                                                        ? Colors.white
                                                        : Colors.white.withValues(alpha: 0.6),
                                                    fontSize: 13,
                                                    fontFamily: "Poppins",
                                                    fontWeight: chat["unread"] > 0
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if (chat["unread"] > 0)
                                                Container(
                                                  margin: const EdgeInsets.only(left: 8),
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    gradient: const LinearGradient(
                                                      colors: [Color(0xFFD96FF8), Color(0xFF6A1B9A)],
                                                    ),
                                                    borderRadius: BorderRadius.circular(12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(0xFFD96FF8).withValues(alpha: 0.4),
                                                        blurRadius: 6,
                                                        offset: const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    '${chat['unread']}',
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
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: (index * 50).ms).slideY(begin: 0.1);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
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
                    BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 25, offset: const Offset(0, 10)),
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
    );
  }
}
