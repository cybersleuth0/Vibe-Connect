import 'dart:ui' as dart_ui;

import '../../../utils/app_constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Updated icons to be filled/outlined based on selection for a modern touch
  final List<Map<String, dynamic>> _navItems = [
    {
      'icon': Icons.message_outlined,
      'activeIcon': Icons.message_rounded,
      'label': 'Chats',
    },
    {
      'icon': Icons.call_outlined,
      'activeIcon': Icons.call_rounded,
      'label': 'Calls',
    },
    {
      'icon': Icons.people_outline_rounded,
      'activeIcon': Icons.people_rounded,
      'label': 'People',
    },
    {
      'icon': Icons.settings_outlined,
      'activeIcon': Icons.settings_rounded,
      'label': 'Settings',
    },
  ];

  final List<Map<String, dynamic>> chats = [
    {
      'name': 'Sarah Johnson',
      'message': 'Omg you have to see this! \u{1F525}', // Fire emoji
      'time': '2 min ago',
      'unread': 3,
      'online': true,
      'avatar':
          'https://i.pravatar.cc/150?u=1', // Using placeholder URLs for "Rich" feel
      'initials': 'SJ',
    },
    {
      'name': 'Mike Wilson',
      'message': 'Voice message (0:15)',
      'time': '15 min ago',
      'unread': 0,
      'online': true,
      'avatar': 'https://i.pravatar.cc/150?u=2',
      'initials': 'MW',
      'isVoice': true,
      'read': true,
    },
    {
      'name': 'Emma Davis',
      'message': 'Sent a photo',
      'time': '1h ago',
      'unread': 1,
      'online': false,
      'avatar': 'https://i.pravatar.cc/150?u=3',
      'initials': 'ED',
      'isPhoto': true,
    },
    {
      'name': 'John Smith',
      'message': 'See you at the party! \u{1F389}',
      'time': '2h ago',
      'unread': 0,
      'online': false,
      'avatar': 'https://i.pravatar.cc/150?u=4',
      'initials': 'JS',
      'read': true,
    },
    {
      'name': 'Alex Chen',
      'message': 'Bro, did you check the code?',
      'time': 'Yesterday',
      'unread': 0,
      'online': false,
      'avatar': 'https://i.pravatar.cc/150?u=5',
      'initials': 'AC',
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // Gen Z Vibe: Rich Dark Gradient Background matching Onboarding
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff2E0249),
            Color(0xff0A1832),
          ], // Deep Purple to Dark Blue
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // Make Scaffold transparent to show gradient
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vibe Connect',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 28,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
                Text(
                  'Online',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.greenAccent.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
              ],
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
            ).animate().scale(delay: 400.ms, duration: 400.ms),
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ).animate().scale(delay: 500.ms, duration: 400.ms),
          ],
        ),
        body: Column(
          children: [
            // Story/Status Horizontal Scroll (Very Gen Z)
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: chats.length + 1, // +1 for "My Status"
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // INLINED: _buildMyStatus
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
                                  border: Border.all(
                                    color: Colors.grey.shade500,
                                    width: 2,
                                  ),
                                  image: const DecorationImage(
                                    // Placeholder for current user
                                    image: NetworkImage(
                                      'https://i.pravatar.cc/150?u=0',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Fallback handled by Image.network usually, simplified here.
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.transparent,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'My Vibe',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ).animate().scale(duration: 400.ms),
                    );
                  }
                  // INLINED: _buildStoryItem
                  final user = chats[index - 1];
                  return RepaintBoundary(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child:
                          Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFD96FF8),
                                          Color(0xFF69F0AE),
                                        ], // Neon Purple to Green
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        backgroundImage:
                                            user['avatar']
                                                .toString()
                                                .startsWith('http')
                                            ? NetworkImage(user['avatar'])
                                            : null,
                                        backgroundColor:
                                            Colors.deepPurple.shade900,
                                        child:
                                            user['avatar']
                                                .toString()
                                                .startsWith('http')
                                            ? null
                                            : Text(
                                                user['initials'] ??
                                                    user['name']
                                                        .toString()
                                                        .substring(0, 1),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    user['name'].split(
                                      ' ',
                                    )[0], // First name only
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(delay: (index * 100).ms)
                              .slideX(begin: 0.2),
                    ),
                  );
                },
              ),
            ),

            // Main Chat List
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: BackdropFilter(
                  filter: dart_ui.ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ), // Liquid glass blur,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 20, bottom: 80),
                    // Space for bottom nav
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      // INLINED: _buildChatTile
                      final chat = chats[index];
                      return RepaintBoundary(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            // Glassy effect
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.ROUTE_CHATSCREEN,
                                arguments: chat,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  // Avatar
                                  Stack(
                                    children: [
                                      Container(
                                        width: 55,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          // Squircle
                                          image:
                                              chat['avatar']
                                                  .toString()
                                                  .startsWith('http')
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                    chat['avatar'],
                                                  ),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                          color: Colors.deepPurple.shade800,
                                        ),
                                        child: Center(
                                          child:
                                              chat['avatar']
                                                  .toString()
                                                  .startsWith('http')
                                              ? null
                                              : Text(
                                                  (chat['initials'] ??
                                                      chat['name']
                                                          .toString()
                                                          .substring(0, 1)),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      if (chat['online'] == true)
                                        Positioned(
                                          top: -2,
                                          right: -2,
                                          child: Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF69F0AE),
                                              // Neon Green
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: const Color(0xff0A1832),
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFF69F0AE,
                                                  ).withValues(alpha: 0.5),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              chat['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              chat['time'],
                                              style: TextStyle(
                                                color: Colors.white.withValues(
                                                  alpha: 0.5,
                                                ),
                                                fontSize: 11,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            if (chat['read'] == true)
                                              Icon(
                                                Icons.done_all,
                                                size: 16,
                                                color: Colors.blue.shade300,
                                              ),
                                            if (chat['read'] == true)
                                              const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                chat['message'],
                                                style: TextStyle(
                                                  color: chat['unread'] > 0
                                                      ? Colors.white
                                                      : Colors.white70,
                                                  fontSize: 13,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: chat['unread'] > 0
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (chat['unread'] > 0)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  left: 8,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFFD96FF8),
                                                          Color(0xFF6A1B9A),
                                                        ],
                                                      ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                        0xFFD96FF8,
                                                      ).withValues(alpha: 0.4),
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
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
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        // Floating Custom Bottom Navigation
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child:
              ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: BackdropFilter(
                  filter: dart_ui.ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ), // Liquid glass blur
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      // Gradient for "glossy" look
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                      color: const Color(0xff0A1832).withValues(alpha: 0.3),
                      // More transparent for glass
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ), // Slightly thicker border for "glass edge"
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_navItems.length, (index) {
                        final isSelected = _selectedIndex == index;
                        final item = _navItems[index];
                        return GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: AnimatedContainer(
                            duration: 250.ms,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: isSelected
                                ? BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  )
                                : const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSelected
                                      ? (item['activeIcon'] as IconData)
                                      : (item['icon'] as IconData),
                                  key: ValueKey(isSelected),
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade300,
                                  size: 24,
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    item['label'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                    ),
                                  ).animate().fadeIn(duration: 200.ms),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ).animate().slideY(
                begin: 1,
                duration: 500.ms,
                curve: Curves.easeOutBack,
              ),
        ),
      ),
    );
  }
}
