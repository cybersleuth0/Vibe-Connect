import 'dart:ui' as dart_ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'isMe': false, 'text': 'Hey! How are you doing?', 'time': '10:00 AM'},
    {
      'isMe': true,
      'text': 'I am doing great! Just working on this cool Flutter app.',
      'time': '10:01 AM',
    },
    {
      'isMe': false,
      'text': 'That sounds awesome! Show me the UI.',
      'time': '10:02 AM',
    },
    {
      'isMe': true,
      'text': 'Here it is! It has a liquid glass effect and neon vibes.',
      'time': '10:03 AM',
    },
    {'isMe': true, 'text': '\u{1F525}\u{1F525}', 'time': '10:03 AM'},
  ];

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed from HomePage
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final name = args?['name'] ?? 'User';
    final avatar = args?['avatar'] ?? '';
    final initials = args?['initials'] ?? name.substring(0, 1);

    return Container(
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
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      color: Colors.deepPurple.shade800,
                      image: avatar.toString().startsWith('http')
                          ? DecorationImage(
                              image: NetworkImage(avatar),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: avatar.toString().startsWith('http')
                        ? null
                        : Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF69F0AE),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xff0A1832),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color(0xFF69F0AE),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.videocam_outlined, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.call_outlined, color: Colors.white),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: BackdropFilter(
                  filter: dart_ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff0A1832).withValues(alpha: 0.3),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isMe = msg['isMe'] as bool;
                        return RepaintBoundary(
                          child: Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child:
                                Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                            0.75,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? const Color(
                                                0xFFD96FF8,
                                              ).withValues(alpha: 0.2)
                                            : Colors.white.withValues(
                                                alpha: 0.1,
                                              ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20),
                                          topRight: const Radius.circular(20),
                                          bottomLeft: isMe
                                              ? const Radius.circular(20)
                                              : Radius.zero,
                                          bottomRight: isMe
                                              ? Radius.zero
                                              : const Radius.circular(20),
                                        ),
                                        border: Border.all(
                                          color: isMe
                                              ? const Color(
                                                  0xFFD96FF8,
                                                ).withValues(alpha: 0.3)
                                              : Colors.white.withValues(
                                                  alpha: 0.1,
                                                ),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            msg['text'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            msg['time'],
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.5,
                                              ),
                                              fontSize: 10,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(duration: 300.ms)
                                    .slideY(begin: 0.1),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Input Area with Glass Effect
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: dart_ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFFD96FF8),
                            ),
                            onPressed: () {},
                          ),
                          Expanded(
                            child: TextField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _messageController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                              decoration: InputDecoration(
                                hintText: 'Type a vibe...',
                                hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontFamily: 'Poppins',
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.mic_none_outlined,
                              color: Colors.white70,
                            ),
                            onPressed: () {},
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFD96FF8), Color(0xFF6A1B9A)],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () {
                                if (_messageController.text.isNotEmpty) {
                                  setState(() {
                                    _messages.add({
                                      'isMe': true,
                                      'text': _messageController.text,
                                      'time':
                                          '${DateTime.now().hour}:${DateTime.now().minute}',
                                    });
                                    _messageController.clear();
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
