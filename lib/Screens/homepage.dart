import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.message, 'label': 'Message'},
    {'icon': Icons.call, 'label': 'Calls'},
    {'icon': Icons.contacts, 'label': 'Contacts'},
    {'icon': Icons.settings, 'label': 'Settings'},
  ];

  final List<Map<String, dynamic>> chats = [
    {
      'name': 'Sarah Johnson',
      'message': 'Hey! Are we still meeting tomorrow?',
      'time': '2:30 PM',
      'unread': 2,
      'online': true,
      'avatar': 'SJ',
    },
    {
      'name': 'Mike Wilson',
      'message': 'Thanks for the help!',
      'time': '1:45 PM',
      'unread': 0,
      'online': false,
      'avatar': 'MW',
      'read': true,
    },
    {
      'name': 'Emma Davis',
      'message': 'Can you send me the files?',
      'time': '12:20 PM',
      'unread': 5,
      'online': true,
      'avatar': 'ED',
    },
    {
      'name': 'John Smith',
      'message': 'See you later!',
      'time': '11:00 AM',
      'unread': 0,
      'online': false,
      'avatar': 'JS',
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Light gray
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppBar(
            backgroundColor: Colors.white,
            // White AppBar for contrast
            elevation: 0.5,
            // Subtle shadow
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.deepPurple.shade100,
                child: Icon(Icons.person, size: 20, color: Colors.deepPurple),
              ),
            ),
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  // Open search
                },
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      chat['avatar'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (chat['online'] == true)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              title: Text(
                chat['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              subtitle: Row(
                children: [
                  if (chat['read'] == true)
                    const Icon(Icons.done_all, size: 16, color: Colors.blue),
                  if (chat['read'] == true) const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      chat['message'],
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    chat['time'],
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  if (chat['unread'] > 0) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${chat['unread']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              onTap: () {
                // Navigate to chat screen
              },
            ),
          );
        },
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) => _buildNavItem(index)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _selectedIndex == index;
    final item = _navItems[index];

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        splashColor: const Color(0xFF075E54).withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with badge (for demo, showing badge on Chats)
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                      item['icon'],
                      color: isSelected ? Colors.deepPurpleAccent : Colors.grey.shade600,
                      size: 24,
                    )
                    .animate(target: isSelected ? 1 : 0)
                    .scale(
                      duration: 200.ms,
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      curve: Curves.easeOut,
                    ),

                // Badge (only on first item for demo)
                if (index == 0 && !isSelected)
                  Positioned(
                    right: -8,
                    top: -4,
                    child:
                        Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF6A1B9A),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: const Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                            .animate()
                            .scale(duration: 300.ms, curve: Curves.elasticOut)
                            .then(delay: 2000.ms)
                            .shake(hz: 2, duration: 500.ms),
                  ),
              ],
            ),

            const SizedBox(height: 4),

            // Label
            Text(
              item['label'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF6A1B9A) : Colors.grey.shade600,
              ),
            ).animate(target: isSelected ? 1 : 0).fadeIn(duration: 200.ms),
          ],
        ),
      ),
    );
  }
}
